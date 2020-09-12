import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../providers/feelings.dart';
import '../../../providers/auth.dart';

import '../../../models/emoji_view.dart';

List<String> _overallFeelings = [
  'Depressed',
  'Down',
  'Flat',
  'Average',
  'Good',
  'Great',
  'Overjoyed',
];

List<String> moodsToDisplay = [
  'Happy',
  'Tired',
  'Anxious',
  'Sad',
  'Lonely',
  'Proud',
  'Hopeful',
  'Frustrated',
  'Guilty',
  'Disgust',
  'Bored',
  'Physical Pain',
  'Intrusive Food Thoughts',
  'Dizzy / Headache',
  'Irritable',
  'Angry',
  'Depressed',
  'Motivated',
  'Excited',
  'Grateful',
  'Joy',
  'Loved',
  'Satisfied',
  'Fearful',
  'Dynamic',
];

class AddFeelingLogScreen extends StatefulWidget {
  static const routeName = '/add-feeling';
  @override
  _AddFeelingLogScreenState createState() => _AddFeelingLogScreenState();
}

class _AddFeelingLogScreenState extends State<AddFeelingLogScreen> {
  final _form = GlobalKey<FormState>();
  String _inputOverallFeeling;
  List<String> _inputMoods;
  String _thoughtsInput;
  Map<String, bool> _moodsSelected = new Map();
  double _currentSliderValue = 4.0;
  bool _isBackLog;
  bool _hasSelectedDateBackLog;
  bool _hasSelectedTime;
  TimeOfDay _selectedTime;
  DateTime _selectedDate;

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      moodsToDisplay.forEach((element) => _moodsSelected[element] = false);
      _inputMoods = [];
      _thoughtsInput = '';
      _isBackLog = false;
      _hasSelectedDateBackLog = false;
      _hasSelectedTime = false;
      _selectedTime = TimeOfDay.now();
      _selectedDate = DateTime.now();
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
    final userId = Provider.of<Auth>(context, listen: false).userId;
    _inputOverallFeeling = _overallFeelings[_currentSliderValue.round() - 1];
    _moodsSelected.forEach((key, value) => {if (value) _inputMoods.add(key)});
    DateTime date = DateTime.now();
    DateTime dateFinal;
    if (_isBackLog) {
      if (_hasSelectedTime && _hasSelectedDateBackLog) {
        dateFinal = new DateTime(_selectedDate.year, _selectedDate.month,
            _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
      }
    } else {
      dateFinal = new DateTime(date.year, date.month, date.day,
          _selectedTime.hour, _selectedTime.minute);
    }
    Feeling newFeeling = Feeling(
      id: '',
      userId: userId,
      date: dateFinal,
      overallFeeling: _inputOverallFeeling,
      moods: _inputMoods,
      thoughts: _thoughtsInput,
      isBackLog: _isBackLog,
      dateTimeOfLog: date,
    );
    Provider.of<Feelings>(context, listen: false)
        .addFeeling(newFeeling, userId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your feelings'),
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
        padding: EdgeInsets.all(8),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              _buildIsBacklogIinput(),
              if (_isBackLog) _buildDateBackLogInput(),
              _buildTimeInput(),
              _buildOverallFeelingSlider(),
              _buildMoodsInput(),
              _buildThoughtsInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodsInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: GridView.count(
        padding: EdgeInsets.all(8),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        crossAxisCount: 3,
        children: moodsToDisplay
            .map(
              (mood) => GestureDetector(
                onTap: () {
                  setState(() {
                    _moodsSelected[mood] = !_moodsSelected[mood];
                  });
                },
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: _moodsSelected[mood]
                        ? Colors.purple[100]
                        : Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getEmojiTextView(mood),
                        style: TextStyle(
                          fontSize: 50,
                          //backgroundColor: Theme.of(context).accentColor,
                        ),
                      ),
                      Text(
                        mood,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildOverallFeelingSlider() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'How are you feeling overall?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Text(_overallFeelings[_currentSliderValue.round() - 1]),
              contentPadding: EdgeInsets.all(0.0),
            ),
            Slider(
              value: _currentSliderValue,
              min: 1,
              max: 7,
              divisions: 6,
              label: _overallFeelings[_currentSliderValue.round() - 1],
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                  print(_currentSliderValue);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThoughtsInput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Container(
        //height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Do you have any thoughts?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                contentPadding: EdgeInsets.all(0.0),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: 'Your thoughts',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic)),
                validator: (value) {
                  if (value.length < 5) {
                    return 'Should be at least 5 characters long.';
                  }
                  return null;
                },
                onSaved: (value) => _thoughtsInput = value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIsBacklogIinput() {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Is this log for today?',
              style: TextStyle(
                fontSize: 18.0,
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
                    _hasSelectedTime = false;
                    _selectedTime = null;
                  });
                } else {
                  setState(() {
                    _isBackLog = !_isBackLog;
                    _selectedTime = null;
                    _hasSelectedDateBackLog = false;
                    _hasSelectedTime = false;
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
                'For when is the log?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
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
                      fontSize: 18.0,
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
                    '${_selectedDate.day}. ${_selectedDate.month}. ${_selectedDate.year}',
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

  Widget _buildTimeInput() {
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
                  'What time?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
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
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _pickTime,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              (_hasSelectedTime)
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
                        if (_hasSelectedTime == false) {
                          return 'You have to select time!';
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
      setState(() {
        _selectedTime = t;
        _hasSelectedTime = true;
      });
    }
  }

  _pickDate() async {
    DateTime today = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      firstDate: today.subtract(Duration(days: 7)),
      lastDate: today.subtract(Duration(days: 1)),
      initialDate: today.subtract(Duration(days: 1)),
    );
    if (date != null)
      setState(() {
        _selectedDate = date;
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
}
