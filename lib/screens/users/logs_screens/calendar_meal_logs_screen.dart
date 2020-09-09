import 'package:intl/intl.dart';

import '../../../providers/meal_logs.dart';
import '../../../providers/meal_log.dart';
import './meal_log_detail_screen.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class CalendarMealLogsScreen extends StatefulWidget {
  static const routeName = '/calendar-meal-logs';
  @override
  _CalendarMealLogsScreenState createState() => _CalendarMealLogsScreenState();
}

class _CalendarMealLogsScreenState extends State<CalendarMealLogsScreen> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    final _dayNow = DateTime.now();
    final year = _dayNow.year;
    final month = _dayNow.month;
    final day = _dayNow.day;
    final _selectedDay = DateTime(year, month, day);
    _controller = CalendarController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final mealsData = Provider.of<MealLogs>(context, listen: false);
      final meals = mealsData.meals;
      _events = initEvents(meals);
      _selectedEvents = _events[_selectedDay] ?? [];
    });
  }

  Map<DateTime, List<dynamic>> initEvents(List<MealLog> meals) {
    Map<DateTime, List<dynamic>> map = {};
    setState(() {
      meals.forEach((meal) {
        final dateMeal = meal.date;
        final year = dateMeal.year;
        final month = dateMeal.month;
        final day = dateMeal.day;
        final date1 = DateTime(year, month, day);
        if (map[date1] != null) {
          map[date1].add(meal);
        } else {
          map[date1] = [meal];
        }
      });
    });
    return map;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Calendar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            initialCalendarFormat: CalendarFormat.month,
            events: _events,
            calendarStyle: CalendarStyle(
                todayColor: Theme.of(context).accentColor,
                selectedColor: Theme.of(context).primaryColor,
                todayStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    //fontSize: 18.0,
                    color: Colors.white)),
            headerStyle: HeaderStyle(
              centerHeaderTitle: false,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
                color: Theme.of(context).accentColor,
              ),
              formatButtonDecoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              formatButtonTextStyle: TextStyle(color: Colors.white),
              formatButtonShowsNext: false,
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (date, events) {
              setState(() {
                _selectedEvents = events;
              });
            },
            builders: CalendarBuilders(
              markersBuilder: (context, date, events, holidays) {
                final children = <Widget>[];

                if (events.isNotEmpty) {
                  children.add(
                    Positioned(
                        right: 1,
                        bottom: 1,
                        child: Icon(
                          Icons.dashboard,
                          size: 12.0,
                        )),
                  );
                }
                return children;
              },
            ),
            calendarController: _controller,
          ),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    print(_selectedEvents.length);
    final emptyImage =
        'https://i1.pngguru.com/preview/658/470/455/krzp-dock-icons-v-1-2-empty-grey-empty-text-png-clipart.jpg';
    return Container(
      height: 100.0,
      child: ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (_, i) {
          final meal = _selectedEvents[i];
          final time = DateFormat.jm().format(meal.dateTimeOfMeal);
          return ListTile(
            trailing: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                (meal.mealPhoto == '') ? emptyImage : meal.mealPhoto,
              ),
              backgroundColor: Colors.transparent,
            ),
            title: Text('$time  ${meal.mealType}'),
            subtitle:
                Text((meal.skip) ? 'Skipped meal.' : meal.mealDescription),
            onTap: () {
              Navigator.of(context).pushNamed(
                MealLogDetailScreen.routeName,
                arguments: meal.id,
              );
            },
          );
        },
      ),
    );
  }
}
