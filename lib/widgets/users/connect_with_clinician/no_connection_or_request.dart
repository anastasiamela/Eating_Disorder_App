import 'package:flutter/material.dart';

import '../../../screens/users/connect_with_clinician.dart/add_clinician_screen.dart';

class NoConnectionOrRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: Text(
              'This app works better when you link with your treatment team.',
              textAlign: TextAlign.center,
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddClinicianScreen.routename);
            },
            color: Theme.of(context).primaryColor,
            textColor: Colors.teal[50],
            child: Text(
              'Invite Your Clinician',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
