import 'package:flutter/material.dart';
import '../../constants.dart';

class AppbarCustom extends StatelessWidget {
  Function deleteOnTap;

  AppbarCustom({this.deleteOnTap});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: GestureDetector(
            onTap: deleteOnTap,
            child: Icon(
              Icons.delete_outline,
              size: 40,
              color: kMainColor,
            ),
          ),
        )
      ],
    );
  }
}
