import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/thoughts.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

class ThoughtItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final thought = Provider.of<Thought>(context, listen: false);
    final time = DateFormat.jm().format(thought.date);
    PatientOfClinician patient = Provider.of<PatientsOfClinician>(context)
        .findPatientById(thought.userId);
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
                title: Text('$time  Thoughts'),
                subtitle: Text(thought.thought),
              ),
              Row(
                children: [
                  Icon(
                    thought.isFavorite ? Icons.favorite : Icons.favorite_border,
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
    );
  }
}
