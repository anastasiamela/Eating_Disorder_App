import 'package:flutter/material.dart';

import '../../../providers/clinicians/patients_of_clinicians.dart';

class OnePatientInfoScreen extends StatelessWidget {
  final PatientOfClinician patient;
  OnePatientInfoScreen(this.patient);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('data'),
    );
  }
}
