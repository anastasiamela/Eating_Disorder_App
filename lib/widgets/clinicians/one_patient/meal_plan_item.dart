import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/meal_plans.dart';

class MealPlanItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mealPlan = Provider.of<MealPlan>(context, listen: false);
    final mealItems = mealPlan.mealItems;
    return Container(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: mealItems
            .map((item) => Row(
              //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.near_me),
                    Expanded(
                      child: Text(item),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
