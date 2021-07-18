import 'package:flutter/material.dart';

class TodoItem {
  int id;
  int bossId;
  int prioritize;
  String title;
  bool done;

  TodoItem({this.id, this.bossId, this.title, this.done, this.prioritize});

  itemToJSONEncodable() {
    Map<String, dynamic> m = Map();
    m['id'] = id;
    m['bossId'] = bossId;
    m['title'] = title;
    m['done'] = done;
    m['prioritize'] = prioritize;
    return m;
  }
}

//-------------------------------------------------------------

class TodoList {
  List<TodoItem> items = [];

  listToJSONEncodable() {
    return items.map((item) {
      return item.itemToJSONEncodable();
    }).toList();
  }
}
