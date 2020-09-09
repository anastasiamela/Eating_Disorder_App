//import '../providers/meal_log.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/meal_logs.dart';
import '../add_input/edit_meal_log_screen.dart';

class MealLogDetailScreen extends StatelessWidget {
  static const routeName = '/mealLog-detail';

  @override
  Widget build(BuildContext context) {
    
    final emptyImage =
        'https://i1.pngguru.com/preview/658/470/455/krzp-dock-icons-v-1-2-empty-grey-empty-text-png-clipart.jpg';
    final mealId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedmeal = Provider.of<MealLogs>(
      context,
    ).findById(mealId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal log'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditMealLogScreen.routeName, arguments: mealId);
            },
          ),
        ],
      ),
      body: loadedmeal.skip
          ? MealSkippedDetail(
              loadedmeal.mealType,
              loadedmeal.date,
              loadedmeal.feelingOverall,
              loadedmeal.thoughts,
              loadedmeal.skippingReason,
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Container(
                    height: 200,
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
                  ),
                  SizedBox(height: 10),
                  FieldInfo('General Information'),
                  SizedBox(height: 5),
                  InfoText('Type of meal: ${loadedmeal.mealType}'),
                  SizedBox(height: 5),
                  InfoText('Description: ${loadedmeal.mealDescription}'),
                  SizedBox(height: 5),
                  InfoText('Portion size: ${loadedmeal.mealPortion}'),
                  FieldInfo('Environment'),
                  SizedBox(height: 5),
                  InfoText('Company: ${loadedmeal.mealCompany}'),
                  SizedBox(height: 5),
                  InfoText('Location: ${loadedmeal.mealLocation}'),
                  SizedBox(height: 5),
                  FieldInfo('Feelings'),
                  SizedBox(height: 5),
                  InfoText('Overall Feeling: ${loadedmeal.feelingOverall}'),
                  SizedBox(height: 5),
                  FieldInfo('Thoughts'),
                  SizedBox(height: 5),
                  InfoText(loadedmeal.thoughts),
                  SizedBox(height: 5),
                ],
              ),
            ),
    );
  }
}

class MealSkippedDetail extends StatelessWidget {
  final String typeOfMeal;
  final DateTime dateTimeOfMeal;
  final String feelingOverall;
  final String thoughts;
  final String reason;
  MealSkippedDetail(
    this.typeOfMeal,
    this.dateTimeOfMeal,
    this.feelingOverall,
    this.thoughts,
    this.reason,
  );
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            DateFormat.yMEd().add_jm().format(dateTimeOfMeal),
          ),
          SizedBox(
            height: 10,
          ),
          FieldInfo('General Information'),
          SizedBox(
            height: 5,
          ),
          InfoText('Type of meal: $typeOfMeal'),
          SizedBox(
            height: 5,
          ),
          InfoText('Skipping reason: $reason'),
          SizedBox(
            height: 5,
          ),
          FieldInfo('Feelings'),
          SizedBox(
            height: 5,
          ),
          InfoText('Overall feeling: $feelingOverall'),
          SizedBox(
            height: 5,
          ),
          FieldInfo('Thoughts'),
          SizedBox(
            height: 5,
          ),
          InfoText(thoughts),
        ],
      ),
    );
  }
}

class FieldInfo extends StatelessWidget {
  final String fieldName;
  FieldInfo(this.fieldName);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        fieldName,
        textAlign: TextAlign.left,
      ),
      width: double.infinity,
      color: Colors.purple[200],
      padding: EdgeInsets.symmetric(horizontal: 5),
    );
  }
}

class InfoText extends StatelessWidget {
  final String info;
  InfoText(this.info);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Text(
        info,
        textAlign: TextAlign.left,
      ),
      padding: EdgeInsets.symmetric(horizontal: 5),
    );
  }
}
