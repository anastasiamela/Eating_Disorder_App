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
import '../../../screens/users/add_input/add_meal_log_screen.dart';

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
      messageEmpty = 'There are no logs.';
    } else if (selectedCategoryIndex == 1) {
      behaviors = behaviorsData.favoriteBehaviors;
      meals = mealsData.favoriteMeals;
      thoughts = thoughtsData.favoriteThoughts;
      feelings = feelingsData.favoriteFeelings;
      displayList = sort([...meals, ...thoughts, ...feelings, ...behaviors]);
      messageEmpty = 'There are no favorite logs.';
    } else if (selectedCategoryIndex == 2) {
      meals = mealsData.meals;
      displayList = sort([...meals]);
      messageEmpty = 'There are no meal logs.';
      buttonTitleAdd = 'Add a meal';
      routeNextToAdd = AddMealLogScreen.routeName;
    } else if (selectedCategoryIndex == 3) {
      meals = mealsData.skippedMeals;
      if (meals != null)
        displayList = [...meals];
      else
        displayList = [];
      messageEmpty = 'There are no skipped meals.';
    } else if (selectedCategoryIndex == 4) {
      thoughts = thoughtsData.backLogThoughts;
      feelings = feelingsData.backLogFeelings;
      behaviors = behaviorsData.backLogBehaviors;
      meals = mealsData.backLogMeals;
      displayList = [...meals, ...behaviors, ...feelings, ...thoughts];
      messageEmpty = 'There are no back logs.';
    } else if (selectedCategoryIndex == 6) {
      feelings = feelingsData.feelingsWithThoughts;
      behaviors = behaviorsData.behaviorsWithThoughts;
      meals = mealsData.mealsWithThoughts;
      thoughts = thoughtsData.thoughts;
      displayList = [...thoughts, ...meals, ...behaviors, ...feelings];
      messageEmpty = 'There are no logs with thoughts.';
      buttonTitleAdd = 'Add a thought';
      routeNextToAdd = AddThoughtScreen.routeName;
    } else if (selectedCategoryIndex == 7) {
      meals = mealsData.mealsWithFeelings;
      feelings = feelingsData.feelings;
      displayList = [...feelings, ...meals];
      messageEmpty = 'There are no logs with feelings.';
      buttonTitleAdd = 'Add feelings';
      routeNextToAdd = AddFeelingLogScreen.routeName;
    } else if (selectedCategoryIndex == 8) {
      behaviors = behaviorsData.behaviors;
      meals = mealsData.mealsWithBehaviors;
      displayList = [...behaviors, ...meals];
      messageEmpty = 'There are no logs for behaviors.';
      buttonTitleAdd = 'Add behaviors';
      routeNextToAdd = AddBehaviorLogScreen.routeName;
    } else if (selectedCategoryIndex == 9) {
      behaviors = behaviorsData.behaviorsWithCopingSkills;
      displayList = [...behaviors];
      messageEmpty = 'There are no logs with coping skills.';
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
                if ((selectedCategoryIndex >= 6 &&
                        selectedCategoryIndex != 9) ||
                    selectedCategoryIndex == 2)
                  const SizedBox(
                    height: 8,
                  ),
                if ((selectedCategoryIndex >= 6 &&
                        selectedCategoryIndex != 9) ||
                    selectedCategoryIndex == 2)
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
                  child: FeelingLogItem(selectedCategory),
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
