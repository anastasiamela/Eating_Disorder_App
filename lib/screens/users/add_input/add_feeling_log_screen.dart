import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      moodsToDisplay.forEach((element) => _moodsSelected[element] = false);
      _inputMoods = [];
      _thoughtsInput = '';
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
    _moodsSelected.forEach((key, value) => {if(value) _inputMoods.add(key)});
    Provider.of<Feelings>(context, listen: false)
        .addFeeling(_inputOverallFeeling, _inputMoods, _thoughtsInput, userId);
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
}
