import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/logging_goals.dart';
import '../../../providers/auth.dart';

class SettingsLoggingGoals extends StatefulWidget {
  static const routeName = '/settings-logging-goals';
  @override
  _SettingsLoggingGoalsState createState() => _SettingsLoggingGoalsState();
}

class _SettingsLoggingGoalsState extends State<SettingsLoggingGoals> {
  int _selectedMainMealsWeekday;
  List<bool> _selectedMainWeekdayList = [false, false, false, false, false];
  int _selectedMainMealsWeekend;
  List<bool> _selectedMainWeekendList = [false, false, false, false, false];
  int _selectedSnacksWeekday;
  List<bool> _selectedSnacksWeekdayList = [false, false, false, false, false];
  int _selectedSnacksWeekend;
  List<bool> _selectedSnacksWeekendList = [false, false, false, false, false];

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final loggingGoalsData =
          Provider.of<LoggingGoals>(context, listen: false);
      _selectedMainMealsWeekday = loggingGoalsData.mainMealsWeekday;
      _selectedMainWeekdayList[_selectedMainMealsWeekday - 1] = true;
      _selectedMainMealsWeekend = loggingGoalsData.mainMealsWeekend;
      _selectedMainWeekendList[_selectedMainMealsWeekend - 1] = true;
      _selectedSnacksWeekday = loggingGoalsData.snacksWeekday;
      _selectedSnacksWeekdayList[_selectedSnacksWeekday] = true;
      _selectedSnacksWeekend = loggingGoalsData.snacksWeekend;
      _selectedSnacksWeekendList[_selectedSnacksWeekend] = true;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Number of Meals'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Provider.of<LoggingGoals>(context, listen: false).setSettings(
                  _selectedMainMealsWeekday,
                  _selectedSnacksWeekday,
                  _selectedMainMealsWeekend,
                  _selectedSnacksWeekend,
                  userId);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Target meal logs per day!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Divider(),
            SizedBox(height: 8.0),
            Text(
              'Weekdays',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 8.0),
            _buildInputRow(
                'Main Meals', 'main', 'weekday', _selectedMainWeekdayList),
            _buildInputRow(
                'Snacks', 'snack', 'weekday', _selectedSnacksWeekdayList),
            SizedBox(height: 8.0),
            Divider(),
            Text(
              'Weekend',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 8.0),
            _buildInputRow(
                'Main Meals', 'main', 'weekend', _selectedMainWeekendList),
            _buildInputRow(
                'Snacks', 'snack', 'weekend', _selectedSnacksWeekendList),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(String title, String typeOfMeal, String typeOfDay,
      List<bool> isSelected) {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                '$title:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ToggleButtons(
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              children: (typeOfMeal == 'main')
                  ? <Widget>[
                      Text('1'),
                      Text('2'),
                      Text('3'),
                      Text('4'),
                      Text('5'),
                    ]
                  : <Widget>[
                      Text('0'),
                      Text('1'),
                      Text('2'),
                      Text('3'),
                      Text('4'),
                    ],
              isSelected: isSelected,
              onPressed: (index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                  if (typeOfMeal == 'main' && typeOfDay == 'weekday') {
                    _selectedMainWeekdayList = isSelected;
                    _selectedMainMealsWeekday = index + 1;
                  } else if (typeOfMeal == 'main' && typeOfDay == 'weekend') {
                    _selectedMainWeekendList = isSelected;
                    _selectedMainMealsWeekend = index + 1;
                  } else if (typeOfMeal == 'snack' && typeOfDay == 'weekday') {
                    _selectedSnacksWeekdayList = isSelected;
                    _selectedSnacksWeekday = index;
                  } else if (typeOfMeal == 'snack' && typeOfDay == 'weekend') {
                    _selectedSnacksWeekendList = isSelected;
                    _selectedSnacksWeekend = index;
                  }
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
