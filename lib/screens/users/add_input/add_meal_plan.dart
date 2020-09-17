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

String capitalizeFirstLetter(String input) {
  return "${input[0].toUpperCase()}${input.substring(1)}";
}

class _AddMealPlanState extends State<AddMealPlan> {
  final _form = GlobalKey<FormState>();
  String day;
  String type;
  List<String> _mealItems;
  bool _isTemplate;
  String _id;
  bool _selectedToShowTemplates;
  List<MealPlan> _templates;
  String _selectedTemplate; //will contain the id

  var _isInit = true;
  bool _isEdit;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final entry = ModalRoute.of(context).settings.arguments as MealPlan;
      type = entry.typeOfMeal;
      day = entry.dayOfWeek;
      _isTemplate = entry.isTemplate;
      if (entry.id == null) {
        _mealItems = [''];
        _isEdit = false;
      } else {
        _id = entry.id;
        _mealItems = entry.mealItems;
        _isEdit = true;
      }
      _selectedToShowTemplates = false;
      _templates = Provider.of<MealPlans>(context, listen: false)
          .getTemplateMealPlans(type);
      _selectedTemplate = '';
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
    if (!_isEdit) {
      MealPlan newMealPlan = MealPlan(
        id: '',
        userId: userId,
        dayOfWeek: day,
        typeOfMeal: type,
        mealItems: _mealItems,
        createdAt: date,
        isTemplate: _isTemplate,
      );
      Provider.of<MealPlans>(context, listen: false)
          .addMealPlan(newMealPlan, userId);
    } else {
      final entry = ModalRoute.of(context).settings.arguments as MealPlan;
      MealPlan newMealPlan = MealPlan(
        id: entry.id,
        userId: userId,
        dayOfWeek: day,
        typeOfMeal: type,
        mealItems: _mealItems,
        createdAt: date,
        isTemplate: _isTemplate,
      );
      print(_mealItems);
      Provider.of<MealPlans>(context, listen: false)
          .updateMealPlan(entry.id, newMealPlan, userId);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$day $type'),
        actions: <Widget>[
          if (_isEdit)
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () async {
                bool response = await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text(
                      'Do you want to remove the meal plan?',
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                    ],
                  ),
                );
                print(response);
                if (!response) {
                  final userId =
                      Provider.of<Auth>(context, listen: false).userId;
                  Provider.of<MealPlans>(context, listen: false)
                      .deleteMealPlan(_id, userId);
                  Navigator.of(context).pop();
                }
              },
            ),
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
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
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
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Text('Select from templates.'),
                      ],
                    ),
                  ),
                  subtitle: (_selectedToShowTemplates && _templates.length == 0)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'There are no templates for this type of meal.',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : Text(''),
                  onTap: () {
                    setState(() {
                      _selectedToShowTemplates = true;
                    });
                  },
                ),
                if (_selectedToShowTemplates && _templates.length > 0)
                  _buildTemplatesOverview(),
                _buildIsTemplateInput(),
              ],
            ),
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
                if (value.length > 30) {
                  return 'Should be less than 30 characters long.';
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

  Widget _buildTemplatesOverview() {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _templates
            .map((template) => ChangeNotifierProvider.value(
                  value: template,
                  child: GestureDetector(
                    child: Card(
                      shadowColor: Theme.of(context).primaryColor,
                      child: Container(
                        color: (template.id == _selectedTemplate)
                            ? Colors.teal[50]
                            : Colors.transparent,
                        height: 150.0,
                        width: 180.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  capitalizeFirstLetter(template.dayOfWeek),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                ...template.getMealItems
                                    .map((item) => Row(
                                          children: [
                                            Icon(Icons.near_me),
                                            Text(item),
                                          ],
                                        ))
                                    .toList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _mealItems = template.getMealItems;
                        _selectedTemplate = template.id;
                      });
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }
}
