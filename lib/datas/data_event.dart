import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

class HEvent {
  int id;
  String title;
  DateTime date;
  int dotshow;
  String iconshow;
  HEvent(
      {this.id,
      this.title,
      this.date,
      this.dotshow = 1,
      this.iconshow = 'default'});
  Map toJson() => {
        'id': id,
        'title': title,
        'date': date.toString(),
        'dotshow': dotshow,
        'iconshow': iconshow,
      };
}

EventList<Event> markedDateMap = EventList<Event>(events: {});

List<Event> eventList = [];
List<HEvent> hEventList = [];
