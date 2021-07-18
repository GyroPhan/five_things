import 'package:flutter/material.dart';
import '../constants.dart';

class CircleCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color checkColor;
  final bool tristate;
  final MaterialTapTargetSize materialTapTargetSize;

  CircleCheckbox({
    Key key,
    @required this.value,
    this.tristate = false,
    @required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.materialTapTargetSize,
  })  : assert(tristate != null),
        assert(tristate || value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: (value) ? Colors.red : kMainColor,
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          )),
      width: 24,
      height: 24,
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.transparent,
        ),
        child: Checkbox(
          activeColor: Colors.transparent,
          checkColor: Colors.red,
          value: value,
          tristate: false,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
