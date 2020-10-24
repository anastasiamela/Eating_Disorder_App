import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../api/reminders_api.dart';

import '../../../providers/goals.dart';

class MyGoalDetailScreen extends StatefulWidget {
  static const routeName = '/my-goal-detail';

  @override
  _MyGoalDetailScreenState createState() => _MyGoalDetailScreenState();
}

class _MyGoalDetailScreenState extends State<MyGoalDetailScreen> {
  @override
  void initState() {
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final goalId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final goal = Provider.of<Goals>(
      context,
    ).findById(goalId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            if (!goal.isCompleted)
              ListTile(
                title: Text(
                  'Scheduled for:',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    DateFormat('EEEE, MMM d, y')
                        .format(goal.scheduleToCompleteDate),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                leading: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                  size: 26,
                ),
              ),
            if (goal.isCompleted)
              ListTile(
                title: Text(
                  'Completed on:',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    DateFormat('EEEE, MMM d, y')
                        .format(goal.scheduleToCompleteDate),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                leading: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                  size: 26,
                ),
              ),
            Card(
              shadowColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Name:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(goal.name),
                    Divider(),
                  ],
                ),
              ),
            ),
            Card(
              shadowColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(goal.description),
                    Divider(),
                  ],
                ),
              ),
            ),
            if (!goal.isCompleted && goal.reminderIndex > 0)
              Card(
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 26,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          'Reminder: ',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          printTime(TimeOfDay.fromDateTime(
                              goal.scheduleToCompleteDate)),
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
              child: Center(
                child: Text(
                  'Created at: ${DateFormat('MMM d, y').add_jm().format(goal.creationDate)}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.black45),
                ),
              ),
            ),
            if (!goal.isCompleted)
              RaisedButton(
                onPressed: () async {
                  goal.setCompleted(goal.patientId);
                  if (goal.reminderIndex > 0) {
                    int index = goal.reminderIndex + 6;
                    await notificationPlugin.cancelNotification(index);
                  }
                },
                child: Text(
                  'Complete Goal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              )
          ],
        ),
      ),
    );
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
