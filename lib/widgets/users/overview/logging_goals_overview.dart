import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/logging_goals.dart';
import '../../../providers/meal_logs.dart';
import './logging_goal_item.dart';

class MealsNumber {
  DateTime date;
  int mainMeals;
  int snacks;

  MealsNumber(this.date, this.mainMeals, this.snacks);
}

class LoggingGoalsOverview extends StatelessWidget {
  List<dynamic> sort(List<dynamic> list) {
    list.sort(
      (a, b) => b.date.compareTo(a.date),
    );
    return list;
  }
  @override
  Widget build(BuildContext context) {
    var meals = Provider.of<MealLogs>(context, listen: false).meals;
    meals = sort(meals);
    final loggingGoalsData = Provider.of<LoggingGoals>(context);
    loggingGoalsData.clear();
    meals.forEach((meal) {
      if (!meal.skip) {
        loggingGoalsData.addMealForGoals(meal.date, meal.mealType);
      }
    });
    final loggingGoals = loggingGoalsData.loggingGoals;

    final mainMealsWeekday = loggingGoalsData.mainMealsWeekday;
    final mainMealsWeekend = loggingGoalsData.mainMealsWeekend;
    final snacksWeekday = loggingGoalsData.snacksWeekday;
    final snacksWeekend = loggingGoalsData.snacksWeekend;

    return ListView.separated(
      itemCount: loggingGoals.length,
      itemBuilder: (context, index) {
        DateTime date = loggingGoals.keys.elementAt(index);
        return (date.weekday == DateTime.saturday ||
                date.weekday == DateTime.sunday)
            ? LoggingGoalItem(
                date: date,
                mainMeals: loggingGoals[date].mainMeals,
                snacks: loggingGoals[date].snacks,
                settingsMainMeals: mainMealsWeekend,
                settingsSnacks: snacksWeekend,
              )
            : LoggingGoalItem(
                date: date,
                mainMeals: loggingGoals[date].mainMeals,
                snacks: loggingGoals[date].snacks,
                settingsMainMeals: mainMealsWeekday,
                settingsSnacks: snacksWeekday,
              );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
