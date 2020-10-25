import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/thoughts.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';
import '../../../screens/clinicians/detail_screens/thought_log_of_patient_detail_screen.dart';

class ThoughtItem extends StatelessWidget {
  final bool showPatientInfo;
  ThoughtItem(this.showPatientInfo);
  @override
  Widget build(BuildContext context) {
    final thought = Provider.of<Thought>(context, listen: false);
    final time = DateFormat.jm().format(thought.date);
    PatientOfClinician patient = Provider.of<PatientsOfClinician>(context)
        .findPatientById(thought.userId);
    return ChangeNotifierProvider.value(
      value: patient,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ThoughtLogOfPatientDetailScreen.routeName,
            arguments: thought.id,
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (showPatientInfo)
                  ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        patient.patientPhoto,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(patient.patientName),
                    subtitle: Text(patient.patientEmail),
                  ),
                ListTile(
                  trailing: CircleAvatar(
                    radius: 30.0,
                    child: Icon(
                      Icons.forum,
                      size: 40,
                    ), //feedback, lightbulb_outline
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text('$time  Thoughts'),
                  subtitle: Text(thought.thought),
                ),
                Row(
                  children: [
                    Icon(
                      thought.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 30.0,
                      color: Theme.of(context).accentColor,
                    ),
                    if (thought.isBackLog)
                      Icon(
                        Icons.arrow_back,
                        size: 30.0,
                        color: Theme.of(context).accentColor,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
