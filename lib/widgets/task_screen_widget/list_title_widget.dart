import 'package:flutter/material.dart';
import '../../constants.dart';

import '../checkbox_widget.dart';

class ListTitleCustom extends StatefulWidget {
  bool valueCheckBox;
  Function onChangedCheckBox;
  String titleText;
  ListTitleCustom({this.titleText, this.valueCheckBox, this.onChangedCheckBox});

  @override
  _ListTitleCustomState createState() => _ListTitleCustomState();
}

class _ListTitleCustomState extends State<ListTitleCustom> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.valueCheckBox;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kMainColor),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.lightGreenAccent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(9),
                        topLeft: Radius.circular(9))),
              ),
              Expanded(
                  child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleCheckbox(
                      value: _value,
                      onChanged: (newValue) {
                        widget.onChangedCheckBox?.call(_value);
                        setState(() {
                          _value = !_value;
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.titleText,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kFloatButtonColor),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
