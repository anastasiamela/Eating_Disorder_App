import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/goals.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

class GoalDetailScreen extends StatelessWidget {
  static const routeName = '/goal-of-patient-detail';
  @override
  Widget build(BuildContext context) {
    final goalId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final goal = Provider.of<Goals>(
      context,
    ).findById(goalId);
    PatientOfClinician patient = Provider.of<PatientsOfClinician>(context)
        .findPatientById(goal.patientId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            if (!goal.isCompleted)
              ListTile(
                title: Text(
                  'Scheduled for:',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    DateFormat('EEEE, MMM d, y')
                        .format(goal.scheduleToCompleteDate),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                leading: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                  size: 26,
                ),
              ),
            if (goal.isCompleted)
              ListTile(
                title: Text(
                  'Completed on:',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    DateFormat('EEEE, MMM d, y')
                        .format(goal.scheduleToCompleteDate),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                leading: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                  size: 26,
                ),
              ),
            Card(
              child: ListTile(
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
            ),
            Card(
              shadowColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Name:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(goal.name),
                    Divider(),
                  ],
                ),
              ),
            ),
            Card(
              shadowColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(goal.description),
                    Divider(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
              child: Center(
                child: Text(
                  'Created at: ${DateFormat.yMEd().add_jm().format(goal.creationDate)}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.black45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
