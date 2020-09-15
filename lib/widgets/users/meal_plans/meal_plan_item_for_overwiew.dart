import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/meal_plans.dart';

class MealPlanItemForOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mealPlan = Provider.of<MealPlan>(context, listen: false);
    //final authData = Provider.of<Auth>(context, listen: false);
    final mealItems = mealPlan.mealItems;
    return Container(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: mealItems
            .map((item) => Row(
                  children: [
                    Icon(Icons.near_me),
                    Expanded(child: Text(item)),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
