import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/users/logs_screens/general_logs_overview_screen.dart';
import '../../screens/users/meal_plans.dart/meal_plans_overview_screen.dart';
import '../../screens/users/settings_users/general_settings_users_screen.dart';
import '../../screens/users/coping_skills/my_coping_skills_screen.dart';
import '../../screens/users/communtity_coping_skills/community_skills_overview_screen.dart';
import '../../screens/users/tips/tips_categories_screen.dart';
import '../../screens/users/goals/my_goals_screen.dart';
import '../../screens/users/logs_screens/calendar_logs_screen.dart';
import '../../screens/users/connect_with_clinician.dart/connect_with_clinician_screen.dart';

import '../../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayName = Provider.of<Auth>(context).userName;
    return Drawer(
      child: ListView(
        children: <Widget>[
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
            title: Text('My Feed'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(GeneralLogsOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('My Meal Plans'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(MealPlansOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.golf_course),
            title: Text('My Goals'),
            onTap: () {
              Navigator.of(context).pushNamed(MyGoalsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.bubble_chart),
            title: Text('My Coping Skills'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MyCopingSkillsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('My Calendar'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(CalendarLogsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Clinician Connection'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushNamed(ConnectWithClinicianScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Community Coping Skills'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushNamed(CommunityCopingSkillsOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Learn'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(TipsCategoriesScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushNamed(GeneralSettingsUsersScreen.routeName);
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
