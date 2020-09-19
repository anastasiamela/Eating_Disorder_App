import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/feelings.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../models/emoji_view.dart';

class FeelingLogItem extends StatelessWidget {
  final String subtitleType;

  FeelingLogItem(this.subtitleType);
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
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
              ListTile(
                title: Text('$time  Feelings'),
                subtitle: (subtitleType == 'Thoughts')
                    ? Text(subtitleText)
                    : Row(
                        children:
                            moodsEmojis.map((mood) => Text('$mood ')).toList(),
                      ),
              ),
              Row(
                children: [
                  Icon(
                    feeling.isFavorite ? Icons.favorite : Icons.favorite_border,
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
    );
  }
}
