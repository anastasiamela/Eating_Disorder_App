import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../providers/meal_log.dart';
import '../../../providers/meal_logs.dart';
import '../../../providers/auth.dart';
import '../../../providers/settings_for_logs.dart';

import '../../../models/behaviors_messages.dart';

List<String> _overallFeelings = [
  'Depressed',
  'Down',
  'Flat',
  'Average',
  'Good',
  'Great',
  'Overjoyed',
];

List<String> _mealTypes = [
  'breakfast',
  'morning snack',
  'lunch',
  'afternoon snack',
  'dinner',
  'evening snack',
  'light snack',
  'drink',
  'binge',
];

List<String> _mealCompany = [
  'alone',
  'friends',
  'parents',
  'staff',
  'partner',
  'immediate family',
  'relatives',
  'co-workers',
  'other',
];

List<String> _mealLocations = [
  'school, college, university',
  'work',
  'home',
  'friend\'s house',
  'outside',
  'restaurant, cafe',
  'at a treatment facility',
  'other',
];

List<String> _mealPortion = [
  'Extreme Hunger',
  'Hunger',
  'Satisfied',
  'Full',
  'Extreme Fullness',
];

class EditMealLogScreen extends StatefulWidget {
  static const routeName = '/edit-meal-log';

  @override
  _EditMealLogScreenState createState() => _EditMealLogScreenState();
}

class _EditMealLogScreenState extends State<EditMealLogScreen> {
  final _form = GlobalKey<FormState>();
  bool _skip;
  String _overallFeeling;
  String _selectedMealType;
  String _selectedMealCompany;
  String _selectedMealLocation;
  TimeOfDay _selectedTime;
  String _selectedPortion;
  DateTime _selectedMealDate;

  //extra init values for the editing
  String _initDescription;
  String _initThoughts;
  String _initSkippingReason;
  TimeOfDay _initTimeOfMeal;

  List<String> _feelingTypesChoices = [];
  List<String> _inputFeelings;
  Map<String, bool> _feelingsSelected = new Map();
  List<String> _feelingsInitiallySelected = [];

  List<String> _behaviorTypesChoices = [];
  List<String> _inputBehaviors;
  Map<String, bool> _behaviorsSelected = new Map();
  List<String> _behaviorsInitiallySelected = [];

  var _editedMealLog = MealLog(
    id: null,
    userId: 'anastasia',
    date: null,
    skip: false,
    feelingOverall: '',
    mealType: '',
    mealCompany: '',
    mealLocation: '',
    mealPhoto: '',
    mealDescription: '',
    mealPortion: '',
    thoughts: '',
    skippingReason: '',
    isBackLog: false,
    dateTimeOfLog: null,
    behaviorsList: [],
    feelingsList: [],
  );

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final mealLogId = ModalRoute.of(context).settings.arguments as String;
      if (mealLogId != null) {
        _editedMealLog =
            Provider.of<MealLogs>(context, listen: false).findById(mealLogId);
        //init the values
        _skip = _editedMealLog.skip;
        _selectedMealDate = _editedMealLog.date;
        _overallFeeling = _editedMealLog.feelingOverall;
        _selectedMealType = _editedMealLog.mealType;
        _selectedMealCompany = _editedMealLog.mealCompany;
        _selectedMealLocation = _editedMealLog.mealLocation;
        //_otherAgoTime = true;
        _initTimeOfMeal = TimeOfDay.fromDateTime(_editedMealLog.date);
        _selectedTime = _initTimeOfMeal;
        _selectedPortion = _editedMealLog.mealPortion;
        _initDescription = _editedMealLog.mealDescription;
        _initThoughts = _editedMealLog.thoughts;
        _initSkippingReason = _editedMealLog.skippingReason;
        _behaviorsInitiallySelected = _editedMealLog.behaviorsList;
        _feelingsInitiallySelected = _editedMealLog.feelingsList;
        _initializeBehaviorsAndFeelings();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _initializeBehaviorsAndFeelings() async {
    setState(() {
      _isLoading = true;
    });
    final userId = Provider.of<Auth>(context, listen: false).userId;
    await Provider.of<SettingsForLogs>(context)
        .fetchAndSetSettingsForLogs(userId);
    _behaviorTypesChoices =
        Provider.of<SettingsForLogs>(context, listen: false).behaviorTypesList;
    _behaviorTypesChoices
        .forEach((behavior) => _behaviorsSelected[behavior] = false);
    _behaviorsInitiallySelected
        .forEach((behavior) => _behaviorsSelected[behavior] = true);
    _feelingTypesChoices =
        Provider.of<SettingsForLogs>(context, listen: false).feelingTypesList;
    _feelingTypesChoices
        .forEach((feeling) => _feelingsSelected[feeling] = false);
    _feelingsInitiallySelected
        .forEach((feeling) => _feelingsSelected[feeling] = true);
    _inputBehaviors = [];
    _inputFeelings = [];
    setState(() {
      _isLoading = false;
    });
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    if (_behaviorTypesChoices.isNotEmpty) {
      _behaviorsSelected
          .forEach((key, value) => {if (value) _inputBehaviors.add(key)});
    }
    if (_feelingTypesChoices.isNotEmpty) {
      _feelingsSelected
          .forEach((key, value) => {if (value) _inputFeelings.add(key)});
    }

    if (_editedMealLog.id != null) {
      DateTime date = _editedMealLog.date;
      _editedMealLog = MealLog(
        id: _editedMealLog.id,
        userId: _editedMealLog.userId,
        date: new DateTime(date.year, date.month, date.day, _selectedTime.hour,
            _selectedTime.minute),
        skip: _editedMealLog.skip,
        feelingOverall: _overallFeeling,
        mealType: _selectedMealType,
        mealCompany: _selectedMealCompany,
        mealLocation: _selectedMealLocation,
        mealPhoto: _editedMealLog.mealPhoto,
        mealDescription: _editedMealLog.mealDescription,
        mealPortion: _selectedPortion,
        thoughts: _editedMealLog.thoughts,
        skippingReason: _editedMealLog.skippingReason,
        isBackLog: _editedMealLog.isBackLog,
        dateTimeOfLog: _editedMealLog.date,
        isFavorite: _editedMealLog.isFavorite,
        dateTimeOfLastUpdate: DateTime.now(),
        behaviorsList: _inputBehaviors,
        feelingsList: _inputFeelings,
      );
      final userId = Provider.of<Auth>(context, listen: false).userId;
      Provider.of<MealLogs>(context, listen: false)
          .updateMealLog(_editedMealLog.id, _editedMealLog, userId);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit your meal log'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: _saveForm,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Form(
            key: _form,
            child: (!_skip)
                ? ListView(
                    children: <Widget>[
                      //skip input
                      _buildSkipInput(),
                      //meal type input
                      _buildMealTypeInput(),
                      //meal description input
                      _buildMealDescriptionInput(),
                      //meal ago time input
                      _buildTimeInput(),
                      //feeling overall input
                      _buildOverallFeelingInput(),
                      //meal company input
                      _buildMealCompanyInput(),
                      //meal location input
                      _buildMealLocationInput(),
                      //meal portion size input
                      _buildMealPortionInput(),
                      if (_behaviorTypesChoices.isNotEmpty)
                        _buildBehaviorsInput(),
                      if (_feelingTypesChoices.isNotEmpty)
                        _buildFeelingsInput(),
                      //meal thoughts input
                      _buildMealThoughts(),
                      RaisedButton(
                        child: Text('Submit'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onPressed: _saveForm,
                      )
                    ],
                  )
                : ListView(
                    children: <Widget>[
                      //skip input
                      _buildSkipInput(),
                      //meal type input
                      _buildMealTypeInput(),
                      //meal skipping reason
                      _buildMealSkippingReason(),
                      //feeling overall input
                      _buildOverallFeelingInput(),
                      if (_behaviorTypesChoices.isNotEmpty)
                        _buildBehaviorsInput(),
                      if (_feelingTypesChoices.isNotEmpty)
                        _buildFeelingsInput(),
                      //meal thoughts input
                      _buildMealThoughts(),
                      RaisedButton(
                        child: Text('Submit'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onPressed: _saveForm,
                      )
                    ],
                  ),
          ),
        ),
        //drawer: AppDrawer(),
      ),
    );
  }

  Widget _buildBehaviorsInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Behaviors:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            (_isLoading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Wrap(
                    spacing: 8.0,
                    children: _behaviorTypesChoices
                        .map(
                          (String behavior) => FilterChip(
                            label: Text(
                              getBehaviorTitleForMealLog(behavior),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            selected: _behaviorsSelected[behavior],
                            onSelected: (bool selected) {
                              setState(() {
                                _behaviorsSelected[behavior] = selected;
                              });
                            },
                            selectedColor: Theme.of(context).primaryColor,
                            checkmarkColor: Colors.white,
                            backgroundColor: Colors.black26,
                            padding: EdgeInsets.all(8.0),
                          ),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeelingsInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Feelings:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            (_isLoading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Wrap(
                    spacing: 8.0,
                    children: _feelingTypesChoices
                        .map(
                          (String feeling) => FilterChip(
                            label: Text(
                              feeling,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            selected: _feelingsSelected[feeling],
                            onSelected: (bool selected) {
                              setState(() {
                                _feelingsSelected[feeling] = selected;
                              });
                            },
                            selectedColor: Theme.of(context).primaryColor,
                            checkmarkColor: Colors.white,
                            backgroundColor: Colors.black26,
                            padding: EdgeInsets.all(8.0),
                          ),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  //feeling overall input
  Widget _buildOverallFeelingInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'How are you felling overall?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
            Column(
              children: _overallFeelings
                  .map(
                    (String feeling) => Row(
                      children: <Widget>[
                        Radio(
                          value: feeling,
                          groupValue: _overallFeeling,
                          onChanged: (String value) {
                            setState(() {
                              _overallFeeling = value;
                            });
                          },
                        ),
                        Text(feeling),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  //skip input
  Widget _buildSkipInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Did you skip this meal?',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            ToggleSwitch(
              labels: (_skip) ? ['Yes'] : ['No'],
              initialLabelIndex: 0,
              activeBgColor: Theme.of(context).primaryColor,
              activeFgColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMealTypeInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Which meal?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Wrap(
                spacing: 8.0,
                children: _mealTypes
                    .map(
                      (String type) => ChoiceChip(
                        label: Text(
                          type,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        selected: _selectedMealType == type,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedMealType = type;
                            }
                          });
                        },
                        selectedColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.black38,
                        padding: EdgeInsets.all(8.0),
                      ),
                    )
                    .toList(),
              ),
            ],
          )),
    );
  }

  Widget _buildMealCompanyInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Who did you eat with?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Wrap(
                spacing: 8.0,
                children: _mealCompany
                    .map(
                      (String company) => ChoiceChip(
                        label: Text(
                          company,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        selected: _selectedMealCompany == company,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedMealCompany = company;
                            }
                          });
                        },
                        selectedColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.black38,
                        padding: EdgeInsets.all(8.0),
                      ),
                    )
                    .toList(),
              ),
            ],
          )),
    );
  }

  Widget _buildMealLocationInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Where did you eat?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Wrap(
                spacing: 8.0,
                children: _mealLocations
                    .map(
                      (String location) => ChoiceChip(
                        label: Text(
                          location,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        selected: _selectedMealLocation == location,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedMealLocation = location;
                            }
                          });
                        },
                        selectedColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.black38,
                        padding: EdgeInsets.all(8.0),
                      ),
                    )
                    .toList(),
              ),
            ],
          )),
    );
  }

  Widget _buildTimeInput() {
    //print('${_selectedTime.toString()}');
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'When was your meal?',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_selectedMealDate.day}. ${_selectedMealDate.month}. ${_selectedMealDate.year}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    'Select Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: _pickTime,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  'At ${printTime(_selectedTime)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) {
      setState(() {
        _selectedTime = t;
      });
    }
  }

  String printTime(TimeOfDay time) {
    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10) return '0$value';
      return value.toString();
    }

    final String hourLabel = _addLeadingZeroIfNeeded(time.hour);
    final String minuteLabel = _addLeadingZeroIfNeeded(time.minute);

    return '$hourLabel:$minuteLabel';
  }

  Widget _buildMealDescriptionInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_editedMealLog.mealPhoto.isNotEmpty)
              Container(
                height: 150,
                width: double.infinity,
                child: Image.network(
                  _editedMealLog.mealPhoto,
                  fit: BoxFit.cover,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    'What did you eat?',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Icon(
                //   Icons.camera_alt,
                //   size: 30.0,
                // ),
              ],
            ),
            TextFormField(
              initialValue: _initDescription,
              //decoration: InputDecoration(labelText: 'Description'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Please enter a description.';
                }
                if (value.trim().length < 5) {
                  return 'Should be at least 5 characters long.';
                }
                return null;
              },
              onSaved: (value) {
                _editedMealLog = MealLog(
                  id: _editedMealLog.id,
                  userId: _editedMealLog.userId,
                  date: _editedMealLog.date,
                  skip: _editedMealLog.skip,
                  feelingOverall: _editedMealLog.feelingOverall,
                  mealType: _editedMealLog.mealType,
                  mealCompany: _editedMealLog.mealCompany,
                  mealLocation: _editedMealLog.mealLocation,
                  mealPhoto: _editedMealLog.mealPhoto,
                  mealDescription: value.trim(),
                  mealPortion: _editedMealLog.mealPortion,
                  thoughts: _editedMealLog.thoughts,
                  skippingReason: _editedMealLog.skippingReason,
                  isBackLog: _editedMealLog.isBackLog,
                  dateTimeOfLog: _editedMealLog.date,
                  isFavorite: _editedMealLog.isFavorite,
                  behaviorsList: _editedMealLog.behaviorsList,
                  feelingsList: _editedMealLog.feelingsList,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMealPortionInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'How hungry or full were you after the meal?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Wrap(
                spacing: 8.0,
                children: _mealPortion
                    .map(
                      (String portion) => ChoiceChip(
                        label: Text(
                          portion,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        selected: _selectedPortion == portion,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedPortion = portion;
                            }
                          });
                        },
                        selectedColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.black38,
                        padding: EdgeInsets.all(8.0),
                      ),
                    )
                    .toList(),
              ),
            ],
          )),
    );
  }

  Widget _buildMealThoughts() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Which are your thoughts?',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextFormField(
              initialValue: _initThoughts,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onSaved: (value) {
                _editedMealLog = MealLog(
                  id: _editedMealLog.id,
                  userId: _editedMealLog.userId,
                  date: _editedMealLog.date,
                  skip: _editedMealLog.skip,
                  feelingOverall: _editedMealLog.feelingOverall,
                  mealType: _editedMealLog.mealType,
                  mealCompany: _editedMealLog.mealCompany,
                  mealLocation: _editedMealLog.mealLocation,
                  mealPhoto: _editedMealLog.mealPhoto,
                  mealDescription: _editedMealLog.mealDescription,
                  mealPortion: _editedMealLog.mealPortion,
                  thoughts: value.trim(),
                  skippingReason: _editedMealLog.skippingReason,
                  isBackLog: _editedMealLog.isBackLog,
                  dateTimeOfLog: _editedMealLog.date,
                  isFavorite: _editedMealLog.isFavorite,
                  behaviorsList: _editedMealLog.behaviorsList,
                  feelingsList: _editedMealLog.feelingsList,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMealSkippingReason() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Why did you skip this meal?',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextFormField(
              initialValue: _initSkippingReason,
              //decoration: InputDecoration(labelText: 'Description'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onSaved: (value) {
                _editedMealLog = MealLog(
                  id: _editedMealLog.id,
                  userId: _editedMealLog.userId,
                  date: _editedMealLog.date,
                  skip: _editedMealLog.skip,
                  feelingOverall: _editedMealLog.feelingOverall,
                  mealType: _editedMealLog.mealType,
                  mealCompany: _editedMealLog.mealCompany,
                  mealLocation: _editedMealLog.mealLocation,
                  mealPhoto: _editedMealLog.mealPhoto,
                  mealDescription: _editedMealLog.mealDescription,
                  mealPortion: _editedMealLog.mealPortion,
                  thoughts: _editedMealLog.thoughts,
                  skippingReason: value.trim(),
                  isBackLog: _editedMealLog.isBackLog,
                  dateTimeOfLog: _editedMealLog.date,
                  isFavorite: _editedMealLog.isFavorite,
                  behaviorsList: _editedMealLog.behaviorsList,
                  feelingsList: _editedMealLog.feelingsList,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
