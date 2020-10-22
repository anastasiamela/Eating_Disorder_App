import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';

import '../../../providers/goals.dart';
import '../../../providers/auth.dart';

import '../../../api/reminders_api.dart';

class AddGoalScreen extends StatefulWidget {
  static const routeName = '/add-goal';
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _form = GlobalKey<FormState>();
  String _inputName;
  String _inputDescription;
  DateTime _selectedComplitionDate;
  bool _hasSelectedcompletionDate;
  bool _hasSelectedTime;
  TimeOfDay _selectedTime;
  bool _remindersEnabled;

  var _isInit = true;
  var _isEdit = false;
  Goal entry;

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
      entry = ModalRoute.of(context).settings.arguments as Goal;
      if (entry == null) {
        _inputName = '';
        _inputDescription = '';
        _selectedComplitionDate = null;
        _hasSelectedcompletionDate = false;
        _hasSelectedTime = false;
        _selectedTime = null;
        _remindersEnabled = true;
        _isEdit = false;
      } else {
        _inputName = entry.name;
        _inputDescription = entry.description;
        _selectedComplitionDate = entry.completeDate;
        _hasSelectedcompletionDate = true;
        if (entry.reminderIndex > 0) {
          _remindersEnabled = true;
          _selectedTime = TimeOfDay.fromDateTime(_selectedComplitionDate);
          _hasSelectedTime = true;
        } else {
          _remindersEnabled = false;
          _selectedTime = null;
          _hasSelectedTime = false;
        }
        _isEdit = true;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final patientId = Provider.of<Auth>(context, listen: false).userId;
    final remindersNumber =
        Provider.of<Auth>(context, listen: false).remindersNumber;
    final date = DateTime.now();
    DateTime dateTarget;
    int indexOfReminderInput;
    if (_remindersEnabled) {
      indexOfReminderInput = remindersNumber + 1;
      await Provider.of<Auth>(context, listen: false)
          .setRemindersNumber(indexOfReminderInput);
      dateTarget = new DateTime(
        _selectedComplitionDate.year,
        _selectedComplitionDate.month,
        _selectedComplitionDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
    } else {
      indexOfReminderInput = -1;
      dateTarget = _selectedComplitionDate;
    }
    if (!_isEdit) {
      Goal input = Goal(
        id: '',
        name: _inputName,
        description: _inputDescription,
        patientId: patientId,
        createdBy: patientId,
        creationDate: date,
        scheduleToCompleteDate: dateTarget,
        completeDate: date,
        isCompleted: false,
        reminderIndex: indexOfReminderInput,
      );
      await Provider.of<Goals>(context, listen: false).addGoal(input);
    } else {
      Goal input = Goal(
        id: entry.id,
        name: _inputName,
        description: _inputDescription,
        patientId: entry.patientId,
        createdBy: entry.createdBy,
        creationDate: entry.creationDate,
        scheduleToCompleteDate: dateTarget,
        completeDate: entry.completeDate,
        isCompleted: entry.isCompleted,
        reminderIndex: indexOfReminderInput,
      );
      if (entry.reminderIndex > 0) {
        await notificationPlugin.cancelNotification(entry.reminderIndex);
      }
      await Provider.of<Goals>(context, listen: false)
          .updateGoal(entry.id, input);
    }
    if (_remindersEnabled) {
      await notificationPlugin.showDailyAtTime(
          _selectedTime, indexOfReminderInput, 'Goal Completion', _inputName);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final patientId = Provider.of<Auth>(context, listen: false).userId;
    return Scaffold(
      appBar: AppBar(
        title: _isEdit ? Text('Edit goal') : Text('New Goal'),
        actions: <Widget>[
          if (_isEdit)
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () async {
                bool response = await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text(
                      'Do you want to remove the goal?',
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                    ],
                  ),
                );
                if (!response) {
                  Provider.of<Goals>(context, listen: false)
                      .deleteGoal(entry.id, patientId);
                  Navigator.of(context).pop();
                }
              },
            ),
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              _buildNameInput(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ListTile(
                  title: Text(
                    'Define your Goal',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                    child: Text(
                      'What do you want to work on? Think of one small step you can take.',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
              _buildDescriptionInput(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ListTile(
                  title: Text(
                    'After you have created your goal, review it to make sure that:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1. It\'s realistic',
                        ),
                        Text(
                          '2. It\'s specific',
                        ),
                        Text(
                          '3. It\'s not too overwhelming',
                        ),
                        Text(
                          '4. It avoids the \'all or nothing\' trap',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: ListTile(
                  title: Text(
                    'Schedule your Goal',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                    child: Text(
                      'When do you want to complete your goal by?',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
              _buildCompletionDateInput(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: ListTile(
                  title: Text(
                    'Reminders',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                    child: Text(
                      'You will be reminded on the target completion date.',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  trailing: ToggleSwitch(
                    labels: ['On', 'Off'],
                    initialLabelIndex: (_remindersEnabled) ? 0 : 1,
                    onToggle: (index) {
                      setState(() {
                        _remindersEnabled = !_remindersEnabled;
                        if (!_remindersEnabled) {
                          _hasSelectedTime = false;
                        }
                      });
                    },
                    activeBgColor: Theme.of(context).primaryColor,
                    activeFgColor: Colors.white,
                    inactiveBgColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    inactiveFgColor: Colors.grey[900],
                  ),
                ),
              ),
              if (_remindersEnabled) _buildReminderTimeInput(),
              RaisedButton(
                child: Text('Submit'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: _saveForm,
              )
            ],
          ),
        ),
      ),
    );
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) {
      setState(() {
        _selectedTime = t;
        _hasSelectedTime = true;
      });
    }
  }

  String printTime(TimeOfDay time) {
    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10) return '0$value';
      return value.toString();
    }

    final String hourLabel = _addLeadingZeroIfNeeded(time.hour);
    final String minuteLabel = _addLeadingZeroIfNeeded(time.minute);

    return '$hourLabel:$minuteLabel';
  }

  _pickDate() async {
    DateTime today = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(Duration(days: 365)),
      initialDate: today,
    );
    if (date != null)
      setState(() {
        _selectedComplitionDate = date;
        _hasSelectedcompletionDate = true;
      });
  }

  Widget _buildReminderTimeInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: (_hasSelectedTime)
                  ? Text(
                      printTime(_selectedTime),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : TextFormField(
                      initialValue: 'Select Time',
                      readOnly: true,
                      validator: (value) {
                        if (_hasSelectedTime == false) {
                          return 'You have to select time!';
                        }
                        return null;
                      },
                    ),
              trailing: IconButton(
                icon: Icon(Icons.access_time),
                onPressed: _pickTime,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionDateInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: (_hasSelectedcompletionDate)
                  ? Text(
                      '${_selectedComplitionDate.day}. ${_selectedComplitionDate.month}. ${_selectedComplitionDate.year}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : TextFormField(
                      initialValue: 'Select Date',
                      readOnly: true,
                      validator: (value) {
                        if (_hasSelectedcompletionDate == false) {
                          //if you have not selected day
                          return 'You have to select a day!';
                        }
                        return null;
                      },
                    ),
              trailing: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return Card(
      child: ListTile(
        title: TextFormField(
          initialValue: _inputName,
          decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(fontStyle: FontStyle.italic)),
          validator: (value) {
            if (value.trim().isEmpty) {
              return 'Please enter a name.';
            }
            if (value.trim().length > 40) {
              return 'The name should be less than 40 characters long.';
            }
            return null;
          },
          onSaved: (value) => _inputName = value.trim(),
        ),
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Card(
      child: ListTile(
        title: TextFormField(
          initialValue: _inputDescription,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(fontStyle: FontStyle.italic)),
          validator: (value) {
            if (value.trim().isEmpty) {
              return 'Please enter a description.';
            }
            return null;
          },
          onChanged: (value) => _inputDescription = value.trim(),
        ),
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
