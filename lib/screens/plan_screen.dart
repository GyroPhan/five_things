import 'package:five_things/constants.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../datas/data.dart';
import '../widgets/task_screen_widget/add_task_widget.dart';
import '../widgets/show_alert.dart';
import '../widgets/task_screen_widget/list_title_widget.dart';
import '../widgets/task_screen_widget/appbar_custom.dart';
import 'dart:math';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../widgets/icon_slide_widget.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
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

  _addItem(String title) {
    setState(() {
      final item = TodoItem(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        done: false,
      );
      list.items.add(item);
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

  _delete(index) {
    setState(() {
      list.items.removeAt(index);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('plans', list.listToJSONEncodable());
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
      // resizeToAvoidBottomInset: false,
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
                var items = storage.getItem('plans');

                if (items != null) {
                  list.items = List<TodoItem>.from(
                    (items as List).map(
                      (item) => TodoItem(
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
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      AppbarCustom(
                        deleteOnTap: () {
                          _clearAll();
                        },
                      ),
                      Container(
                        width: w * 9 / 10,
                        height: MediaQuery.of(context).size.height,
                        child: OrientationBuilder(
                            builder: (context, orientation) => buildList(
                                  context,
                                )),
                      ),
                    ],
                  ),
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
        );
      },
      itemCount: list.items.length,
    );
  }
}
