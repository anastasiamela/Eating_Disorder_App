import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../screens/clinicians/overview/one_patient_screen.dart';

class PatientItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<PatientOfClinician>(context);
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(
            patient.patientPhoto,
          ),
          backgroundColor: Colors.transparent,
        ),
        title: Text(patient.patientName),
        subtitle: Text(patient.patientEmail),
        trailing: Icon(Icons.navigate_next),
        onTap: () {
          Navigator.of(context).pushNamed(OnePatientScreen.routeName, arguments: patient);
        },
      ),
    );
  }
}
