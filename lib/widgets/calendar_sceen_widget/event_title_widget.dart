import 'package:flutter/material.dart';
import '../../constants.dart';

class EventTitleWidget extends StatelessWidget {
  String title;
  Function deleteOnPress;
  EventTitleWidget({this.title, this.deleteOnPress});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 70,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kMainColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kFloatButtonColor),
              ),
            ),
            GestureDetector(
              onTap: deleteOnPress,
              child: Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 35,
              ),
            )
          ],
        ));
  }
}
