import 'package:flutter/material.dart';

import './settings_for_logs_screen.dart';
import './settings_logging_goals.dart';
import '../reminders/reminders_screen.dart';

import '../../../widgets/users/app_drawer.dart';

class GeneralSettingsUsersScreen extends StatelessWidget {
  static const routeName = '/general-settings-users';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.playlist_add_check),
            title: Text('Log Questions'),
            onTap: () {
              Navigator.of(context).pushNamed(SettingsForLogsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.wifi_tethering),
            title: Text('Logging Goals'),
            onTap: () {
              Navigator.of(context).pushNamed(SettingsLoggingGoals.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.wifi_tethering),
            title: Text('Reminders'),
            onTap: () {
              Navigator.of(context).pushNamed(RemindersScreen.routeName);
            },
          ),
          Divider(),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
