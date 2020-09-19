import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/behaviors.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

class BehaviorLogItem extends StatelessWidget {
  final String subtitleType;

  BehaviorLogItem(this.subtitleType);

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
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(patient.patientId),
              ),
              ListTile(
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
    );
  }
}
