import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/users/add_input/add_meal_log_screen.dart';
import '../../screens/users/add_input/add_thought_screen.dart';

import '../../providers/auth.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add meal log 2'),
            onTap: () {
              Navigator.of(context).pushNamed(AddMealLogScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('My meal logs'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/');
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
          Divider(),
          ListTile(
            leading: Icon(Icons.add_comment),
            title: Text('Add thoughts'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AddThoughtScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
