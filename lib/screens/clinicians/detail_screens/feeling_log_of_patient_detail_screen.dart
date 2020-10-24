import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/feelings.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../models/emoji_view.dart';

import '../../comments_of_logs_screen.dart';

class FeelingLogOfPatientDetailScreen extends StatelessWidget {
  static const routeName = '/feeling-log-of-patient-detail';
  @override
  Widget build(BuildContext context) {
    final feelingId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final feeling = Provider.of<Feelings>(
      context,
    ).findById(feelingId);
    PatientOfClinician patient = Provider.of<PatientsOfClinician>(context)
        .findPatientById(feeling.userId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of the feelings log'),
        actions: [
          IconButton(
            icon: Icon(Icons.comment),
            onPressed: () {
              Navigator.of(context).pushNamed(CommentsOfLogsScreen.routeName,
                  arguments: feeling.id);
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
                    DateFormat('EEEE, MMM d, y').add_jm().format(feeling.date),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Logged at: ${DateFormat('MMM d, y').add_jm().format(feeling.dateTimeOfLog)}',
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
                        'Overall Feeling:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(feeling.overallFeeling),
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
                        'Feelings:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    ...feeling.moods
                        .map((mood) => Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Row(
                                    children: [
                                      Text(getEmojiTextView(mood)),
                                      SizedBox(width: 8),
                                      Text(mood),
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
            if (feeling.thoughts.isNotEmpty)
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
                      Text(feeling.thoughts),
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
                        arguments: feeling.id);
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
