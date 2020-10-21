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
  final _form = GlobalKey<FormState>();
  bool _enableSettings;
  Map<String, TimeOfDay> _selectedTime = {};
  Map<String, String> _finalSettingsToSave = {};
  Map<String, String> _selectedMessages = {};
  Map<String, bool> _enableOneSetting = {};
  Map<String, TimeOfDay> _defaultTimes = {
    'breakfast': TimeOfDay(hour: 10, minute: 0),
    'morningSnack': TimeOfDay(hour: 12, minute: 0),
    'lunch': TimeOfDay(hour: 14, minute: 0),
    'afternoonSnack': TimeOfDay(hour: 17, minute: 0),
    'dinner': TimeOfDay(hour: 20, minute: 0),
    'eveningSnack': TimeOfDay(hour: 22, minute: 0),
    'mealPlan': TimeOfDay(hour: 21, minute: 30),
  };

  Map<String, bool> _isExpanded = {
    'breakfast': false,
    'morningSnack': false,
    'lunch': false,
    'afternoonSnack': false,
    'dinner': false,
    'eveningSnack': false,
    'mealPlan': false,
  };

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
      _selectedMessages['breakfast'] = _settings.breakfastMessage;
      _selectedMessages['morningSnack'] = _settings.morningSnackMessage;
      _selectedMessages['lunch'] = _settings.lunchMessage;
      _selectedMessages['afternoonSnack'] = _settings.afternoonSnackMessage;
      _selectedMessages['dinner'] = _settings.dinnerMessage;
      _selectedMessages['eveningSnack'] = _settings.eveningSnackMessage;
      _selectedMessages['mealPlan'] = _settings.mealPlanMessage;
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
        final keys = _selectedTime.keys.toList();
        for (String key in keys) {
          if (_selectedTime[key] == null) {
            _enableOneSetting[key] = false;
          } else {
            _enableOneSetting[key] = true;
          }
        }
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

    _selectedMessages['breakfast'] = 'Breakfast log time';
    _selectedMessages['morningSnack'] = 'Morning snack log time';
    _selectedMessages['lunch'] = 'Lunch log time';
    _selectedMessages['afternoonSnack'] = 'Afternoon snack log time';
    _selectedMessages['dinner'] = 'Dinner log time';
    _selectedMessages['eveningSnack'] = 'Evening snack log time';
    _selectedMessages['mealPlan'] = 'Meal plan time';

    _enableOneSetting['breakfast'] = true;
    _enableOneSetting['morningSnack'] = true;
    _enableOneSetting['lunch'] = true;
    _enableOneSetting['afternoonSnack'] = true;
    _enableOneSetting['dinner'] = true;
    _enableOneSetting['eveningSnack'] = true;
    _enableOneSetting['mealPlan'] = true;
  }

  void _save() async {
    setState(() {
      _isExpanded['breakfast'] = true;
      _isExpanded['morningSnack'] = true;
      _isExpanded['lunch'] = true;
      _isExpanded['afternoonSnack'] = true;
      _isExpanded['dinner'] = true;
      _isExpanded['eveningSnack'] = true;
      _isExpanded['mealPlan'] = true;
    });
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final keys = _selectedTime.keys.toList();
    if (_enableSettings) {
      for (String key in keys) {
        if (_enableOneSetting[key]) {
          _finalSettingsToSave[key] = timeOfDayToString(_selectedTime[key]);
        } else {
          _finalSettingsToSave[key] = '';
        }
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
      breakfastMessage: _selectedMessages['breakfast'],
      morningSnackMessage: _selectedMessages['morningSnack'],
      lunchMessage: _selectedMessages['lunch'],
      afternoonSnackMessage: _selectedMessages['afternoonSnack'],
      dinnerMessage: _selectedMessages['dinner'],
      eveningSnackMessage: _selectedMessages['eveningSnack'],
      mealPlanMessage: _selectedMessages['mealPlan'],
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
        if (_enableOneSetting[key]) {
          await notificationPlugin.showDailyAtTime(_selectedTime[key],
              _codesForReminders[key], 'Reminder', _selectedMessages[key]);
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
          : Form(
              key: _form,
              child: ListView(
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
            ),
    );
  }

  Widget _buildOneReminder(String type, String title) {
    return Column(
      children: [
        ListTile(
          leading: _isExpanded[type]
              ? IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      _isExpanded[type] = !_isExpanded[type];
                    });
                  })
              : IconButton(
                  icon: Icon(Icons.navigate_next),
                  onPressed: () {
                    setState(() {
                      _isExpanded[type] = !_isExpanded[type];
                    });
                  }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_enableSettings)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _enableOneSetting[type] = !_enableOneSetting[type];
                    });
                    if (!_enableOneSetting[type])
                      setState(() {
                        _selectedTime[type] = _defaultTimes[type];
                        print(_defaultTimes[type]);
                      });
                  },
                  child: Text(
                    (!_enableOneSetting[type]) ? 'OFF' : 'ON',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          trailing: Container(
            width: 100,
            child: RaisedButton(
              color: (_enableSettings && _enableOneSetting[type])
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.4),
              textColor: Colors.white,
              onPressed: () =>
                  (_enableOneSetting[type]) ? _pickTime(type) : null,
              child: Text(timeOfDayToString(_selectedTime[type])),
            ),
          ),
        ),
        if (_isExpanded[type])
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              initialValue: _selectedMessages[type],
              readOnly: !_enableSettings || !_enableOneSetting[type],
              decoration: InputDecoration(
                  labelText: 'Alert Message',
                  labelStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).primaryColor,
                  )),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'You have to type an alert message.';
                }
                if (value.trim().length >= 50) {
                  return 'Should be less than 50 characters long.';
                }
                if (value.trim().length < 5) {
                  return 'Should be at least characters long.';
                }
                return null;
              },
              onChanged: (value) => _selectedMessages[type] = value.trim(),
            ),
          ),
      ],
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
