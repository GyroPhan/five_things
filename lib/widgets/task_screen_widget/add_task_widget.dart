import 'package:five_things/constants.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

///////////////////////////////////////////////////////////////////////////////
class AddTaskWidget extends StatelessWidget {
  TextEditingController controller;

  Function textOnChanged;
  Function saveOnPressed;

  AddTaskWidget({
    this.controller,
    this.textOnChanged,
    this.saveOnPressed,
  });
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
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
          builder: (context) => Container(
            color: kBackgroundColor,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 300,
                    child: TextField(
                        style: TextStyle(color: kFloatButtonColor),
                        cursorColor: kFloatButtonColor,
                        autofocus: true,
                        controller: controller,
                        decoration: InputDecoration(
                            labelText: 'What to do?',
                            labelStyle: TextStyle(color: kMainColor),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kMainColor))),
                        onChanged: textOnChanged),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.save,
                      color: kMainColor,
                      size: 40,
                    ),
                    onPressed: saveOnPressed,
                    tooltip: 'Save',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
