import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import '../../../providers/meal_logs.dart';
import '../../../providers/meal_log.dart';
import '../../../providers/feelings.dart';
import '../../../providers/thoughts.dart';
import '../../../providers/behaviors.dart';

import '../../../widgets/users/overview/meal_log_item.dart';
import '../../../widgets/users/overview/thought_item.dart';
import '../../../widgets/users/overview/feeling_log_item.dart';
import '../../../widgets/users/overview/behavior_log_item.dart';
import '../../../widgets/users/app_drawer.dart';

import 'meal_log_detail_screen.dart';

class CalendarLogsScreen extends StatefulWidget {
  static const routeName = '/calendar-logs';
  @override
  _CalendarLogsScreenState createState() => _CalendarLogsScreenState();
}

class _CalendarLogsScreenState extends State<CalendarLogsScreen> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents = [];

  List<dynamic> sort(List<dynamic> list) {
    list.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return list;
  }

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
      final meals = Provider.of<MealLogs>(context, listen: false).meals;
      final thoughts = Provider.of<Thoughts>(context, listen: false).thoughts;
      final feelings = Provider.of<Feelings>(context, listen: false).feelings;
      final behaviors =
          Provider.of<Behaviors>(context, listen: false).behaviors;
      List<dynamic> allLogs = [
        ...meals,
        ...thoughts,
        ...feelings,
        ...behaviors
      ];
      _events = initEvents(allLogs);
      _selectedEvents = _events[_selectedDay] ?? [];
    });
  }

  Map<DateTime, List<dynamic>> initEvents(List<dynamic> logs) {
    Map<DateTime, List<dynamic>> map = {};
    setState(() {
      logs.forEach((log) {
        final dateLog = log.date;
        final year = dateLog.year;
        final month = dateLog.month;
        final day = dateLog.day;
        final date1 = DateTime(year, month, day);
        if (map[date1] != null) {
          map[date1].add(log);
        } else {
          map[date1] = [log];
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
      drawer: AppDrawer(),
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
    sort(_selectedEvents);
    return Container(
      height: 100.0,
      child: ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (_, i) {
          final log = _selectedEvents[i];
          if (log is MealLog)
            return ChangeNotifierProvider.value(
              value: log,
              child: MealLogItem(''),
            );
          if (log is Thought)
            return ChangeNotifierProvider.value(
              value: log,
              child: ThoughtItem(),
            );
          if (log is Feeling)
            return ChangeNotifierProvider.value(
              value: log,
              child: FeelingLogItem(''),
            );
          if (log is Behavior)
            return ChangeNotifierProvider.value(
              value: log,
              child: BehaviorLogItem(''),
            );
          return null;
        },
      ),
    );
  }
}
