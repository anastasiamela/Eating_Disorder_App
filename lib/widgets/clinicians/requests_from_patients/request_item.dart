import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/requests.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

class RequestItem extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final request = Provider.of<Request>(context);
    final date = DateFormat.yMd().add_jm().format(request.date);
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              request.patientName,
            ),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                request.patientPhoto,
              ),
              backgroundColor: Colors.transparent,
            ),
            subtitle: Text(date),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Email:  ${request.patientEmail}'),
          ),
          if (request.messageFromPatient.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Message:  ${request.messageFromPatient}'),
            ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  onPressed: () {
                    Provider.of<Requests>(context, listen: false)
                        .deleteRequestFromPatient(request.patientId);
                  },
                  color: Colors.red[900],
                  textColor: Colors.white,
                  child: Text('DECLINE'),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    final clinicianName = Provider.of<Auth>(context, listen: false).userName;
                    final clinicianEmail = Provider.of<Auth>(context, listen: false).userEmail;
                    final clinicianPhoto = Provider.of<Auth>(context, listen: false).userPhoto;
                    Provider.of<Requests>(context, listen: false)
                        .acceptRequestFromPatient(
                      clinicianId: request.clinicianId,
                      patientId: request.patientId,
                      clinicianName: clinicianName,
                      clinicianEmail: clinicianEmail,
                      clinicianPhoto: clinicianPhoto,
                    );
                    Provider.of<Requests>(context, listen: false)
                        .deleteRequestFromPatient(request.patientId);
                    PatientOfClinician newPatient = PatientOfClinician(
                      patientId: request.patientId,
                      patientName: request.patientName,
                      patientPhoto: request.patientPhoto,
                      patientEmail: request.patientEmail,
                    );
                    Provider.of<PatientsOfClinician>(context, listen: false)
                        .addPatient(newPatient, request.clinicianId);
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text('ACCEPT'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
