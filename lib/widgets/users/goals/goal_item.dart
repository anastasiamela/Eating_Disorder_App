import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../api/reminders_api.dart';

import '../../../providers/goals.dart';

import '../../../screens/users/goals/my_goal_detail_screen.dart';
import '../../../screens/users/add_input/add_goal_screen.dart';

class GoalItem extends StatefulWidget {
  @override
  _GoalItemState createState() => _GoalItemState();
}

class _GoalItemState extends State<GoalItem> {
  @override
  void initState() {
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final goal = Provider.of<Goal>(context);
    String date;
    if (goal.isCompleted) {
      date = DateFormat('EEEE, MMM d, y').format(goal.completeDate);
    } else {
      date = DateFormat('EEEE, MMM d, y').format(goal.scheduleToCompleteDate);
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          MyGoalDetailScreen.routeName,
          arguments: goal.id,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shadowColor: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  goal.name,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Wrap(
                  children: [
                    if (!goal.isCompleted)
                      IconButton(
                        splashColor: Colors.transparent,
                        icon: Icon(
                          Icons.edit,
                          size: 28,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              AddGoalScreen.routeName,
                              arguments: goal);
                        },
                      ),
                    SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      splashColor: Colors.transparent,
                      icon: Icon(
                        Icons.delete,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () async {
                        Provider.of<Goals>(context, listen: false)
                            .deleteGoal(goal.id, goal.patientId);
                        if (goal.reminderIndex > 0) {
                          int index = goal.reminderIndex + 6;
                          await notificationPlugin.cancelNotification(index);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
                child: Text(
                  goal.description,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Row(
                    children: [
                      !goal.isCompleted
                          ? Text(
                              'Target Date: ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : Text(
                              'Completed on: ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                      Text(
                        date,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!goal.isCompleted)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: RaisedButton(
                      onPressed: () async{
                        goal.setCompleted(goal.patientId);
                        if (goal.reminderIndex > 0) {
                          int index = goal.reminderIndex + 6;
                          await notificationPlugin.cancelNotification(index);
                        }
                      },
                      child: Text(
                        'Complete Goal',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                    ),
                  ),
                )
            ],
          ),
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
