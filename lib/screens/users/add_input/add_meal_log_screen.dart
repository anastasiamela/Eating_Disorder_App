import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'dart:io';

import '../../../providers/meal_log.dart';
import '../../../providers/meal_logs.dart';
import '../../../providers/auth.dart';
import '../../../providers/settings_for_logs.dart';

import '../../../widgets/users/image_pickers/meal_log_image_picker.dart';

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

List<int> _mealAgoTime = [
  5,
  10,
  30,
  0,
];

List<String> _mealPortion = [
  'Extreme Hunger',
  'Hunger',
  'Satisfied',
  'Full',
  'Extreme Fullness',
];

class AddMealLogScreen extends StatefulWidget {
  static const routeName = '/add-meal-log';

  @override
  _AddMealLogScreenState createState() => _AddMealLogScreenState();
}

class _AddMealLogScreenState extends State<AddMealLogScreen> {
  final _form = GlobalKey<FormState>();
  bool _skip;
  // a new change
  String _overallFeeling;
  String _selectedMealType;
  String _selectedMealCompany;
  String _selectedMealLocation;
  int _selectedMealAgoTime;
  bool _otherAgoTime;
  TimeOfDay _selectedTime;
  String _selectedPortion;
  bool _isBackLog;
  DateTime _selectedMealDate; //for backlog
  bool _hasSelectedDateBackLog;
  bool _hasSelectedTimeBackLog;

  //extra init values for the editing
  String _initDescription;
  String _initThoughts;
  String _initSkippingReason;

  List<String> _feelingTypesChoices = [];
  List<String> _inputFeelings;
  Map<String, bool> _feelingsSelected = new Map();
  List<String> _behaviorTypesChoices = [];
  List<String> _inputBehaviors;
  Map<String, bool> _behaviorsSelected = new Map();

  File _imageFile;

  void _pickedImage(File image) {
    _imageFile = image;
  }

  var _editedMealLog = MealLog(
      id: null,
      userId: '',
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
      feelingsList: []);

  var _isInit = true;
  var _isLoading = false;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _skip = _editedMealLog.skip;
      _isBackLog = _editedMealLog.isBackLog;
      _hasSelectedDateBackLog = false;
      _hasSelectedTimeBackLog = false;
      _selectedMealDate = DateTime.now();
      _overallFeeling = 'average';
      _selectedMealType = 'breakfast';
      _selectedMealLocation = _editedMealLog.mealLocation;
      _selectedMealCompany = _editedMealLog.mealCompany;
      _selectedPortion = _editedMealLog.mealPortion;
      _otherAgoTime = false;
      _selectedTime = TimeOfDay.now();
      _initDescription = '';
      _initThoughts = '';
      _initSkippingReason = '';
      _initializeBehaviorsAndFeelings();
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
    _feelingTypesChoices =
        Provider.of<SettingsForLogs>(context, listen: false).feelingTypesList;
    _feelingTypesChoices
        .forEach((feeling) => _feelingsSelected[feeling] = false);
    _inputBehaviors = [];
    _inputFeelings = [];
    setState(() {
      _isLoading = false;
    });
  }

  void _saveForm(BuildContext context) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    DateTime date = DateTime.now();
    DateTime dateTimeOfMealFinal;
    //find the datetime of the meal
    if (!_skip) {
      if (!_isBackLog) {
        if (_otherAgoTime) {
          dateTimeOfMealFinal = new DateTime(date.year, date.month, date.day,
              _selectedTime.hour, _selectedTime.minute);
        } else if (_selectedMealAgoTime != null) {
          dateTimeOfMealFinal =
              date.subtract(Duration(minutes: _selectedMealAgoTime));
        }
      } else {
        if (_hasSelectedTimeBackLog && _hasSelectedDateBackLog) {
          dateTimeOfMealFinal = new DateTime(
              _selectedMealDate.year,
              _selectedMealDate.month,
              _selectedMealDate.day,
              _selectedTime.hour,
              _selectedTime.minute);
        }
      }
    } else {
      if (!_isBackLog) {
        dateTimeOfMealFinal = date;
      } else {
        dateTimeOfMealFinal = new DateTime(
          _selectedMealDate.year,
          _selectedMealDate.month,
          _selectedMealDate.day,
        );
      }
    }
    if (_behaviorTypesChoices.isNotEmpty) {
      _behaviorsSelected
          .forEach((key, value) => {if (value) _inputBehaviors.add(key)});
    }
    if (_feelingTypesChoices.isNotEmpty) {
      _feelingsSelected
          .forEach((key, value) => {if (value) _inputFeelings.add(key)});
    }

    _editedMealLog = MealLog(
      id: _editedMealLog.id,
      userId: _editedMealLog.userId,
      date: dateTimeOfMealFinal,
      skip: _skip,
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
      dateTimeOfLog: date,
      dateTimeOfLastUpdate: DateTime.now(),
      behaviorsList: _inputBehaviors,
      feelingsList: _inputFeelings,
    );
    final userId = Provider.of<Auth>(context, listen: false).userId;
    setState(() {
      _isSaving = true;
    });
    await Provider.of<MealLogs>(context, listen: false)
        .addMealLog(_editedMealLog, userId, _imageFile);
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
          title: Text('Add meal log'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () => _saveForm(context),
            ),
          ],
        ),
        body: _isSaving
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(5.0),
                child: Form(
                  //autovalidate: true,
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
                            //meal is backlog input
                            _buildMealIsBacklogIinput(),
                            (!_isBackLog)
                                ?
                                //meal ago time input
                                _buildMealAgoTimeInput()
                                //meal date and time input for a backlog meal
                                : _buildDateBackLogInput(),
                            (!_isBackLog)
                                ? SizedBox(height: 0)
                                //meal date and time input for a backlog meal
                                : _buildTimeBackLogInput(),
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
                              onPressed: () {
                                _saveForm(context);
                              },
                            )
                          ],
                        )
                      : ListView(
                          children: <Widget>[
                            //skip input
                            _buildSkipInput(),
                            //meal skipping reason
                            _buildMealSkippingReason(),
                            //meal is backlog input
                            _buildMealIsBacklogIinput(),
                            (!_isBackLog)
                                ? SizedBox(height: 0)
                                //meal date input for a backlog meal
                                : _buildDateBackLogInput(),
                            //meal type input
                            _buildMealTypeInput(),
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
                              onPressed: () {
                                _saveForm(context);
                              },
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
              labels: ['Yes', 'No'],
              initialLabelIndex: (_skip) ? 0 : 1,
              onToggle: (index) {
                setState(() {
                  _skip = !_skip;
                  _overallFeeling = 'average';
                  _selectedMealType = 'breakfast';
                });
              },
              activeBgColor: Theme.of(context).primaryColor,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.purple[50],
              inactiveFgColor: Colors.grey[900],
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
                        backgroundColor: Colors.black26,
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
                        backgroundColor: Colors.black26,
                        padding: EdgeInsets.all(8.0),
                      ),
                    )
                    .toList(),
              ),
            ],
          )),
    );
  }

  Widget _buildMealAgoTimeInput() {
    //print('${_selectedTime.toString()}');
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
                  'How long ago did you eat?',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                (_otherAgoTime)
                    ? Text(
                        '${printTime(_selectedTime)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Text(''),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Wrap(
              spacing: 8.0,
              children: _mealAgoTime
                  .map(
                    (int agoTime) => ChoiceChip(
                      label: (agoTime != 0)
                          ? Text('$agoTime min',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ))
                          : Text(
                              'Select Time',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                      selected: _selectedMealAgoTime == agoTime,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedMealAgoTime = agoTime;
                            _otherAgoTime = false;
                            _selectedTime = null;
                          }
                          if (agoTime == 0) {
                            _pickTime();
                            _otherAgoTime = true;
                            if (_selectedTime == null) {
                              _selectedMealAgoTime = null;
                              _otherAgoTime = false;
                            }
                          }
                        });
                      },
                      selectedColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.black26,
                      padding: EdgeInsets.all(8.0),
                    ),
                  )
                  .toList(),
            ),
            TextFormField(
              initialValue: '',
              readOnly: true,
              validator: (value) {
                if (!_otherAgoTime && _selectedMealAgoTime == null) {
                  //if you have not selected any time option
                  return 'You have to select time!';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateBackLogInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                'When was your meal?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              contentPadding: EdgeInsets.all(0.0),
              trailing: Container(
                width: 150,
                child: RaisedButton(
                  child: Text(
                    'Select Day',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: _pickDate,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            (_hasSelectedDateBackLog)
                ? Text(
                    '${_selectedMealDate.day}. ${_selectedMealDate.month}. ${_selectedMealDate.year}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : TextFormField(
                    initialValue: '',
                    readOnly: true,
                    validator: (value) {
                      if (_hasSelectedDateBackLog == false) {
                        //if you have not selected day
                        return 'You have to select a day!';
                      }
                      return null;
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBackLogInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(
                  'What time was your meal?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
                contentPadding: EdgeInsets.all(0.0),
                trailing: Container(
                  width: 150,
                  child: RaisedButton(
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
                ),
              ),
              (_hasSelectedTimeBackLog)
                  ? Text(
                      '${printTime(_selectedTime)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : TextFormField(
                      initialValue: '',
                      readOnly: true,
                      validator: (value) {
                        if (_hasSelectedTimeBackLog == false) {
                          //if you have not selected day
                          return 'You have to select a time!';
                        }
                        return null;
                      },
                    ),
            ],
          ),
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
      if (!_isBackLog) {
        setState(() {
          _selectedTime = t;
          _otherAgoTime = true;
          _hasSelectedTimeBackLog = false;
        });
      } else {
        setState(() {
          _selectedTime = t;
          _hasSelectedTimeBackLog = true;
          _otherAgoTime = false;
        });
      }
    }
  }

  _pickDate() async {
    DateTime today = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      firstDate: today.subtract(Duration(days: 8)),
      lastDate: today.subtract(Duration(days: 1)),
      initialDate: today.subtract(Duration(days: 1)),
    );
    if (date != null)
      setState(() {
        _selectedMealDate = date;
        _hasSelectedDateBackLog = true;
      });
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
            MealLogImagePicker(_pickedImage),
            TextFormField(
              initialValue: _initDescription,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Please enter a description.';
                }
                if (value.trim().length < 4) {
                  return 'Should be at least 4 characters long.';
                }
                return null;
              },
              onChanged: (value) {
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
                        backgroundColor: Colors.black26,
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
              //decoration: InputDecoration(labelText: 'Description'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
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
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Please enter a reason.';
                }
                if (value.trim().length < 4) {
                  return 'Should be at least 4 characters long.';
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

  Widget _buildMealIsBacklogIinput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Is this meal for today?',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            ToggleSwitch(
              labels: ['Yes', 'No'],
              initialLabelIndex: (_isBackLog) ? 1 : 0,
              onToggle: (index) {
                if (index == 0) {
                  setState(() {
                    _isBackLog = !_isBackLog;
                    _hasSelectedDateBackLog = false;
                    _hasSelectedTimeBackLog = false;
                    _selectedTime = null;
                    _otherAgoTime = false;
                  });
                } else {
                  setState(() {
                    _isBackLog = !_isBackLog;
                    _selectedTime = null;
                    _hasSelectedDateBackLog = false;
                    _hasSelectedTimeBackLog = false;
                  });
                }
              },
              activeBgColor: Theme.of(context).primaryColor,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.purple[50],
              inactiveFgColor: Colors.grey[900],
            )
          ],
        ),
      ),
    );
  }
}
