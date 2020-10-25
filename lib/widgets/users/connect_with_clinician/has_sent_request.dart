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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 10),
            child: Text(
              'You have sent a request to clinician',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Card(
            shadowColor: Theme.of(context).primaryColor,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Clinician\'s ID:',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(request.clinicianId),
                ),
                ListTile(
                  title: Text(
                    'Message:',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(request.messageFromPatient),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: FlatButton.icon(
              onPressed: () {
                Provider.of<Requests>(context, listen: false)
                    .deleteRequestFromPatient(request.patientId);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red[700],
                size: 26,
              ),
              label: Text(
                'Delete Request',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
