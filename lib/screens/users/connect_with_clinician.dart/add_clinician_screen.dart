import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/requests.dart';

class AddClinicianScreen extends StatefulWidget {
  static const routename = '/add-clinician';
  @override
  _AddClinicianScreenState createState() => _AddClinicianScreenState();
}

class _AddClinicianScreenState extends State<AddClinicianScreen> {
  final _form = GlobalKey<FormState>();
  String _clinicianIdInput;
  String _messageInput;
  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final patientId = Provider.of<Auth>(context, listen: false).userId;
    final patientName = Provider.of<Auth>(context, listen: false).userName;
    final patientEmail = Provider.of<Auth>(context, listen: false).userEmail;
    final patientPhoto = Provider.of<Auth>(context, listen: false).userPhoto;
    final date = DateTime.now();

    Request newRequest = Request(
      clinicianId: _clinicianIdInput,
      patientId: patientId,
      patientName: patientName,
      patientEmail: patientEmail,
      patientPhoto: patientPhoto,
      messageFromPatient: _messageInput,
      date: date,
    );

    Provider.of<Requests>(context, listen: false).sendRequestToClinician(newRequest);
    Navigator.of(context).pop();
  }

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _clinicianIdInput = '';
      _messageInput = '';
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Your Clinician'),
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
                Card(
                  shadowColor: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Clinician\'s ID',
                        labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You have to enter your clinician\'s ID';
                        }
                        return null;
                      },
                      onSaved: (value) => _clinicianIdInput = value,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Card(
                  shadowColor: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Optional Message',
                        labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onSaved: (value) => _messageInput = value,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                RaisedButton(
                  onPressed: _saveForm,
                  child: Text('Send Request'),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.teal[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
