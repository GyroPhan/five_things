import 'package:five_things/constants.dart';
import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

class CalendarWidget extends StatelessWidget {
  Function onDayPressed;
  Function onCalendarChanged;
  Function onDayLongPressed;
  Function onTodayPressed;
  EventList<Event> markedDatesMap;
  DateTime selectedDateTime;
  DateTime targetDateTime;
  CalendarWidget(
      {this.selectedDateTime,
      this.targetDateTime,
      this.markedDatesMap,
      this.onCalendarChanged,
      this.onDayPressed,
      this.onDayLongPressed,
      this.onTodayPressed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: CalendarCarousel<Event>(
            todayBorderColor: kMainColor,
            onDayPressed: onDayPressed,
            daysHaveCircularBorder: true,
            showOnlyCurrentMonthDate: false,
            //----------Text Style--------------------
            daysTextStyle: TextStyle(fontSize: 16),
            todayTextStyle: TextStyle(
              color: kFloatButtonColor,
            ),
            weekendTextStyle: TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
            markedDateCustomTextStyle: TextStyle(
              fontSize: 16,
              color: Colors.lightBlueAccent,
            ),
            selectedDayTextStyle: TextStyle(
              color: Colors.yellow,
            ),
            prevDaysTextStyle: TextStyle(
              fontSize: 16,
              color: Colors.pinkAccent,
            ),
            inactiveDaysTextStyle: TextStyle(
              color: Colors.tealAccent,
              fontSize: 16,
            ),
            //------------------------------------------
            thisMonthDayBorderColor: kMainColor,
            firstDayOfWeek: 1,
            markedDatesMap: markedDatesMap,
            height: 420,
            selectedDateTime: selectedDateTime,
            targetDateTime: targetDateTime,
            customGridViewPhysics: NeverScrollableScrollPhysics(),
            markedDateCustomShapeBorder:
                CircleBorder(side: BorderSide(color: kFloatButtonColor)),
            showHeader: true, selectedDayButtonColor: kFloatButtonColor,
            selectedDayBorderColor: kMainColor,
            todayButtonColor: kMainColor,

            minSelectedDate: selectedDateTime.subtract(Duration(days: 360)),
            maxSelectedDate: selectedDateTime.add(Duration(days: 360)),
            onCalendarChanged: onCalendarChanged,
            onDayLongPressed: onDayLongPressed,
          ),
        ),
        Container(
          width: 100,
          height: 40,
          decoration: BoxDecoration(
              color: kFloatButtonColor,
              borderRadius: BorderRadius.circular(10)),
          child: FlatButton(
            child: Text(
              'Today',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            onPressed: onTodayPressed,
          ),
        ),
      ],
    );
  }
}
