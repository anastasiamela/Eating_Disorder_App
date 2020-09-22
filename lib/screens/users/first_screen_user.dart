import 'package:flutter/material.dart';

import '../../widgets/curved_list_item.dart';

import '../../screens/users/logs_screens/general_logs_overview_screen.dart';
import '../../screens/users/logs_screens/calendar_logs_screen.dart';
import '../../screens/users/add_input/add_meal_log_screen.dart';
import '../../screens/users/add_input/add_thought_screen.dart';
import '../../screens/users/add_input/add_behavior_log_screen.dart';
import '../../screens/users/add_input/add_feeling_log_screen.dart';
import '../../screens/users/settings_users/general_settings_users_screen.dart';
import '../../screens/users/connect_with_clinician.dart/connect_with_clinician_screen.dart';

class FirstScreenUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          colors: [
            Colors.teal[400],
            Colors.teal[200],
            Colors.teal[100],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          //stops: [0, 1],
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: new Stack(
        children: [_getContent(context)],
      ),
    );
  }

  Widget _getContent(BuildContext ctx) {
    return Positioned(
      left: 20.0,
      right: 20.0,
      top: 30.0,
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.teal[100],
              ),
            ),
          ),
          SizedBox(height: 80),
          Card(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pushReplacementNamed(
                        GeneralLogsOverviewScreen.routeName);
                  },
                  child: CurvedListItem(
                    title: 'My Feed',
                    color: Colors.teal[100],
                    nextColor: Colors.teal[200],
                    icon: Icons.account_box,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(ctx)
                        .pushReplacementNamed(CalendarLogsScreen.routeName);
                  },
                  child: CurvedListItem(
                    title: 'Calendar',
                    color: Colors.teal[200],
                    nextColor: Colors.teal[300],
                    icon: Icons.calendar_today,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pushReplacementNamed(
                        GeneralSettingsUsersScreen.routeName);
                  },
                  child: CurvedListItem(
                    title: 'Settings',
                    color: Colors.teal[300],
                    nextColor: Colors.teal[400],
                    icon: Icons.settings,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    return showDialog(
                      context: ctx,
                      builder: (ctx) => SimpleDialog(
                        backgroundColor: Colors.teal[50].withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.all(8),
                        titlePadding: EdgeInsets.all(8),
                        title: const Text(
                          'Select to add:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline),
                        ),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: const Text(
                              'Meal log',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 25.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              Navigator.of(ctx)
                                  .pushNamed(AddMealLogScreen.routeName);
                            },
                          ),
                          Divider(
                            color: Theme.of(ctx).accentColor,
                          ),
                          SimpleDialogOption(
                            child: const Text(
                              'Thoughts',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 25.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              Navigator.of(ctx)
                                  .pushNamed(AddThoughtScreen.routeName);
                            },
                          ),
                          Divider(
                            color: Theme.of(ctx).accentColor,
                          ),
                          SimpleDialogOption(
                            child: const Text(
                              'Feelings',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 25.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              Navigator.of(ctx)
                                  .pushNamed(AddFeelingLogScreen.routeName);
                            },
                          ),
                          Divider(
                            color: Theme.of(ctx).accentColor,
                          ),
                          SimpleDialogOption(
                            child: const Text(
                              'Behaviors',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 25.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              Navigator.of(ctx)
                                  .pushNamed(AddBehaviorLogScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: CurvedListItem(
                    title: 'Check in',
                    color: Colors.teal[400],
                    nextColor: Colors.teal[500],
                    icon: Icons.note_add,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(ctx)
                        .pushReplacementNamed(ConnectWithClinicianScreen.routeName);
                  },
                  child: CurvedListItem(
                    title: 'Connect',
                    color: Colors.teal[500],
                    nextColor: Colors.teal[200],
                    icon: Icons.people,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
