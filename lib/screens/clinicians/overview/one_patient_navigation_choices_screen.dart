import 'package:flutter/material.dart';

import './one_patient_logs_tabs_screen.dart';

//import '../../../widgets/clinicians/app_drawer_clinicians.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

class OnePatientNavigationChoicesScreen extends StatelessWidget {
  final PatientOfClinician patient;
  OnePatientNavigationChoicesScreen(this.patient);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.playlist_add_check),
          title: Text('Logs Feed'),
          onTap: () {
            Navigator.of(context).pushNamed(OnePatientLogsTabsScreen.routeName,
                arguments: patient);
          },
        ),
        Divider(),
      ],
    );
  }
}
