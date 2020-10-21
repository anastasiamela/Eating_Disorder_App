import 'package:flutter/material.dart';

import './one_patient_logs_tabs_screen.dart';
import '../one_patient/one_patient_coping_skills_screen.dart';
import '../one_patient/one_patient_meal_plans.dart';
import '../one_patient/one_patient_goals_screen.dart';

import '../../../providers/clinicians/patients_of_clinicians.dart';

class OnePatientNavigationChoicesScreen extends StatelessWidget {
  final PatientOfClinician patient;
  OnePatientNavigationChoicesScreen(this.patient);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.playlist_add_check),
            title: Text('Logs Feed'),
            onTap: () {
              Navigator.of(context).pushNamed(
                  OnePatientLogsTabsScreen.routeName,
                  arguments: patient);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.playlist_add_check),
            title: Text('Coping Skills'),
            onTap: () {
              Navigator.of(context).pushNamed(OnePatientSkillsScreen.routeName,
                  arguments: patient);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.playlist_add_check),
            title: Text('Meal Plans'),
            onTap: () {
              Navigator.of(context).pushNamed(
                  OnePatientMealPlansScreen.routeName,
                  arguments: patient);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.playlist_add_check),
            title: Text('Goals'),
            onTap: () {
              Navigator.of(context).pushNamed(
                  OnePatientGoalsScreen.routeName,
                  arguments: patient);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
