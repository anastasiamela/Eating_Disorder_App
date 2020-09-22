import 'package:disorder_app/providers/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HasSentRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final request = Provider.of<Request>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Card(
            shadowColor: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Clinician\'s ID'),
                    subtitle: Text(request.clinicianId),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Message'),
                    subtitle: Text(request.messageFromPatient),
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              Provider.of<Requests>(context, listen: false)
                  .deleteRequestFromPatient(request.patientId);
            },
            child: Text(
              'Delete Request',
              style: TextStyle(
                color: Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
