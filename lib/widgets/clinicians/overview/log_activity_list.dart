import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../../providers/meal_logs.dart';
import '../../../providers/meal_log.dart';
import '../../../providers/thoughts.dart';
import '../../../providers/feelings.dart';
import '../../../providers/behaviors.dart';

import '../../clinicians/overview/meal_log_item.dart';
import '../../clinicians/overview/thought_item.dart';
import '../../clinicians/overview/feeling_log_item.dart';
import '../../clinicians/overview/behavior_log_item.dart';

class LogActivityList extends StatelessWidget {
  final int selectedCategoryIndex;
  final String selectedCategory;
  final bool showPatientInfo;

  LogActivityList(this.selectedCategoryIndex, this.selectedCategory, this.showPatientInfo);

  List<dynamic> sort(List<dynamic> list) {
    list.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    String messageEmpty = '';
    List<Feeling> feelings;
    List<Thought> thoughts;
    List<Behavior> behaviors;
    List<MealLog> meals;
    List displayList;

    final thoughtsData = Provider.of<Thoughts>(context);
    final mealsData = Provider.of<MealLogs>(context);
    final behaviorsData = Provider.of<Behaviors>(context);
    final feelingsData = Provider.of<Feelings>(context);

    if (selectedCategoryIndex == 0) {
      behaviors = behaviorsData.behaviors;
      meals = mealsData.mealsSorted;
      thoughts = thoughtsData.thoughts;
      feelings = feelingsData.feelings;
      displayList = sort([...meals, ...thoughts, ...feelings, ...behaviors]);
      messageEmpty = 'There are no logs of your patients.';
    } else if (selectedCategoryIndex == 1) {
      meals = mealsData.meals;
      displayList = sort([...meals]);
      messageEmpty = 'There are no meal logs of your patients.';
    } else if (selectedCategoryIndex == 2) {
      meals = mealsData.skippedMeals;
      if (meals != null)
        displayList = [...meals];
      else
        displayList = [];
      messageEmpty = 'There are no skipped meals of your patients.';
    } else if (selectedCategoryIndex == 3) {
      thoughts = thoughtsData.backLogThoughts;
      feelings = feelingsData.backLogFeelings;
      behaviors = behaviorsData.backLogBehaviors;
      meals = mealsData.backLogMeals;
      displayList = [...meals, ...behaviors, ...feelings, ...thoughts];
      messageEmpty = 'There are no back logs of your patients.';
    } else if (selectedCategoryIndex == 4) {
      feelings = feelingsData.feelingsWithThoughts;
      behaviors = behaviorsData.behaviorsWithThoughts;
      meals = mealsData.mealsWithThoughts;
      thoughts = thoughtsData.thoughts;
      displayList = [...thoughts, ...meals, ...behaviors, ...feelings];
      messageEmpty = 'There are no logs with thoughts of your patients.';
    } else if (selectedCategoryIndex == 5) {
      meals = mealsData.mealsWithFeelings;
      feelings = feelingsData.feelings;
      displayList = [...feelings, ...meals];
      messageEmpty = 'There are no logs with feelings of your patients.';
    } else if (selectedCategoryIndex == 6) {
      behaviors = behaviorsData.behaviors;
      displayList = [...behaviors];
      messageEmpty = 'There are no logs for behaviors of your patients.';
    }
    return (displayList == null || displayList.isEmpty)
        ? Center(
            child: Text(
              messageEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            ),
          )
        : StickyGroupedListView<dynamic, DateTime>(
            elements: displayList,
            groupBy: (dynamic obj) => DateTime(
              obj.date.year,
              obj.date.month,
              obj.date.day,
            ),
            groupSeparatorBuilder: (dynamic obj) => Container(
              height: 50,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${obj.date.day}. ${obj.date.month}. ${obj.date.year}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            itemBuilder: (_, dynamic obj) {
              if (obj is MealLog)
                return ChangeNotifierProvider.value(
                  value: obj,
                  child: MealLogItem(selectedCategory, showPatientInfo),
                );
              if (obj is Thought)
                return ChangeNotifierProvider.value(
                  value: obj,
                  child: ThoughtItem(showPatientInfo),
                );
              if (obj is Feeling)
                return ChangeNotifierProvider.value(
                  value: obj,
                  child: FeelingLogItem(selectedCategory, showPatientInfo),
                );
              if (obj is Behavior)
                return ChangeNotifierProvider.value(
                  value: obj,
                  child: BehaviorLogItem(selectedCategory, showPatientInfo),
                );
              return null;
            },
            order: StickyGroupedListOrder.DESC,
          );
  }
}
