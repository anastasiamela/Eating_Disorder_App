import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../../providers/behaviors.dart';
import '../../../providers/auth.dart';

import '../../../models/behaviors_messages.dart';

List<String> _behaviorTypes = [
  'restrict',
  'binge',
  'purge',
  'chewAndSpit',
  'swallowAndRegurgitate',
  'hideFood',
  'eatInSecret',
  'countCalories',
  'useLaxatives',
  'useDietPills',
  'drinkAlcohol',
  'weigh',
  'bodyCheck',
  'exercise',
];

List<String> _gradeTypes = [
  'Not at all',
  'Slight',
  'Moderate',
  'Strong',
  'Overbearing',
];

List<String> _bodyCheckTypes = [
  'Checked body in mirror',
  'Compared body with others',
  'Measured Body',
  'Other',
];

class AddBehaviorLogScreen extends StatefulWidget {
  static const routeName = '/add-behavior';
  @override
  _AddBehaviorLogScreenState createState() => _AddBehaviorLogScreenState();
}

class _AddBehaviorLogScreenState extends State<AddBehaviorLogScreen> {
  final _form = GlobalKey<FormState>();
  List<String> _inputBehaviors;
  Map<String, bool> _behaviorsSelected = new Map();
  double _currentSliderValueRestrict;
  String _restrictGradeInput;
  double _currentSliderValueBinge;
  String _bingeGradeInput;
  double _currentSliderValuePurge;
  String _purgeGradeInput;
  double _currentSliderValueExercice;
  String _exerciseGradeInput;
  List<String> _bodyCheckTypeInput;
  Map<String, bool> _bodyCheckTypesSelected = new Map();
  String _otherTypeBodyCheck;
  TextEditingController _controller;
  int _laxativesNumberInput;
  int _dietPillsNumberInput;
  int _drinksNumberInput;
  String _thoughtsInput;

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _behaviorTypes
          .forEach((behavior) => _behaviorsSelected[behavior] = false);
      _inputBehaviors = [];
      _currentSliderValueRestrict = 1.0;
      _restrictGradeInput = '';
      _currentSliderValueBinge = 1.0;
      _bingeGradeInput = '';
      _currentSliderValuePurge = 1.0;
      _purgeGradeInput = '';
      _currentSliderValueExercice = 1.0;
      _exerciseGradeInput = '';
      _bodyCheckTypeInput = [];
      _bodyCheckTypes.forEach((type) => _bodyCheckTypesSelected[type] = false);
      _otherTypeBodyCheck = '';
      _controller = TextEditingController();
      _laxativesNumberInput = -1;
      _dietPillsNumberInput = -1;
      _drinksNumberInput = -1;
      _thoughtsInput = '';
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final userId = Provider.of<Auth>(context, listen: false).userId;
    _behaviorsSelected
        .forEach((key, value) => {if (value) _inputBehaviors.add(key)});
    _bodyCheckTypesSelected.forEach((key, value) {
      if (value) {
        if (key == 'Other') {
          _bodyCheckTypeInput.add(_otherTypeBodyCheck);
        } else {
          _bodyCheckTypeInput.add(key);
        }
      }
    });
    Behavior newBehaviorLog = Behavior(
      id: '',
      userId: userId,
      behaviorsList: _inputBehaviors,
      date: DateTime.now(),
      restrictGrade: _restrictGradeInput,
      bingeGrade: _bingeGradeInput,
      purgeGrade: _purgeGradeInput,
      exerciseGrade: _exerciseGradeInput,
      bodyCheckType: _bodyCheckTypeInput,
      laxativesNumber: _laxativesNumberInput,
      dietPillsNumber: _dietPillsNumberInput,
      drinksNumber: _drinksNumberInput,
      thoughts: _thoughtsInput,
    );

    Provider.of<Behaviors>(context, listen: false)
        .addBehavior(newBehaviorLog, userId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your behaviors'),
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
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _form,
          child: ListView(children: [
            ...(_behaviorTypes
                .map((behaviorType) => _buildBehaviorTypeWidget(behaviorType))
                .toList()),
            _buildThoughtsInput(),
          ]),
        ),
      ),
    );
  }

  Widget _buildBehaviorTypeWidget(String behaviorType) {
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Column(
        children: [
          ListTile(
            title: Text(
              getBehaviorMessageAddTitle(behaviorType),
            ),
            subtitle: Text(
              getBehaviorMessageExplaining(behaviorType),
            ),
            leading: _behaviorsSelected[behaviorType]
                ? CircleAvatar(
                    radius: 30.0,
                    child: Icon(
                      Icons.check,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    backgroundColor: Colors.purple[50],
                  )
                : null,
            onTap: () {
              setState(() {
                _behaviorsSelected[behaviorType] =
                    !_behaviorsSelected[behaviorType];
              });
            },
          ),
          if (behaviorType == 'restrict' && _behaviorsSelected[behaviorType])
            _buildGradeSliderRestrict(),
          if (behaviorType == 'binge' && _behaviorsSelected[behaviorType])
            _buildGradeSliderBinge(),
          if (behaviorType == 'purge' && _behaviorsSelected[behaviorType])
            _buildGradeSliderPurge(),
          if (behaviorType == 'exercise' && _behaviorsSelected[behaviorType])
            _buildGradeSliderExercise(),
          if (behaviorType == 'bodyCheck' && _behaviorsSelected[behaviorType])
            _buildBodyCheckTypeInput(),
          if (behaviorType == 'useLaxatives' &&
              _behaviorsSelected[behaviorType])
            _buildNumberInput('useLaxatives'),
          if (behaviorType == 'useDietPills' &&
              _behaviorsSelected[behaviorType])
            _buildNumberInput('useDietPills'),
          if (behaviorType == 'drinkAlcohol' &&
              _behaviorsSelected[behaviorType])
            _buildNumberInput('drinkAlcohol'),
        ],
      ),
    );
  }

  Widget _buildNumberInput(String type) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        title: Text('How many?'),
        trailing: Container(
          width: 150,
          child: TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                hintText: 'Number',
                hintStyle: TextStyle(fontStyle: FontStyle.italic)),
            validator: (value) {
              if (int.parse(value) < 1) {
                return 'Press a valid number.';
              }
              return null;
            },
            onSaved: (value) => {
              if (type == 'useLaxatives')
                {_laxativesNumberInput = int.parse(value)}
              else if (type == 'useDietPills')
                {_dietPillsNumberInput = int.parse(value)}
              else
                {_drinksNumberInput = int.parse(value)}
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBodyCheckTypeInput() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: _bodyCheckTypes
            .map((type) => ListTile(
                  title: (type == 'Other' && _bodyCheckTypesSelected[type])
                      ? Text(_otherTypeBodyCheck)
                      : Text(type),
                  trailing: Checkbox(
                    value: _bodyCheckTypesSelected[type],
                    onChanged: (bool value) {
                      if (type == 'Other' && value) {
                        return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Body check type'),
                            content: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'How did you check your body?',
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                              ),
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  setState(() {
                                    _otherTypeBodyCheck = _controller.text;
                                    _controller.text = '';
                                    if (_otherTypeBodyCheck != '')
                                      _bodyCheckTypesSelected[type] = value;
                                  });
                                  Navigator.of(ctx).pop(true);
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        setState(() {
                          _bodyCheckTypesSelected[type] = value;
                          if (type == 'Other') {
                            _otherTypeBodyCheck = '';
                          }
                        });
                      }
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildGradeSliderRestrict() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'How strong is your urge to restrict now?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),
            subtitle: Text(_restrictGradeInput),
            contentPadding: EdgeInsets.all(0.0),
          ),
          Slider(
            value: _currentSliderValueRestrict,
            min: 1,
            max: 5,
            divisions: 4,
            label: _gradeTypes[_currentSliderValueRestrict.round() - 1],
            onChanged: (double value) {
              setState(() {
                _currentSliderValueRestrict = value;
                _restrictGradeInput =
                    _gradeTypes[_currentSliderValueRestrict.round() - 1];
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSliderBinge() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'How strong is your urge to binge now?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),
            subtitle: Text(_bingeGradeInput),
            contentPadding: EdgeInsets.all(0.0),
          ),
          Slider(
            value: _currentSliderValueBinge,
            min: 1,
            max: 5,
            divisions: 4,
            label: _gradeTypes[_currentSliderValueBinge.round() - 1],
            onChanged: (double value) {
              setState(() {
                _currentSliderValueBinge = value;
                _bingeGradeInput =
                    _gradeTypes[_currentSliderValueBinge.round() - 1];
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSliderPurge() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'How strong is your urge to purge now?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),
            subtitle: Text(_purgeGradeInput),
            contentPadding: EdgeInsets.all(0.0),
          ),
          Slider(
            value: _currentSliderValuePurge,
            min: 1,
            max: 5,
            divisions: 4,
            label: _gradeTypes[_currentSliderValuePurge.round() - 1],
            onChanged: (double value) {
              setState(() {
                _currentSliderValuePurge = value;
                _purgeGradeInput =
                    _gradeTypes[_currentSliderValuePurge.round() - 1];
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSliderExercise() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'How strong is your urge to binge now?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),
            subtitle: Text(_exerciseGradeInput),
            contentPadding: EdgeInsets.all(0.0),
          ),
          Slider(
            value: _currentSliderValueExercice,
            min: 1,
            max: 5,
            divisions: 4,
            label: _gradeTypes[_currentSliderValueExercice.round() - 1],
            onChanged: (double value) {
              setState(() {
                _currentSliderValueExercice = value;
                _exerciseGradeInput =
                    _gradeTypes[_currentSliderValueExercice.round() - 1];
              });
            },
          ),
        ],
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
}
