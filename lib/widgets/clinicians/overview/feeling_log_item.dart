import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/feelings.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../models/emoji_view.dart';

import '../../../screens/clinicians/detail_screens/feeling_log_of_patient_detail_screen.dart';

class FeelingLogItem extends StatelessWidget {
  final String subtitleType;
  final bool showPatientInfo;

  FeelingLogItem(this.subtitleType, this.showPatientInfo);
  @override
  Widget build(BuildContext context) {
    final feeling = Provider.of<Feeling>(context, listen: false);
    final time = DateFormat.jm().format(feeling.date);
    List<String> moodsEmojis = [];
    List<String> moods = feeling.moods;
    moods.forEach((mood) => moodsEmojis.add(getEmojiTextView(mood)));

    String subtitleText = '';
    if (subtitleType == 'Thoughts') {
      subtitleText = 'Thoughts: ${feeling.thoughts}';
    }
    PatientOfClinician patient = Provider.of<PatientsOfClinician>(context)
        .findPatientById(feeling.userId);
    return ChangeNotifierProvider.value(
      value: patient,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            FeelingLogOfPatientDetailScreen.routeName,
            arguments: feeling.id,
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
                      Icons.face,
                      size: 40,
                    ), //feedback, lightbulb_outline
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text('$time  Feelings'),
                  subtitle: (subtitleType == 'Thoughts')
                      ? Text(subtitleText)
                      : Row(
                          children: moodsEmojis
                              .map((mood) => Text('$mood '))
                              .toList(),
                        ),
                ),
                Row(
                  children: [
                    Icon(
                      feeling.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 30.0,
                      color: Theme.of(context).accentColor,
                    ),
                    if (feeling.isBackLog)
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
