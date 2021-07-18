import 'package:flutter/material.dart';
import '../../constants.dart';

class DateInfoWidget extends StatelessWidget {
  String date;
  String month;
  String year;
  DateInfoWidget({this.date, this.month, this.year});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            date,
            style: TextStyle(
                fontSize: 110, fontWeight: FontWeight.bold, color: kMainColor),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            Text(
              month,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: kFloatButtonColor),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              year,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: kFloatButtonColor),
            ),
          ],
        ),
      ],
    );
  }
}
