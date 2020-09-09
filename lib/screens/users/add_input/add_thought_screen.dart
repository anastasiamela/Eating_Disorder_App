import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/thoughts.dart';
import '../../../providers/auth.dart';

class AddThoughtScreen extends StatefulWidget {
  static const routeName = '/add-thought';

  @override
  _AddThoughtScreenState createState() => _AddThoughtScreenState();
}

class _AddThoughtScreenState extends State<AddThoughtScreen> {
  final _form = GlobalKey<FormState>();
  String _inputThought;

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final userId = Provider.of<Auth>(context, listen: false).userId;
    Provider.of<Thoughts>(context, listen: false).addThought(_inputThought, userId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your thoughts'),
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
          child: Column(
            children: <Widget>[
              Text('Which thoughts or concers are you facing?'),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Container(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          hintText: 'Your thoughts',
                          hintStyle: TextStyle(fontStyle: FontStyle.italic)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please write your thoughts.';
                        }
                        if (value.length < 5) {
                          return 'Should be at least 5 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) => _inputThought = value,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
    );
  }
}
