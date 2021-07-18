import 'package:five_things/constants.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../datas/data.dart';
import '../widgets/task_screen_widget/add_task_widget.dart';
import '../widgets/show_alert.dart';
import '../widgets/task_screen_widget/list_title_widget.dart';
import '../widgets/task_screen_widget/appbar_custom.dart';
import '../widgets/task_screen_widget/date_info_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../widgets/icon_slide_widget.dart';
import './sub_task_screen.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TodoList list = TodoList();
  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized = false;

  TextEditingController controller = TextEditingController();
  String textFeild;
///////////////////////////////////////////////////////////////////////////////
  SlidableController slidableController;
  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

/////////////////////////////////////////////////////////////////
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
  }

  _toggleItem(TodoItem item) {
    setState(() {
      item.done = !item.done;
      _saveToStorage();
    });
  }

  _save() {
    if (textFeild == null) {
      showAlertDialog(context);
    } else {
      _addItem(controller.value.text);
      controller.clear();
      Navigator.pop(context);
    }
  }

  _addItem(String title) {
    setState(() {
      final item = TodoItem(
        id: DateTime.now().millisecondsSinceEpoch,
        bossId: 0,
        title: title,
        done: false,
        prioritize: 1,
      );
      list.items.add(item);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('todos', list.listToJSONEncodable());
  }

  _delete(index) {
    setState(() {
      list.items.removeAt(index);
      list.items.removeWhere((item) => item.bossId == list.items[index].id);
      _saveToStorage();
    });
  }

  _clearAll() {
    setState(() {
      list.items = [];
      _saveToStorage();
    });
  }

  static Widget _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }

/////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: AddTaskWidget(
        controller: controller,
        textOnChanged: (value) {
          textFeild = value;
        },
        saveOnPressed: _save,
      ),
      body: Container(
          color: kBackgroundColor,
          padding: EdgeInsets.all(10.0),
          constraints: BoxConstraints.expand(),
          child: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!initialized) {
                var itemsGet = storage.getItem('todos');

                if (itemsGet != null) {
                  list.items = List<TodoItem>.from(
                    (itemsGet as List).map(
                      (item) => TodoItem(
                        id: item['id'],
                        bossId: item['parentId'],
                        title: item['title'],
                        done: item['done'],
                        prioritize: item['prioritize'],
                      ),
                    ),
                  );
                }
                initialized = true;
              }

              return Padding(
                padding: EdgeInsets.only(top: 40),
                child: ListView(
                  children: <Widget>[
                    DateInfoWidget(
                      date: DateTime.now().day.toString(),
                      month: DateFormat.MMMM().format(DateTime.now()),
                      year: DateTime.now().year.toString(),
                    ),
                    AppbarCustom(
                      deleteOnTap: () {
                        _clearAll();
                      },
                    ),
                    SingleChildScrollView(
                      child: Container(
                        width: w * 9 / 10,
                        height: MediaQuery.of(context).size.height,
                        child: OrientationBuilder(
                            builder: (context, orientation) => buildList(
                                  context,
                                )),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget buildList(
    BuildContext context,
  ) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      itemBuilder: (
        context,
        index,
      ) {
        final item = list.items[index];
        return Slidable(
          key: Key(item.title),
          controller: slidableController,
          actionPane: _getActionPane(index),
          actionExtentRatio: 0.25,
          child: GestureDetector(
            onTap: () => Slidable.of(context)?.renderingMode ==
                    SlidableRenderingMode.none
                ? Slidable.of(context)?.open()
                : Slidable.of(context)?.close(),
            child: ListTitleCustom(
              titleText: item.title,
              valueCheckBox: item.done,
              onChangedCheckBox: (_) {
                _toggleItem(item);
              },
            ),
          ),
          actions: <Widget>[
            IconSlideActionCustom(
              title: 'Delete',
              boderColor: Colors.red,
              onTap: () {
                _delete(index);
              },
              icon: Icons.delete,
            )
          ],
          secondaryActions: <Widget>[
            IconSlideActionCustom(
              title: 'Sub Task',
              boderColor: kFloatButtonColor,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SubTaskScreen(
                          getBossId: list.items[index].id,
                          title: list.items[index].title,
                        )));
              },
              icon: Icons.list,
            )
          ],
        );
      },
      itemCount: list.items.length,
    );
  }
}
