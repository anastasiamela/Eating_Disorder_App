import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../providers/meal_plans.dart';
import '../../../providers/auth.dart';

class AddMealPlan extends StatefulWidget {
  static const routeName = '/add-meal-plan';

  @override
  _AddMealPlanState createState() => _AddMealPlanState();
}

class _AddMealPlanState extends State<AddMealPlan> {
  final _form = GlobalKey<FormState>();
  String day;
  String type;
  List<String> _mealItems;
  bool _isTemplate;

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final entry = ModalRoute.of(context).settings.arguments as MealPlan;
      _mealItems = [''];
      type = entry.typeOfMeal;
      day = entry.dayOfWeek;
      _isTemplate = entry.isTemplate;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm(BuildContext context) {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_mealItems.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
                'There are no meal items to save as a meal plan. You should have at list one meal item'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              )
            ],
          );
        },
      );
      return;
    }
    final userId = Provider.of<Auth>(context, listen: false).userId;
    DateTime date = DateTime.now();
    MealPlan newMealPlan = MealPlan(
      id: '',
      userId: userId,
      dayOfWeek: day,
      typeOfMeal: type,
      mealItems: _mealItems,
      createdAt: date,
      isTemplate: _isTemplate,
    );
    Provider.of<MealPlans>(context, listen: false).addMealPlan(newMealPlan, userId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$day $type'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () => {_saveForm(context)},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              ..._getMealItems(),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(
                        width: 8.0,
                      ),
                      const Text('Add another meal item.'),
                    ],
                  ),
                ),
                onTap: _add,
              ),
              _buildIsTemplateInput(),
            ],
          ),
        ),
      ),
    );
  }

  void _add() {
    setState(() {
      _mealItems.add('');
    });
  }

  void _delete(int index) {
    setState(() {
      _mealItems.removeAt(index);
    });
  }

  List<Widget> _getMealItems() {
    List<Widget> mealItemsTextFormFieldsList = [];
    for (int i = 0; i < _mealItems.length; i++) {
      mealItemsTextFormFieldsList.add(_buildMealItemInput(i));
    }
    return mealItemsTextFormFieldsList;
  }

  Widget _buildMealItemInput(int index) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _delete(index);
      },
      child: Card(
        shadowColor: Theme.of(context).primaryColor,
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: _mealItems[index],
              decoration: InputDecoration(
                hintText: 'Add meal item',
                hintStyle: TextStyle(fontStyle: FontStyle.italic),
              ),
              validator: (value) {
                if (value.length < 3) {
                  return 'Should be at least 3 characters long.';
                }
                if (value.trim().isEmpty) {
                  return 'Please enter something or remove the meal item.';
                }
                return null;
              },
              onChanged: (value) => {_mealItems[index] = value},
            ),
          ),
          trailing: InkWell(
            child: Icon(Icons.delete),
            onTap: () => _delete(index),
          ),
        ),
      ),
    );
  }

  Widget _buildIsTemplateInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            'Do you want to save this meal as a template?',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: ToggleSwitch(
            labels: ['Yes', 'No'],
            initialLabelIndex: (_isTemplate) ? 0 : 1,
            onToggle: (index) {
              if (index == 0) {
                setState(() {
                  _isTemplate = !_isTemplate;
                });
              } else {
                setState(() {
                  _isTemplate = !_isTemplate;
                });
              }
            },
            activeBgColor: Theme.of(context).primaryColor,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.teal[50],
            inactiveFgColor: Colors.grey[900],
          ),
        ),
      ),
    );
  }
}
