import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../../providers/meal_logs.dart';
import '../../../providers/meal_log.dart';
import '../../../providers/thoughts.dart';
import '../../../providers/feelings.dart';
import '../../../providers/behaviors.dart';

import './meal_log_item.dart';
import './thought_item.dart';
import './feeling_log_item.dart';
import './behavior_log_item.dart';

import '../../../screens/users/add_input/add_behavior_log_screen.dart';
import '../../../screens/users/add_input/add_feeling_log_screen.dart';
import '../../../screens/users/add_input/add_thought_screen.dart';

class GeneralList extends StatelessWidget {
  final int selectedCategoryIndex;
  final String selectedCategory;

  GeneralList(this.selectedCategoryIndex, this.selectedCategory);

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
    String buttonTitleAdd;
    String routeNextToAdd;

    if (selectedCategoryIndex == 0) {
      final mealsData = Provider.of<MealLogs>(context);
      final thoughtsData = Provider.of<Thoughts>(context);
      final feelingsData = Provider.of<Feelings>(context);
      final behaviorsData = Provider.of<Behaviors>(context);
      behaviors = behaviorsData.behaviors;
      meals = mealsData.mealsSorted;
      thoughts = thoughtsData.thoughts;
      feelings = feelingsData.feelings;
      //print(feelings);
      displayList = sort([...meals, ...thoughts, ...feelings, ...behaviors]);
      messageEmpty = 'There are no logs.';
    } else if (selectedCategoryIndex == 1) {
      final mealsData = Provider.of<MealLogs>(context);
      final thoughtsData = Provider.of<Thoughts>(context);
      final feelingsData = Provider.of<Feelings>(context);
      final behaviorsData = Provider.of<Behaviors>(context);
      behaviors = behaviorsData.favoriteBehaviors;
      meals = mealsData.favoriteMeals;
      thoughts = thoughtsData.favoriteThoughts;
      feelings = feelingsData.favoriteFeelings;
      displayList = sort([...meals, ...thoughts, ...feelings, ...behaviors]);
      messageEmpty = 'There are no favorite logs.';
    } else if (selectedCategoryIndex == 2) {
      final mealsData = Provider.of<MealLogs>(context);
      meals = mealsData.skippedMeals;
      if (meals != null)
        displayList = [...meals];
      else
        displayList = [];
      messageEmpty = 'There are no skipped meals.';
    } else if (selectedCategoryIndex == 3) {
      final mealsData = Provider.of<MealLogs>(context);
      final behaviorsData = Provider.of<Behaviors>(context);
      final feelingsData = Provider.of<Feelings>(context);
      final thoughtsData = Provider.of<Thoughts>(context);
      thoughts = thoughtsData.backLogThoughts;
      feelings = feelingsData.backLogFeelings;
      behaviors = behaviorsData.backLogBehaviors;
      meals = mealsData.backLogMeals;
      displayList = [...meals, ...behaviors, ...feelings, ...thoughts];
      messageEmpty = 'There are no back logs.';
    } else if (selectedCategoryIndex == 5) {
      final thoughtsData = Provider.of<Thoughts>(context);
      final mealsData = Provider.of<MealLogs>(context);
      final behaviorsData = Provider.of<Behaviors>(context);
      behaviors = behaviorsData.behaviorsWithThoughts;
      meals = mealsData.mealsWithThoughts;
      thoughts = thoughtsData.thoughts;
      displayList = [...thoughts, ...meals, ...behaviors];
      messageEmpty = 'There are no logs with thoughts.';
      buttonTitleAdd = 'Add a thought';
      routeNextToAdd = AddThoughtScreen.routeName;
    } else if (selectedCategoryIndex == 6) {
      final feelingsData = Provider.of<Feelings>(context);
      final mealsData = Provider.of<MealLogs>(context);
      meals = mealsData.mealsWithFeelings;
      feelings = feelingsData.feelings;
      displayList = [...feelings, ...meals];
      messageEmpty = 'There are no logs with feelings.';
      buttonTitleAdd = 'Add feelings';
      routeNextToAdd = AddFeelingLogScreen.routeName;
    } else if (selectedCategoryIndex == 7) {
      final behaviorsData = Provider.of<Behaviors>(context);
      behaviors = behaviorsData.behaviors;
      displayList = [...behaviors];
      messageEmpty = 'There are no logs for behaviors.';
      buttonTitleAdd = 'Add behaviors';
      routeNextToAdd = AddBehaviorLogScreen.routeName;
    }

    return (displayList == null || displayList.isEmpty)
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  messageEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
                if (selectedCategoryIndex >= 5)
                  const SizedBox(
                    height: 8,
                  ),
                if (selectedCategoryIndex >= 5)
                  FlatButton(
                    textColor: Colors.yellow[700],
                    highlightColor: Theme.of(context).accentColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed(routeNextToAdd);
                    },
                    child: Text(
                      buttonTitleAdd,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
              ],
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
                  child: MealLogItem(selectedCategory),
                );
              if (obj is Thought)
                return ChangeNotifierProvider.value(
                  value: obj,
                  child: ThoughtItem(),
                );
              if (obj is Feeling)
                return ChangeNotifierProvider.value(
                  value: obj,
                  child: FeelingLogItem(),
                );
              if (obj is Behavior)
                return ChangeNotifierProvider.value(
                  value: obj,
                  child: BehaviorLogItem(selectedCategory),
                );
              return null;
            },
            order: StickyGroupedListOrder.DESC,
          );
  }
}
