import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      _bodyCheckTypes
          .forEach((type) => _bodyCheckTypesSelected[type] = false);
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
    _behaviorsSelected
        .forEach((key, value) => {if (value) _inputBehaviors.add(key)});
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
          child: ListView(
            children: _behaviorTypes
                .map((behaviorType) => _buildBehaviorTypeWidget(behaviorType))
                .toList(),
          ),
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
        ],
      ),
    );
  }

  Widget _buildBodyCheckTypeInput() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: _bodyCheckTypes
            .map((type) => ListTile(
                  title: Text(type),
                  trailing: Checkbox(
                    value: _bodyCheckTypesSelected[type],
                    onChanged: (bool value) {
                      setState(() {
                        _bodyCheckTypesSelected[type] = value;
                      });
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
}
