import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

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
              Navigator.of(context).pushNamed('/');
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
