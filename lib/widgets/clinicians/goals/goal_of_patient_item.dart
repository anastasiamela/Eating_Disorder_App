import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/goals.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../screens/clinicians/goals/goal_detail_screen.dart';

class GoalOfPatientItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final goal = Provider.of<Goal>(context);
    String date;
    if (goal.isCompleted) {
      date = DateFormat('EEEE, MMM d, y').format(goal.completeDate);
    } else {
      date = DateFormat('EEEE, MMM d, y').format(goal.scheduleToCompleteDate);
    }

    PatientOfClinician patient = Provider.of<PatientsOfClinician>(context)
        .findPatientById(goal.patientId);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          GoalDetailScreen.routeName,
          arguments: goal.id,
        );
      },
      child: Card(
        shadowColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  goal.name,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
                child: Text(
                  goal.description,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Row(
                    children: [
                      !goal.isCompleted
                          ? Text(
                              'Target Date: ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : Text(
                              'Completed on: ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                      Text(
                        date,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
