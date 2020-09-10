import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../providers/meal_log.dart';
import '../../../providers/meal_logs.dart';
import '../../../providers/auth.dart';
//import '../widgets/app_drawer.dart';

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
  'grazing',
  'planned binge',
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
  'inadequate',
  'adequate',
  'excessive',
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
    isBackLogMeal: false,
    dateTimeOfLog: null,
  );

  var _isInit = true;

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
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    if (_editedMealLog.id != null) {
      DateTime date = _editedMealLog.date;
      _editedMealLog = MealLog(
        id: _editedMealLog.id,
        userId: _editedMealLog.userId,
        date: new DateTime(date.year, date.month, date.day,
            _selectedTime.hour, _selectedTime.minute),
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
        isBackLogMeal: _editedMealLog.isBackLogMeal,
        dateTimeOfLog: _editedMealLog.date,
        isFavorite: _editedMealLog.isFavorite,
        dateTimeOfLastUpdate: DateTime.now(),
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
                      //meal thoughts input
                      _buildMealThoughts(),
                    ],
                  )
                : ListView(
                    children: <Widget>[
                      //skip input
                      _buildSkipInput(),
                      //meal type input
                      _buildMealTypeInput(),
                      //feeling overall input
                      _buildOverallFeelingInput(),
                      //meal thoughts input
                      _buildMealThoughts(),
                      //meal skipping reason
                      _buildMealSkippingReason(),
                    ],
                  ),
          ),
        ),
        //drawer: AppDrawer(),
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
          children: <Widget>[
            ListTile(
              title: Text(
                'How are you felling overall?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
              contentPadding: EdgeInsets.all(0.0),
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
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            ToggleSwitch(
              labels: (_skip) ? ['Yes'] : ['No'],
              fontSize: 18.0,
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
                  fontSize: 18.0,
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
                  fontSize: 18.0,
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
                  fontSize: 18.0,
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
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_selectedMealDate.day}. ${_selectedMealDate.month}. ${_selectedMealDate.year}',
                  style: TextStyle(
                    fontSize: 18.0,
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
                      fontSize: 18.0,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'What did you eat?',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.camera_alt,
                  size: 30.0,
                ),
              ],
            ),
            TextFormField(
              initialValue: _initDescription,
              //decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a description.';
                }
                if (value.length < 5) {
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
                  mealDescription: value,
                  mealPortion: _editedMealLog.mealPortion,
                  thoughts: _editedMealLog.thoughts,
                  skippingReason: _editedMealLog.skippingReason,
                  isBackLogMeal: _editedMealLog.isBackLogMeal,
                  dateTimeOfLog: _editedMealLog.date,
                  isFavorite: _editedMealLog.isFavorite,
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
                'How much did you eat?',
                style: TextStyle(
                  fontSize: 18.0,
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
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextFormField(
              initialValue: _initThoughts,
              //decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
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
                  thoughts: value,
                  skippingReason: _editedMealLog.skippingReason,
                  isBackLogMeal: _editedMealLog.isBackLogMeal,
                  dateTimeOfLog: _editedMealLog.date,
                  isFavorite: _editedMealLog.isFavorite,
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
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextFormField(
              initialValue: _initSkippingReason,
              //decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
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
                  skippingReason: value,
                  isBackLogMeal: _editedMealLog.isBackLogMeal,
                  dateTimeOfLog: _editedMealLog.date,
                  isFavorite: _editedMealLog.isFavorite,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
