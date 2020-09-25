import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/connected_clinician.dart';
import '../../../providers/auth.dart';

class TheConnectedClinician extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final patientId = Provider.of<Auth>(context, listen: false).userId;
    final clinicianName =
        Provider.of<ConnectedClinician>(context).clinicianName;
    final clinicianPhoto =
        Provider.of<ConnectedClinician>(context).clinicianPhoto;
    final clinicianEmail =
        Provider.of<ConnectedClinician>(context).clinicianEmail;
    final timestamp = Provider.of<ConnectedClinician>(context).connectionDate;
    final connectionDateTime = DateTime.parse(timestamp.toDate().toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ListTile(
            title: Text(
              'You are already connected with your clinician.',
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: Card(
              shadowColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(
                        clinicianPhoto,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                        child: Text(
                          clinicianName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      subtitle: Text(
                        clinicianEmail,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      DateFormat.yMEd().add_jm().format(connectionDateTime),
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: RaisedButton(
                        onPressed: () {
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text(
                                'Do you want to delete the connection with your current clinician?',
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(true);
                                    Provider.of<ConnectedClinician>(ctx,
                                            listen: false)
                                        .deleteConnectedClinician(patientId);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        color: Colors.red[900],
                        textColor: Colors.white,
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
