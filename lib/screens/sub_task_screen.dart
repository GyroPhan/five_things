import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:five_things/constants.dart';
import '../datas/data.dart';
import '../widgets/task_screen_widget/add_task_widget.dart';
import '../widgets/show_alert.dart';
import '../widgets/task_screen_widget/list_title_widget.dart';
import '../widgets/task_screen_widget/appbar_custom.dart';
import '../widgets/icon_slide_widget.dart';

class SubTaskScreen extends StatefulWidget {
  int getBossId;
  String title;
  SubTaskScreen({this.getBossId, this.title});
  @override
  _SubTaskScreenState createState() => _SubTaskScreenState();
}

class _SubTaskScreenState extends State<SubTaskScreen> {
  final TodoList subList = TodoList();
  List<TodoItem> filterList = [];

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
        bossId: widget.getBossId,
        title: title,
        done: false,
        prioritize: 1,
      );
      subList.items.add(item);
      filterList.add(item);

      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('subs', subList.listToJSONEncodable());
  }

  _delete(index) {}

  _clearAll() {
    print(filterList);
//    setState(() {
//      subList.items;
//      _saveToStorage();
//    });
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
        saveOnPressed: () {
          _save();
        },
      ),
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text(widget.title),
        actions: [
          AppbarCustom(
            deleteOnTap: () {
              _clearAll();
            },
          ),
        ],
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
                var items = storage.getItem('subs');
                if (items != null) {
                  print(items);
                  subList.items = List<TodoItem>.from(
                    (items as List).map(
                      (item) => TodoItem(
                        id: item['id'],
                        bossId: item['bossId'],
                        title: item['title'],
                        done: item['done'],
                        prioritize: item['prioritize'],
                      ),
                    ),
                  );

                  filterList = subList.items
                      .where((i) => i.bossId == widget.getBossId)
                      .toList();
                }
                initialized = true;
              }

              return Padding(
                padding: EdgeInsets.only(top: 40),
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        width: w * 9 / 10,
                        height: MediaQuery.of(context).size.height - 200,
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

  Widget buildList(BuildContext context) {
    return ListView.builder(
      itemBuilder: (
        context,
        index,
      ) {
        final item = filterList[index];
        return Slidable(
          key: Key(item.title),
          controller: slidableController,
          actionPane: _getActionPane(index),
          actionExtentRatio: 0.25,
          child: GestureDetector(
            onTap: () {
              Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
                  ? Slidable.of(context)?.open()
                  : Slidable.of(context)?.close();
            },
            child: ListTitleCustom(
              titleText: item.title,
              valueCheckBox: item.done,
              onChangedCheckBox: (a) {
                _toggleItem(item);
                print(subList.items[index].bossId);
              },
            ),
          ),
          actions: <Widget>[
            IconSlideActionCustom(
              title: 'Delete',
              boderColor: Colors.red,
              onTap: () {
                setState(() {
                  subList.items.removeAt(index);
                  filterList.removeAt(index);
                  _saveToStorage();
                });
              },
              icon: Icons.delete,
            )
          ],
        );
      },
      itemCount: filterList.length,
    );
  }
}
