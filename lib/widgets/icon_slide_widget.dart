import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class IconSlideActionCustom extends StatelessWidget {
  String title;
  Color boderColor;
  IconData icon;
  Function onTap;
  IconSlideActionCustom({this.title, this.icon, this.boderColor, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: boderColor),
      ),
      child: IconSlideAction(
        caption: title,
        color: Colors.transparent,
        icon: icon,
        onTap: onTap,
        closeOnTap: false,
      ),
    );
  }
}
