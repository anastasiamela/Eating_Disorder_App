import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/meal_plans.dart';
import '../../../providers/auth.dart';

import '../../../widgets/users/app_drawer.dart';
import '../../../widgets/users/meal_plans/meal_plan_item_for_overwiew.dart';

import '../add_input/add_meal_plan.dart';

List<String> _days = [
  'Monday',
  'Thuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

List<String> _mealTypes = [
  'Breakfast',
  'Morning Snack',
  'Lunch',
  'Afternoon Snack',
  'Dinner',
  'Evening Snack',
];

class MealPlansOverviewScreen extends StatefulWidget {
  static const routeName = '/meal-plans-overview';
  @override
  _MealPlansOverviewScreenState createState() =>
      _MealPlansOverviewScreenState();
}

class _MealPlansOverviewScreenState extends State<MealPlansOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final userId = Provider.of<Auth>(context, listen: false).userId;

      Provider.of<MealPlans>(context).fetchAndSetMealPlans(userId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Meal Planner'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _days.length,
              itemBuilder: (_, i) => _buildDay(_days[i]),
            ),
    );
  }

  Widget _buildDay(String day) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Card(
          shadowColor: Theme.of(context).primaryColor,
          child: Column(
            children:
                _mealTypes.map((type) => _buildMealType(day, type)).toList(),
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _buildMealType(String day, String type) {
    final mealPlansData = Provider.of<MealPlans>(context);
    MealPlan plan = mealPlansData.findByDayAndType(day, type);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$type:',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                  ),
                ),
                (plan == null)
                    ? Text(
                        'tap to update.',
                        style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : ChangeNotifierProvider.value(
                        value: plan,
                        child: MealPlanItemForOverview(),
                      ),
              ],
            ),
            onTap: () {
              if (plan == null) {
                Navigator.of(context).pushNamed(
                  AddMealPlan.routeName,
                  arguments: MealPlan(
                      id: null,
                      userId: null,
                      dayOfWeek: day,
                      typeOfMeal: type,
                      mealItems: [''],
                      createdAt: null),
                );
              } else {
                Navigator.of(context).pushNamed(
                  AddMealPlan.routeName,
                  arguments: MealPlan(
                      id: null,
                      userId: null,
                      dayOfWeek: day,
                      typeOfMeal: type,
                      mealItems: [''],
                      createdAt: null),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
