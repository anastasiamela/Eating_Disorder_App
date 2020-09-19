import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/clinicians/patients_of_clinicians.dart';

class PatientItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<PatientOfClinician>(context);
    return Column(
      children: [
        ListTile(
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
        ),
        Divider(),
      ],
    );
  }
}
