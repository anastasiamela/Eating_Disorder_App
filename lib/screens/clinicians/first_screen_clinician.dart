import 'package:flutter/material.dart';

import '../../widgets/curved_list_item.dart';

import './overview/log_activity_of_patients_screen.dart';
import './overview/my_patients_tabs_screen.dart';

class FirstScreenClinician extends StatelessWidget {
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
                    Navigator.of(ctx).pushReplacementNamed(LogActivityOfPatientsScreen.routeName);
                  },
                  child: CurvedListItem(
                    title: 'Patients\' Activity',
                    color: Colors.teal[100],
                    nextColor: Colors.teal[200],
                    icon: Icons.note,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(ctx).pushReplacementNamed(MyPatientsScreen.routeName);
                    Navigator.of(ctx).pushReplacementNamed(MyPatientsTabsScreen.routeName);
                  },
                  child: CurvedListItem(
                    title: 'My patients',
                    color: Colors.teal[200],
                    nextColor: Colors.teal[300],
                    icon: Icons.people,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: CurvedListItem(
                    title: 'Settings',
                    color: Colors.teal[300],
                    nextColor: Colors.teal[400],
                    icon: Icons.settings,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                  },
                  child: CurvedListItem(
                    title: 'nothing',
                    color: Colors.teal[400],
                    nextColor: Colors.teal[500],
                    icon: Icons.note_add,
                  ),
                ),
                CurvedListItem(
                  title: 'Goals',
                  color: Colors.teal[500],
                  nextColor: Colors.teal[200],
                  icon: Icons.trip_origin,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
