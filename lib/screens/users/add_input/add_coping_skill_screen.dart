import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/coping_skills.dart';
import '../../../providers/auth.dart';

import '../../../models/auto_show_copping_skill_message.dart';

class AddCopingSkillScreen extends StatefulWidget {
  static const routeName = '/add-coping-skill';
  @override
  _AddCopingSkillScreenState createState() => _AddCopingSkillScreenState();
}

class _AddCopingSkillScreenState extends State<AddCopingSkillScreen> {
  final _form = GlobalKey<FormState>();
  String _inputName;
  String _inputDescription;
  List<String> _inputFeelings;
  Map<String, bool> _feelingsSelected = new Map();
  List<String> _inputBehaviors;
  Map<String, bool> _behaviorsSelected = new Map();

  List<String> _behaviors = [
    'restrict',
    'binge',
    'purge',
    'exerciseGrade',
  ];

  List<String> _feelings = [
    'OverallFeeling',
    'Anxious',
    'Guilty',
    'Angry',
    'Shame',
    'Sad',
    'Intrusive Food Thoughts',
  ];

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _inputName = '';
      _inputDescription = '';
      _feelings.forEach((feeling) => _feelingsSelected[feeling] = false);
      _inputFeelings = [];
      _behaviors.forEach((behavior) => _behaviorsSelected[behavior] = false);
      _inputBehaviors = [];
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
    final patientId = Provider.of<Auth>(context, listen: false).userId;
    _behaviorsSelected
        .forEach((key, value) => {if (value) _inputBehaviors.add(key)});
    _feelingsSelected
        .forEach((key, value) => {if (value) _inputFeelings.add(key)});
    final date = DateTime.now();

    CopingSkill input = CopingSkill(
      id: '',
      name: _inputName,
      description: _inputDescription,
      autoShowConditionsBehaviors: _inputBehaviors,
      autoShowConditionsFeelings: _inputFeelings,
      patientId: patientId,
      createdBy: patientId,
      date: date,
    );

    Provider.of<CopingSkills>(context, listen: false).addCopingSkill(input);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add coping skill'),
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
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              _buildNameInput(),
              _buildDescriptionInput(),
              _buildAutoShowConditions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAutoShowConditions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'When should this coping skill automatically be shown?',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  ' Behaviors ',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            ...(_behaviors
                .map((behavior) => _builOneConditionBehavior(behavior))
                .toList()),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  ' Feelings ',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            ...(_feelings
                .map((feeling) => _builOneConditionFeeling(feeling))
                .toList()),
          ],
        ),
      ),
    );
  }

  Widget _builOneConditionFeeling(String condition) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              getTitle(condition),
            ),
          ),
          Checkbox(
            value: _feelingsSelected[condition],
            onChanged: (value) {
              setState(() {
                _feelingsSelected[condition] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _builOneConditionBehavior(String condition) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              getTitle(condition),
            ),
          ),
          Checkbox(
            value: _behaviorsSelected[condition],
            onChanged: (value) {
              setState(() {
                _behaviorsSelected[condition] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(fontStyle: FontStyle.italic)),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a name.';
            }
            return null;
          },
          onSaved: (value) => _inputName = value,
        ),
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(fontStyle: FontStyle.italic)),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a description.';
            }
            return null;
          },
          onChanged: (value) => _inputDescription = value,
        ),
      ),
    );
  }
}
