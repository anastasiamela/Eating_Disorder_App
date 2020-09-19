import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import '../../../providers/meal_logs.dart';
import '../../../providers/meal_log.dart';
import '../../../providers/feelings.dart';
import '../../../providers/thoughts.dart';
import '../../../providers/behaviors.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../widgets/clinicians/overview/meal_log_item.dart';
import '../../../widgets/clinicians/overview/thought_item.dart';
import '../../../widgets/clinicians/overview/feeling_log_item.dart';
import '../../../widgets/clinicians/overview/behavior_log_item.dart';

class CalendarOnePatientScreen extends StatefulWidget {
  static const routeName = '/calendar-one-patient';
  final PatientOfClinician patient;

  CalendarOnePatientScreen(this.patient);

  @override
  _CalendarOnePatientScreenState createState() => _CalendarOnePatientScreenState();
}

class _CalendarOnePatientScreenState extends State<CalendarOnePatientScreen> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents = [];

  List<dynamic> sort(List<dynamic> list) {
    list.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return list;
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      
      Provider.of<Thoughts>(context).fetchAndSetThoughts(widget.patient.patientId);
      Provider.of<Feelings>(context).fetchAndSetFeelings(widget.patient.patientId);
      Provider.of<Behaviors>(context).fetchAndSetBehaviors(widget.patient.patientId);
      Provider.of<MealLogs>(context).fetchAndSetMealLogs(widget.patient.patientId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
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
    _isInit = false;
    super.didChangeDependencies();
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
        title: Text('${widget.patient.patientName} \'s Log Calendar'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _selectedEvents.length,
          itemBuilder: (_, i) {
            final log = _selectedEvents[i];
            if (log is MealLog)
              return ChangeNotifierProvider.value(
                value: log,
                child: MealLogItem('', false),
              );
            if (log is Thought)
              return ChangeNotifierProvider.value(
                value: log,
                child: ThoughtItem(false),
              );
            if (log is Feeling)
              return ChangeNotifierProvider.value(
                value: log,
                child: FeelingLogItem('', false),
              );
            if (log is Behavior)
              return ChangeNotifierProvider.value(
                value: log,
                child: BehaviorLogItem('', false),
              );
            return null;
          },
        ),
      ),
    );
  }
}
