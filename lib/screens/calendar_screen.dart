import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:localstorage/localstorage.dart';
import 'package:date_time_picker/date_time_picker.dart';
//-------------------------------------------------------------------

//-------------------------------------------------------------------
import '../constants.dart';
import '../widgets/calendar_sceen_widget/add_event_widget.dart';
import '../widgets/calendar_sceen_widget/calendar_widget.dart';
import '../datas/data_event.dart';
import '../widgets/calendar_sceen_widget/event_title_widget.dart';
import '../widgets/show_alert.dart';

//-------------------------------------------------------------------

////////////////////////////////////

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  //-------------------------------------------------------------------
  TextEditingController controller = TextEditingController();
  String textFeild;
  DateTime _selectedDateTime = DateTime.now();
  final LocalStorage storage = LocalStorage('todo_app');
  DateTime _currentDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _targetDateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day); //Date choise when app start
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  bool initialized = false;

  //-------------------------------------------------------------------

  _saveToStorage() {
    storage.setItem('events', jsonEncode(hEventList));
  }

  _delete(index) {
    setState(() {
      eventList.removeAt(index);
      _saveToStorage();
    });
    print(index);
  }

  mapHeventToMakedDayMap() {
    for (int i = 0; i <= hEventList.length - 1; i++) {
      markedDateMap.add(
          hEventList[i].date,
          Event(
            id: hEventList[i].id,
            date: hEventList[i].date,
            title: hEventList[i].title,
          ));
    }
    ;
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            buttonColor: buttonTextColor, //OK/Cancel button text color
            primaryColor: kFloatButtonColor, //Head background
            accentColor: kFloatButtonColor, //selection color
            dialogBackgroundColor: kBackgroundColor, //Background color
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != _selectedDateTime)
      setState(() {
        _selectedDateTime = picked;
      });
  }
  //-------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    eventList.clear();
    markedDateMap.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: kFloatButtonColor,
          elevation: 0,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => AddEventWidget(
                controller: controller,
                onChangedText: (value) {
                  textFeild = value;
                },
                selectedDateTime: _selectedDateTime,
                dayPickerOnPress: () => selectDate(context),
                saveOnPress: () {
                  if (textFeild == null) {
                    showAlertDialog(context);
                  } else {
                    setState(() {
                      int idTime = DateTime.now().millisecondsSinceEpoch;
                      markedDateMap.add(
                          _selectedDateTime,
                          Event(
                            id: idTime,
                            date: _selectedDateTime,
                            title: textFeild,
                          ));

                      hEventList.add(HEvent(
                          id: idTime,
                          date: _selectedDateTime,
                          title: textFeild));
                      _saveToStorage();
                      controller.clear();
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            );
          },
        ),
        body: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!initialized) {
                var items = storage.getItem('events');
                if (items != null) {
                  var deco = json.decode(items);
                  hEventList = List<HEvent>.from(
                    (deco as List).map(
                      (item) => HEvent(
                        id: item['id'],
                        date: DateTime.parse(item['date']),
                        title: item['title'],
                      ),
                    ),
                  );
                  print(hEventList);
                  mapHeventToMakedDayMap();
                }
                initialized = true;
              }
              return Padding(
                padding: EdgeInsets.only(
                  top: 40,
                  left: 5,
                  right: 5,
                ),
                child: ListView(
                  children: <Widget>[
                    CalendarWidget(
                      markedDatesMap: markedDateMap,
                      selectedDateTime: _currentDate,
                      targetDateTime: _targetDateTime,
                      onDayPressed: (date, events) {
                        setState(() {
                          eventList.clear();
                          _currentDate = date;
                          events.forEach((event) {
                            eventList.add(event);
                          });
                        });
                      },
                      onCalendarChanged: (DateTime date) {
                        setState(() {
                          _targetDateTime = date;
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                      onTodayPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day);
                          _currentDate = DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day);
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: SingleChildScrollView(
                        child: Container(
                          height: 280,
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              itemCount: eventList.length,
                              itemBuilder: (context, index) {
                                return EventTitleWidget(
                                  title: eventList[index].title,
                                  deleteOnPress: () {
                                    setState(() {
                                      markedDateMap.remove(
                                          hEventList[index].date,
                                          eventList[index]);
                                      eventList.removeWhere((item) =>
                                          item.id == eventList[index].id);
                                      hEventList.removeWhere((item) =>
                                          item.id == hEventList[index].id);

                                      _saveToStorage();
                                    });
                                  },
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
