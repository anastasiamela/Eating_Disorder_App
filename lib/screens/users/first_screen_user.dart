import 'package:disorder_app/widgets/users/app_drawer.dart';
import 'package:flutter/material.dart';

import '../../widgets/curved_list_item.dart';

import '../../screens/users/logs_screens/general_logs_overview_screen.dart';
import '../../screens/users/logs_screens/calendar_logs_screen.dart';

class FirstScreenUser extends StatelessWidget {
  //static const routeName = '/first-screen';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      drawer: AppDrawer(),
      body: Container(
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
                    Navigator.of(ctx).pushReplacementNamed(
                        CalendarLogsScreen.routeName);
                  },
                  child: CurvedListItem(
                    title: 'Calendar',
                    color: Colors.teal[200],
                    nextColor: Colors.teal[300],
                    icon: Icons.calendar_today,
                  ),
                ),
                CurvedListItem(
                  title: 'Settings',
                  color: Colors.teal[300],
                  nextColor: Colors.teal[400],
                  icon: Icons.settings,
                ),
                CurvedListItem(
                  title: 'Check in',
                  color: Colors.teal[400],
                  nextColor: Colors.teal[500],
                  icon: Icons.note_add,
                ),
                CurvedListItem(
                  title: 'Connect',
                  color: Colors.teal[500],
                  nextColor: Colors.teal[200],
                  icon: Icons.people,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
