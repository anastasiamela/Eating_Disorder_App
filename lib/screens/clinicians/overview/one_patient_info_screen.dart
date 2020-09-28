import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../providers/clinicians/patients_of_clinicians.dart';

class OnePatientInfoScreen extends StatelessWidget {
  final PatientOfClinician patient;
  OnePatientInfoScreen(this.patient);

  @override
  Widget build(BuildContext context) {
    final timestamp = patient.connectionDate;
    final connectionDateTime = DateTime.parse(timestamp.toDate().toString());
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Card(
              shadowColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(
                        patient.patientPhoto,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                        child: Text(
                          patient.patientName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      subtitle: Text(
                        patient.patientEmail,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      DateFormat.yMEd().add_jm().format(connectionDateTime),
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
