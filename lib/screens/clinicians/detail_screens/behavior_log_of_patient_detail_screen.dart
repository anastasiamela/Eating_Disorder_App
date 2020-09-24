import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/behaviors.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../models/behaviors_messages.dart';

import '../../comments_of_logs_screen.dart';

class BehaviorLogOfPatientDetailScreen extends StatelessWidget {
  static const routeName = '/behavior-log-of-patient-detail';
  @override
  Widget build(BuildContext context) {
    final behaviorId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final behavior = Provider.of<Behaviors>(
      context,
    ).findById(behaviorId);
    PatientOfClinician patient = Provider.of<PatientsOfClinician>(context)
        .findPatientById(behavior.userId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of the behavior log'),
        actions: [
          IconButton(
            icon: Icon(Icons.comment),
            onPressed: () {
              Navigator.of(context).pushNamed(CommentsOfLogsScreen.routeName,
                  arguments: behavior.id);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    DateFormat.yMEd().add_jm().format(behavior.date),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Logged at: ${DateFormat.yMEd().add_jm().format(behavior.dateTimeOfLog)}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.black45),
                  ),
                ],
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
                        'Disorderd Behaviors:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    ...behavior.behaviorsList
                        .map((item) => Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Row(
                                    children: [
                                      Text(getBehaviorTitleForOverview(item)),
                                      SizedBox(width: 8),
                                      if (item == 'useLaxatives' &&
                                          behavior.laxativesNumber > 0)
                                        Text('( ${behavior.laxativesNumber} )'),
                                      if (item == 'useDietPills' &&
                                          behavior.dietPillsNumber > 0)
                                        Text('( ${behavior.dietPillsNumber} )'),
                                      if (item == 'drinkAlcohol' &&
                                          behavior.drinksNumber > 0)
                                        Text('( ${behavior.drinksNumber} )'),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            ))
                        .toList()
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
                        'Urges:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        if (behavior.restrictGrade.isNotEmpty)
                          Row(
                            children: [
                              Text('To restrict:  '),
                              Text(behavior.restrictGrade),
                            ],
                          ),
                        if (behavior.restrictGrade.isNotEmpty) Divider(),
                        if (behavior.bingeGrade.isNotEmpty)
                          Row(
                            children: [
                              Text('To binge:  '),
                              Text(behavior.bingeGrade),
                            ],
                          ),
                        if (behavior.bingeGrade.isNotEmpty) Divider(),
                        if (behavior.purgeGrade.isNotEmpty)
                          Row(
                            children: [
                              Text('To purge:  '),
                              Text(behavior.purgeGrade),
                            ],
                          ),
                        if (behavior.purgeGrade.isNotEmpty) Divider(),
                        if (behavior.exerciseGrade.isNotEmpty)
                          Row(
                            children: [
                              Text('To exercise:  '),
                              Text(behavior.exerciseGrade),
                            ],
                          ),
                        if (behavior.exerciseGrade.isNotEmpty) Divider(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (behavior.bodyAvoidType.isNotEmpty)
              Card(
                shadowColor: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'How I avoided my body:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      ...behavior.bodyAvoidType
                          .map((item) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    child: Text(item),
                                  ),
                                  Divider(),
                                ],
                              ))
                          .toList()
                    ],
                  ),
                ),
              ),
            if (behavior.bodyCheckType.isNotEmpty)
              Card(
                shadowColor: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'How I checked my body:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      ...behavior.bodyCheckType
                          .map((item) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    child: Text(item),
                                  ),
                                  Divider(),
                                ],
                              ))
                          .toList()
                    ],
                  ),
                ),
              ),
            if (behavior.thoughts.isNotEmpty)
              Card(
                shadowColor: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'Thoughts:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Text(behavior.thoughts),
                      Divider(),
                    ],
                  ),
                ),
              ),
            Card(
              shadowColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'Comments:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  trailing: Icon(
                    Icons.navigate_next,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        CommentsOfLogsScreen.routeName,
                        arguments: behavior.id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
