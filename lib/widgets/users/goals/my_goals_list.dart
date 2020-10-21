import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/goals.dart';

import './goal_item.dart';

class MyGoalsList extends StatelessWidget {
  final int selectedCategoryIndex;
  final String selectedCategory;

  MyGoalsList(this.selectedCategoryIndex, this.selectedCategory);

  List<dynamic> sortActive(List<dynamic> list) {
    list.sort(
      (a, b) => b.scheduleToCompleteDate.compareTo(a.scheduleToCompleteDate),
    );
    return list;
  }

  List<dynamic> sortCompleted(List<dynamic> list) {
    list.sort(
      (a, b) => b.completeDate.compareTo(a.completeDate),
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final goalsData = Provider.of<Goals>(context);
    List<Goal> goals = [];
    if (selectedCategoryIndex == 0) {
      goals = goalsData.activeGoals;
      goals = sortActive(goals);
    } else if (selectedCategoryIndex == 1) {
      goals = goalsData.completedGoals;
      goals = sortCompleted(goals);
    }    
    return (goals.isEmpty)
        ? Center(
            child: (selectedCategoryIndex == 0) ? Text('You have not active goals.') : Text('You have not completed goals.'),
          )
        : ListView.builder(
            itemCount: goals.length,
            itemBuilder: (_, i) {
              return ChangeNotifierProvider.value(
                value: goals[i],
                child: GoalItem(),
              );
            },
          );
  }
}
