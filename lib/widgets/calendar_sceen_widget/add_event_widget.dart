import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

class AddEventWidget extends StatelessWidget {
  TextEditingController controller;
  Function onChangedText;
  DateTime selectedDateTime;
  Function dayPickerOnPress;
  Function saveOnPress;

  AddEventWidget({
    this.controller,
    this.onChangedText,
    this.selectedDateTime,
    this.dayPickerOnPress,
    this.saveOnPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: Container(
        height: 230,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 30, right: 10, top: 10, bottom: 10),
              child: Container(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: TextField(
                        style: TextStyle(color: Colors.orange),
                        autofocus: true,
                        controller: controller,
                        decoration: InputDecoration(
                            labelText: 'What to do?',
                            labelStyle: TextStyle(color: kMainColor),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: kFloatButtonColor))),
                        onChanged: onChangedText,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('Pick Day',
                        style: TextStyle(
                          color: kMainColor,
                          fontSize: 15,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: dayPickerOnPress,
                      child: Text(
                        '${DateFormat('dd/MM/yyyy').format(selectedDateTime)}',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: kFloatButtonColor),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.greenAccent,
                size: 50,
              ),
              onPressed: saveOnPress,
              tooltip: 'Save',
            ),
          ],
        ),
      ),
    );
  }
}
