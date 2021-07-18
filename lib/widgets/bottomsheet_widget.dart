import 'package:five_things/constants.dart';
import 'package:flutter/material.dart';
import '../screens/task_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/plan_screen.dart';
import '../screens/setting_sreen.dart';

class BottomSheetScreen extends StatefulWidget {
  @override
  _BottomSheetScreenState createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    TaskScreen(),
    CalendarScreen(),
    PlanScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: '5 Things',
            backgroundColor: Color(0xff1F2027),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Calendar',
            backgroundColor: Color(0xff1F2027),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.next_plan_outlined),
            label: 'Plan',
            backgroundColor: Color(0xff1F2027),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
            backgroundColor: Color(0xff1F2027),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kFloatButtonColor,
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
