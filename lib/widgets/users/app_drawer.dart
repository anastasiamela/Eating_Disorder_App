import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../screens/users/add_input/add_meal_log_screen.dart';
// import '../../screens/users/add_input/add_thought_screen.dart';
// import '../../screens/users/add_input/add_feeling_log_screen.dart';
// import '../../screens/users/add_input/add_behavior_log_screen.dart';
import '../../screens/users/logs_screens/general_logs_overview_screen.dart';
import '../../screens/users/meal_plans.dart/meal_plans_overview_screen.dart';
import '../../screens/users/settings_users/general_settings_users_screen.dart';

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
              Navigator.of(context).pushNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text('My feed'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(GeneralLogsOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text('My meal plans'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(MealPlansOverviewScreen.routeName);
            },
          ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.add),
          //   title: Text('Add meal log'),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     Navigator.of(context).pushNamed(AddMealLogScreen.routeName);
          //   },
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.add_comment),
          //   title: Text('Add thoughts'),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     Navigator.of(context).pushNamed(AddThoughtScreen.routeName);
          //   },
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.headset),
          //   title: Text('Add feelings'),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     Navigator.of(context).pushNamed(AddFeelingLogScreen.routeName);
          //   },
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.error_outline),
          //   title: Text('Add behaviors'),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     Navigator.of(context).pushNamed(AddBehaviorLogScreen.routeName);
          //   },
          // ),
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
