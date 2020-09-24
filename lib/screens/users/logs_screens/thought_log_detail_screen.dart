import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/thoughts.dart';

import '../../comments_of_logs_screen.dart';

class ThoughtLogDetailScreen extends StatelessWidget {
  static const routeName = '/thought-log-detail';
  @override
  Widget build(BuildContext context) {
    final thoughtId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final thought = Provider.of<Thoughts>(
      context,
    ).findById(thoughtId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of the thought log'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    DateFormat.yMEd().add_jm().format(thought.date),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Logged at: ${DateFormat.yMEd().add_jm().format(thought.dateTimeOfLog)}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.black45),
                  ),
                  Card(
                    shadowColor: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              'Thoughts:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Text(thought.thought),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shadowColor: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          'Comments:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(CommentsOfLogsScreen.routeName, arguments: thought.id);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
