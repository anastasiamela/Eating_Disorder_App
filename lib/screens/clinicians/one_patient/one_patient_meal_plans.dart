import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/meal_plans.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../widgets/clinicians/one_patient/meal_plan_item.dart';

//import '../add_input/add_meal_plan.dart';

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

class OnePatientMealPlansScreen extends StatefulWidget {
  static const routeName = '/one-patient-meal-plans';
  @override
  _OnePatientMealPlansScreenState createState() =>
      _OnePatientMealPlansScreenState();
}

class _OnePatientMealPlansScreenState extends State<OnePatientMealPlansScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Tab> tabsList = [
    Tab(text: 'All'),
    Tab(text: 'Monday'),
    Tab(text: 'Thuesday'),
    Tab(text: 'Wednesday'),
    Tab(text: 'Thursday'),
    Tab(text: 'Friday'),
    Tab(text: 'Saturday'),
    Tab(text: 'Sunday'),
  ];
  var selectedIndex = 0;
  var _isInit = true;
  var _isLoading = false;

  PatientOfClinician patient;

  @override
  void initState() {
    _tabController = new TabController(length: tabsList.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      patient = ModalRoute.of(context).settings.arguments as PatientOfClinician;
      setState(() {
        _isLoading = true;
      });

      Provider.of<MealPlans>(context)
          .fetchAndSetMealPlans(patient.patientId)
          .then((_) {
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
    Provider.of<MealPlans>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Meal Planner'),
        bottom: TabBar(
          tabs: tabsList,
          controller: _tabController,
          isScrollable: true,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: _days.length,
                  itemBuilder: (_, i) => _buildDay(_days[i], true),
                ),
          ListView(
            children: [
              _buildDay('Monday', false),
            ],
          ),
          ListView(
            children: [
              _buildDay('Thuesday', false),
            ],
          ),
          ListView(
            children: [
              _buildDay('Wednesday', false),
            ],
          ),
          ListView(
            children: [
              _buildDay('Thursday', false),
            ],
          ),
          ListView(
            children: [
              _buildDay('Friday', false),
            ],
          ),
          ListView(
            children: [
              _buildDay('Saturday', false),
            ],
          ),
          ListView(
            children: [
              _buildDay('Sunday', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDay(String day, bool showDayText) {
    return Column(
      children: [
        if (showDayText)
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
    return ChangeNotifierProvider.value(
      value: plan,
      child: _buildMealTypeInfo(day, type, plan),
    );
  }

  Widget _buildMealTypeInfo(String day, String type, MealPlan plan) {
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
                        'nothing',
                        style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : MealPlanItem()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
