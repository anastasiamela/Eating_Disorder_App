import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/settings_for_logs.dart';
import '../../../providers/auth.dart';

import '../../../models/behaviors_messages.dart';
import '../../../models/emoji_view.dart';

class SettingsForLogsScreen extends StatefulWidget {
  static const routeName = '/settings-for-logs';
  @override
  _SettingsForLogsScreenState createState() => _SettingsForLogsScreenState();
}

List<String> _behaviorTypesGeneral = [
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
  'bodyAvoid',
  'bodyCheck',
  'exercise',
];

List<String> _feelingTypesGeneral = [
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

class _SettingsForLogsScreenState extends State<SettingsForLogsScreen> {
  var _isInit = true;
  var _isLoading = false;

  List<String> _inputBehaviors;
  Map<String, bool> _behaviorsSelected = new Map();
  List<String> _behaviorsInitiallySelected = [];

  List<String> _inputFeelings;
  Map<String, bool> _feelingsSelected = new Map();
  List<String> _feelingsInitiallySelected = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _initializeSettings();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _initializeSettings() async {
    setState(() {
      _isLoading = true;
    });
    final userId = Provider.of<Auth>(context, listen: false).userId;
    await Provider.of<SettingsForLogs>(context)
        .fetchAndSetSettingsForLogs(userId);

    _behaviorTypesGeneral
        .forEach((behavior) => _behaviorsSelected[behavior] = false);
    _feelingTypesGeneral
        .forEach((feeling) => _feelingsSelected[feeling] = false);

    _behaviorsInitiallySelected =
        Provider.of<SettingsForLogs>(context, listen: false).behaviorTypesList;
    _behaviorsInitiallySelected
        .forEach((behavior) => _behaviorsSelected[behavior] = true);
    _feelingsInitiallySelected =
        Provider.of<SettingsForLogs>(context, listen: false).feelingTypesList;
    _feelingsInitiallySelected
        .forEach((feeling) => _feelingsSelected[feeling] = true);

    _inputBehaviors = [];
    _inputFeelings = [];
    setState(() {
      _isLoading = false;
    });
  }

  void _save() {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    _behaviorsSelected
        .forEach((key, value) => {if (value) _inputBehaviors.add(key)});
    _feelingsSelected
        .forEach((key, value) => {if (value) _inputFeelings.add(key)});
    Provider.of<SettingsForLogs>(context, listen: false)
        .setSettingsForLogs(_inputBehaviors, _inputFeelings, userId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings for log questions'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
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
                          fontSize: 20.0,
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
                  Column(
                    children: _behaviorTypesGeneral
                        .map((behavior) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    child: Text(
                                      getBehaviorTitleForSettings(behavior),
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              getBehaviorTitleForSettings(
                                                  behavior),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            content: Text(
                                                getBehaviorLongExplaining(
                                                    behavior)),
                                            actions: [
                                              FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text('OK'),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  Checkbox(
                                    value: _behaviorsSelected[behavior],
                                    onChanged: (value) {
                                      setState(() {
                                        _behaviorsSelected[behavior] = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
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
                        ' Feelings ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20.0,
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
                  Column(
                    children: _feelingTypesGeneral
                        .map((feeling) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getEmojiTextView(feeling),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      feeling,
                                    ),
                                  ),
                                  Checkbox(
                                    value: _feelingsSelected[feeling],
                                    onChanged: (value) {
                                      setState(() {
                                        _feelingsSelected[feeling] = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
