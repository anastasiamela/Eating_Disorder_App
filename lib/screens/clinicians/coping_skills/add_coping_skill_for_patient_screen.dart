import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/coping_skills.dart';
import '../../../providers/auth.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../models/auto_show_copping_skill_message.dart';

class AddCopingSkillForPatientScreen extends StatefulWidget {
  static const routeName = '/add-coping-skill-for-patient';

  @override
  _AddCopingSkillForPatientScreenState createState() =>
      _AddCopingSkillForPatientScreenState();
}

class _AddCopingSkillForPatientScreenState
    extends State<AddCopingSkillForPatientScreen> {
  final _form = GlobalKey<FormState>();
  String _inputName;
  String _inputDescription;
  List<String> _inputFeelings;
  Map<String, bool> _feelingsSelected = new Map();
  List<String> _feelingsInitiallySelected = [];
  List<String> _inputBehaviors;
  Map<String, bool> _behaviorsSelected = new Map();
  List<String> _behaviorsInitiallySelected = [];
  List<String> _examples;
  String _inputPatientId;

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

  List<PatientOfClinician> _myPatients = [];

  var _isInit = true;
  var _isEdit = false;
  var _isLoading = true;
  CopingSkill entry;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final clinicianId = Provider.of<Auth>(context, listen: false).userId;
      Provider.of<PatientsOfClinician>(context, listen: false)
          .fetchAndSetPatients(clinicianId)
          .then((value) {
        _myPatients =
            Provider.of<PatientsOfClinician>(context, listen: false).patients;
        setState(() {
          _isLoading = false;
        });
      });
      entry = ModalRoute.of(context).settings.arguments as CopingSkill;
      _feelings.forEach((feeling) => _feelingsSelected[feeling] = false);
      _behaviors.forEach((behavior) => _behaviorsSelected[behavior] = false);
      if (entry == null) {
        _inputName = '';
        _inputDescription = '';
        _inputFeelings = [];
        _inputBehaviors = [];
        _examples = [];
        _inputPatientId = '';
        _isEdit = false;
      } else {
        _inputName = entry.name;
        _inputDescription = entry.description;
        _feelingsInitiallySelected = entry.autoShowConditionsFeelings;
        _behaviorsInitiallySelected = entry.autoShowConditionsBehaviors;
        _behaviorsInitiallySelected
            .forEach((behavior) => _behaviorsSelected[behavior] = true);
        _feelingsInitiallySelected
            .forEach((feeling) => _feelingsSelected[feeling] = true);
        _inputFeelings = [];
        _inputBehaviors = [];
        _examples = entry.examples;
        _isEdit = true;
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
    if (_inputPatientId.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
                'You have to select one patient.'),
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
    final clinicianId = Provider.of<Auth>(context, listen: false).userId;
    _behaviorsSelected
        .forEach((key, value) => {if (value) _inputBehaviors.add(key)});
    _feelingsSelected
        .forEach((key, value) => {if (value) _inputFeelings.add(key)});
    final date = DateTime.now();

    if (!_isEdit) {
      CopingSkill input = CopingSkill(
        id: '',
        name: _inputName,
        description: _inputDescription,
        autoShowConditionsBehaviors: _inputBehaviors,
        autoShowConditionsFeelings: _inputFeelings,
        examples: _examples,
        patientId: _inputPatientId,
        createdBy: clinicianId,
        date: date,
      );
      Provider.of<CopingSkills>(context, listen: false).addCopingSkill(input);
    } else {
      CopingSkill input = CopingSkill(
        id: entry.id,
        name: _inputName,
        description: _inputDescription,
        autoShowConditionsBehaviors: _inputBehaviors,
        autoShowConditionsFeelings: _inputFeelings,
        examples: _examples,
        patientId: entry.patientId,
        createdBy: entry.createdBy,
        date: date,
      );
      Provider.of<CopingSkills>(context, listen: false)
          .updateCopingSkill(entry.id, input);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    //final clinicianId = Provider.of<Auth>(context, listen: false).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add coping skill for patient'),
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
                      'Do you want to remove the coping skill?',
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
                if (!response) {
                  Provider.of<CopingSkills>(context, listen: false)
                      .deleteCopingSkill(entry.id, 'patientId');
                  Navigator.of(context).pop();
                }
              },
            ),
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
              Card(
                shadowColor: Theme.of(context).primaryColor,
                child: Column(
                  children: [
                    ..._getExamples(),
                    ListTile(
                      title: Row(
                        children: [
                          const Icon(Icons.add_circle),
                          const SizedBox(
                            width: 8.0,
                          ),
                          (_examples.isEmpty)
                              ? Text('Add an example.')
                              : Text('Add another example.'),
                        ],
                      ),
                      onTap: _add,
                    ),
                  ],
                ),
              ),
              _buildPatientIdInput(),
              _buildAutoShowConditions(),
            ],
          ),
        ),
      ),
    );
  }

  void _add() {
    setState(() {
      _examples.add('');
    });
  }

  void _delete(int index) {
    setState(() {
      _examples.removeAt(index);
    });
  }

  List<Widget> _getExamples() {
    List<Widget> examplesTextFormFieldsList = [];
    for (int i = 0; i < _examples.length; i++) {
      examplesTextFormFieldsList.add(_buildExampleInput(i));
    }
    return examplesTextFormFieldsList;
  }

  Widget _buildExampleInput(int index) {
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
      child: ListTile(
        title: TextFormField(
          initialValue: _examples[index],
          decoration: InputDecoration(
            hintText: 'Add an example',
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
          onChanged: (value) => {_examples[index] = value},
        ),
        trailing: InkWell(
          child: Icon(Icons.delete),
          onTap: () => _delete(index),
        ),
      ),
    );
  }

  Widget _buildPatientIdInput() {
    return Card(
      child: Container(
        height: 300,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'For which patient?',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: _myPatients
                          .map((patient) => Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage: NetworkImage(
                                        patient.patientPhoto,
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    title: Text(patient.patientName),
                                    subtitle: Text(patient.patientEmail),
                                    trailing: Checkbox(
                                      value: _inputPatientId == patient.patientId,
                                      onChanged: (value) {
                                        if (value) {
                                          setState(() {
                                            _inputPatientId = patient.patientId;
                                          });
                                        } else {
                                          setState(() {
                                            _inputPatientId = '';
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ],
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
      child: ListTile(
        title: TextFormField(
          initialValue: _inputName,
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
      child: ListTile(
        title: TextFormField(
          initialValue: _inputDescription,
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
