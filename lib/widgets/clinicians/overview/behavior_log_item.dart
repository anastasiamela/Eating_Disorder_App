import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/behaviors.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../screens/clinicians/detail_screens/behavior_log_of_patient_detail_screen.dart';

class BehaviorLogItem extends StatelessWidget {
  final String subtitleType;
  final bool showPatientInfo;

  BehaviorLogItem(this.subtitleType, this.showPatientInfo);

  @override
  Widget build(BuildContext context) {
    final behavior = Provider.of<Behavior>(context, listen: false);
    final behaviorsNumber = behavior.behaviorsListLenght;
    final time = DateFormat.jm().format(behavior.date);

    String subtitleText = '';
    if (subtitleType == 'Thoughts') {
      subtitleText = 'Thoughts: ${behavior.thoughts}';
    } else {
      if (behaviorsNumber == 0) {
        subtitleText = 'Disordered behaviors: none';
      } else {
        subtitleText = 'Disordered behaviors:  $behaviorsNumber';
      }
    }
    PatientOfClinician patient = Provider.of<PatientsOfClinician>(context)
        .findPatientById(behavior.userId);
    return ChangeNotifierProvider.value(
      value: patient,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            BehaviorLogOfPatientDetailScreen.routeName,
            arguments: behavior.id,
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
                      Icons.announcement,
                      size: 40,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text('$time  Behaviors'),
                  subtitle: Text(subtitleText),
                ),
                Row(
                  children: [
                    Icon(
                      behavior.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 30.0,
                      color: Theme.of(context).accentColor,
                    ),
                    if (behavior.isBackLog)
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
