import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/meal_logs.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../comments_of_logs_screen.dart';

class MealLogOfPatientDetailScreen extends StatelessWidget {
  static const routeName = '/mealLog-of-patient-detail';

  @override
  Widget build(BuildContext context) {
    final emptyImage =
        'https://i1.pngguru.com/preview/658/470/455/krzp-dock-icons-v-1-2-empty-grey-empty-text-png-clipart.jpg';
    final mealId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedmeal = Provider.of<MealLogs>(
      context,
    ).findById(mealId);
    PatientOfClinician patient = Provider.of<PatientsOfClinician>(context)
        .findPatientById(loadedmeal.userId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of the meal'),
        actions: [
          IconButton(
            icon: Icon(Icons.comment),
            onPressed: () {
              Navigator.of(context).pushNamed(CommentsOfLogsScreen.routeName,
                  arguments: loadedmeal.id);
            },
          )
        ],
      ),
      body: !loadedmeal.skip
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
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
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              child: Image.network(
                                (loadedmeal.mealPhoto == '')
                                    ? emptyImage
                                    : loadedmeal.mealPhoto,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              DateFormat.yMEd()
                                  .add_jm()
                                  .format(loadedmeal.date),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Logged at: ${DateFormat.yMEd().add_jm().format(loadedmeal.dateTimeOfLog)}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black45),
                            ),
                            SizedBox(height: 8),
                            Text(
                              loadedmeal.mealType,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                                'General Information:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Description:  ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Text(loadedmeal.mealDescription),
                              ],
                            ),
                            Divider(),
                            if (loadedmeal.mealPortion.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    'Portion Size:  ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(loadedmeal.mealPortion),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (loadedmeal.mealLocation.isNotEmpty ||
                        loadedmeal.mealCompany.isNotEmpty)
                      Card(
                        shadowColor: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  'Environment:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              if (loadedmeal.mealCompany.isNotEmpty)
                                Row(
                                  children: [
                                    Text(
                                      'Company:  ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(loadedmeal.mealCompany),
                                  ],
                                ),
                              Divider(),
                              if (loadedmeal.mealLocation.isNotEmpty)
                                Row(
                                  children: [
                                    Text(
                                      'Location:  ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(loadedmeal.mealLocation),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (loadedmeal.feelingOverall.isNotEmpty)
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
                              if (loadedmeal.feelingOverall.isNotEmpty)
                                Row(
                                  children: [
                                    Text(
                                      'Overall Feeling:  ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(loadedmeal.feelingOverall),
                                  ],
                                ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    if (loadedmeal.thoughts.isNotEmpty)
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
                              if (loadedmeal.thoughts.isNotEmpty)
                                Row(
                                  children: [
                                    Text(
                                      'My thoughts:  ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(loadedmeal.thoughts),
                                  ],
                                ),
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
                                arguments: loadedmeal.id);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            DateFormat.yMEd().add_jm().format(loadedmeal.date),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Logged at: ${DateFormat.yMEd().add_jm().format(loadedmeal.dateTimeOfLog)}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: Colors.black45),
                          ),
                          SizedBox(height: 8),
                          Text(
                            loadedmeal.mealType,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
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
                                'Skipping Reason:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            Text(loadedmeal.skippingReason),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                    if (loadedmeal.feelingOverall.isNotEmpty)
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
                              if (loadedmeal.feelingOverall.isNotEmpty)
                                Row(
                                  children: [
                                    Text(
                                      'Overall Feeling:  ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(loadedmeal.feelingOverall),
                                  ],
                                ),
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
                                'Thoughts:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            if (loadedmeal.thoughts.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    'My thoughts:  ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Text(loadedmeal.thoughts),
                                ],
                              ),
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
                                arguments: loadedmeal.id);
                          },
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
