import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

import '../../screens/clinicians/overview/log_activity_of_patients_screen.dart';
import '../../screens/clinicians/overview/my_patients_tabs_screen.dart';
import '../../screens/clinicians/coping_skills/coping_skills_of_patients_screen.dart';
import '../../screens/clinicians/goals/goals_of_patients_screen.dart';

class AppDrawerClinicians extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayName = Provider.of<Auth>(context).userName;
    return Drawer(
      child: ListView(
        children: [
          AppBar(
            title: Text('Hello $displayName!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.assignment_ind),
            title: Text('Logs\' Activity'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(LogActivityOfPatientsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('My Patients'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MyPatientsTabsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.bubble_chart),
            title: Text('Coping Skills'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(CopingSkillsOfPatientsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.golf_course),
            title: Text('Goals'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(GoalsOfPatientsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).signout();
            },
          ),
        ],
      ),
    );
  }
}
