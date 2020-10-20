import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../providers/reminders.dart';
import '../../../providers/auth.dart';

import '../../../api/reminders_api.dart';

class RemindersScreen extends StatefulWidget {
  static const routeName = '/reminders';

  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _enableSettings;
  Map<String, TimeOfDay> _selectedTime = {};
  Map<String, String> _finalSettingsToSave = {};
  final Map<String, int> _codesForReminders = {
    'breakfast': 0,
    'morningSnack': 1,
    'lunch': 2,
    'afternoonSnack': 3,
    'dinner': 4,
    'eveningSnack': 5,
    'mealPlan': 6,
  };

  var _isInit = true;
  var _isLoading = false;

  String timeOfDayToString(TimeOfDay tod) {
    if (tod == null) {
      return '';
    }
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  TimeOfDay stringToTimeOfDay(String input) {
    if (input == '') {
      return null;
    }
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(input));
  }

  @override
  void initState() {
    super.initState();
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _initializeSettings();
      _initializeReminders();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _initializeSettings() async {
    setState(() {
      _isLoading = true;
    });
    final userId = Provider.of<Auth>(context, listen: false).userId;
    await Provider.of<SettingsForReminders>(context)
        .fetchAndSetSettingsForReminders(userId);
    setState(() {
      _isLoading = false;
    });
  }

  void _initializeReminders() {
    final _settingsExist =
        Provider.of<SettingsForReminders>(context).settingsRemindersExist;
    if (_settingsExist) {
      final _settings =
          Provider.of<SettingsForReminders>(context).remindersInfo;
      _enableSettings = _settings.areRemindersEnabled;
      if (_enableSettings) {
        _selectedTime['breakfast'] =
            stringToTimeOfDay(_settings.breakfastReminder);
        _selectedTime['morningSnack'] =
            stringToTimeOfDay(_settings.morningSnackReminder);
        _selectedTime['lunch'] = stringToTimeOfDay(_settings.lunchReminder);
        _selectedTime['afternoonSnack'] =
            stringToTimeOfDay(_settings.afternoonSnackReminder);
        _selectedTime['dinner'] = stringToTimeOfDay(_settings.dinnerReminder);
        _selectedTime['eveningSnack'] =
            stringToTimeOfDay(_settings.eveningSnackReminder);
        _selectedTime['mealPlan'] =
            stringToTimeOfDay(_settings.mealPlanReminder);
      } else {
        _setDefaultValues();
      }
    } else {
      _setDefaultValues();
      _enableSettings = false;
    }
  }

  void _setDefaultValues() {
    _selectedTime['breakfast'] = TimeOfDay(hour: 10, minute: 0);
    _selectedTime['morningSnack'] = TimeOfDay(hour: 12, minute: 0);
    _selectedTime['lunch'] = TimeOfDay(hour: 14, minute: 0);
    _selectedTime['afternoonSnack'] = TimeOfDay(hour: 17, minute: 0);
    _selectedTime['dinner'] = TimeOfDay(hour: 20, minute: 0);
    _selectedTime['eveningSnack'] = TimeOfDay(hour: 22, minute: 0);
    _selectedTime['mealPlan'] = TimeOfDay(hour: 21, minute: 30);
  }

  void _save() async {
    final keys = _selectedTime.keys.toList();
    if (_enableSettings) {
      for (String key in keys) {
        _finalSettingsToSave[key] = timeOfDayToString(_selectedTime[key]);
      }
    } else {
      for (String key in keys) {
        _finalSettingsToSave[key] = '';
      }
    }
    // print(_finalSettingsToSave['breakfast']);
    final newSettings = Reminders(
      breakfastReminder: _finalSettingsToSave['breakfast'],
      morningSnackReminder: _finalSettingsToSave['morningSnack'],
      lunchReminder: _finalSettingsToSave['lunch'],
      afternoonSnackReminder: _finalSettingsToSave['afternoonSnack'],
      dinnerReminder: _finalSettingsToSave['dinner'],
      eveningSnackReminder: _finalSettingsToSave['eveningSnack'],
      mealPlanReminder: _finalSettingsToSave['mealPlan'],
      areRemindersEnabled: _enableSettings,
    );
    final userId = Provider.of<Auth>(context, listen: false).userId;
    Provider.of<SettingsForReminders>(context, listen: false)
        .setSettingsForReminders(newSettings, userId);

    //await notificationPlugin.cancelAllNotification();
    for (int i = 0; i < 7; i++) {
      await notificationPlugin.cancelNotification(i);
    }
    if (_enableSettings) {
      for (var key in keys) {
        if (_selectedTime[key] != null) {
          await notificationPlugin.showDailyAtTime(
              _selectedTime[key], _codesForReminders[key], '', '');
        }
      }
    }
    // var number = await notificationPlugin.getPendingNotificationCount();
    // print(number);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings for log questions'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
                  child: Column(
                    children: [
                      _buildEnableReminders(),
                      _buildOneReminder('breakfast', 'Breakfast'),
                      _buildOneReminder('morningSnack', 'Morning Snack'),
                      _buildOneReminder('lunch', 'Lunch'),
                      _buildOneReminder('afternoonSnack', 'Afternoon Snack'),
                      _buildOneReminder('dinner', 'Dinner'),
                      _buildOneReminder('eveningSnack', 'Evening Snack'),
                      _buildOneReminder('mealPlan', 'Meal Plan')
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildOneReminder(String type, String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Container(
        width: 100,
        child: RaisedButton(
          color: (_enableSettings && _selectedTime[type] != null)
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor.withOpacity(0.4),
          textColor: Colors.white,
          onPressed: () => (_enableSettings) ? _pickTime(type) : null,
          child: _selectedTime[type] != null
              ? Text(timeOfDayToString(_selectedTime[type]))
              : Text('Off'),
        ),
      ),
      onTap: () {
        if (_enableSettings)
          setState(() {
            _selectedTime[type] = null;
          });
      },
    );
  }

  _pickTime(String type) async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime:
          _selectedTime[type] == null ? TimeOfDay.now() : _selectedTime[type],
    );
    if (t != null) {
      setState(() {
        _selectedTime[type] = t;
      });
    }
  }

  Widget _buildEnableReminders() {
    return ListTile(
      title: Text(
        'Reminders',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: ToggleSwitch(
        labels: ['On', 'Off'],
        initialLabelIndex: (_enableSettings) ? 0 : 1,
        onToggle: (index) {
          setState(() {
            _enableSettings = !_enableSettings;
          });
        },
        activeBgColor: Theme.of(context).primaryColor,
        activeFgColor: Colors.white,
        inactiveBgColor: Theme.of(context).primaryColor.withOpacity(0.1),
        inactiveFgColor: Colors.grey[900],
      ),
    );
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
    // Navigator.push(context, MaterialPageRoute(builder: (coontext) {
    //   return NotificationScreen(
    //     payload: payload,
    //   );
    // }));
  }
}
