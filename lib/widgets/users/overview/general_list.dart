import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../../providers/meal_logs.dart';
import '../../../providers/meal_log.dart';
import '../../../providers/thoughts.dart';

import './meal_log_item.dart';
import './thought_item.dart';

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
    final mealsData = Provider.of<MealLogs>(context);
    final thoughtsData = Provider.of<Thoughts>(context);
    String messageEmpty;
    List<Thought> thoughts;
    List<MealLog> meals;
    List displayList;
    if (selectedCategoryIndex == 0) {
      meals = mealsData.mealsSorted;
      thoughts = thoughtsData.thoughts;
      displayList = sort([...meals, ...thoughts]);
      messageEmpty = 'There are no logs.';
    } else if (selectedCategoryIndex == 1) {
      meals = mealsData.favoriteMeals;
      thoughts = thoughtsData.favoriteThoughts;
      displayList = sort([...meals, ...thoughts]);
      messageEmpty = 'There are no favorite logs.';
    } else if (selectedCategoryIndex == 2) {
      meals = mealsData.skippedMeals;
      displayList = [...meals];
      messageEmpty = 'There are no skipped meals.';
    } else {
      meals = mealsData.backLogMeals;
      displayList = [...meals];
      messageEmpty = 'There are no back log meals.';
    }

    return (meals.isEmpty)
        ? Center(
            child: (selectedCategoryIndex != 0)
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: Text(
                          messageEmpty,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    'There are no meal logs!',
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
                  child: MealLogItem(),
                );
              if (obj is Thought)
                return ChangeNotifierProvider.value(
                  value: obj,
                  child: ThoughtItem(),
                );
              return null;
            },
            order: StickyGroupedListOrder.DESC,
          );
  }
}
