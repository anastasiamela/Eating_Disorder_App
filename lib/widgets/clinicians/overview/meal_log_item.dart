import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/meal_log.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

// import '../../../screens/users/logs_screens/meal_log_detail_screen.dart';
// import '../../../screens/users/add_input/edit_meal_log_screen.dart';

class MealLogItem extends StatelessWidget {
  final String subtitleType;
  final bool showPatientInfo;

  MealLogItem(this.subtitleType, this.showPatientInfo);

  @override
  Widget build(BuildContext context) {
    final meal = Provider.of<MealLog>(context, listen: false);
    final time = DateFormat.jm().format(meal.date);
    String subtitleText = '';

    if (subtitleType == 'Thoughts') {
      subtitleText = 'Thoughts: ${meal.thoughts}';
    } else if (subtitleType == 'Feelings') {
      subtitleText = 'Overall feeling: ${meal.feelingOverall}';
    } else {
      if (meal.skip)
        subtitleText = meal.skippingReason;
      else
        subtitleText = meal.mealDescription;
    }
    PatientOfClinician patient =
        Provider.of<PatientsOfClinician>(context).findPatientById(meal.userId);
    return ChangeNotifierProvider.value(
      value: patient,
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
                title: (meal.skip)
                    ? Text('SKIP  ${meal.mealType}')
                    : Text('$time  ${meal.mealType}'),
                subtitle: Text(subtitleText),
              ),
              Row(
                children: [
                  Icon(
                    meal.isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 30.0,
                    color: Theme.of(context).accentColor,
                  ),
                  if (meal.isBackLog)
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
