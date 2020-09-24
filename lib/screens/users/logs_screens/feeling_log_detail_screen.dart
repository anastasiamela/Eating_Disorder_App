import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/feelings.dart';

import '../../../models/emoji_view.dart';

class FeelingLogDetailScreen extends StatelessWidget {
  static const routeName = '/feeling-log-detail';
  @override
  Widget build(BuildContext context) {
    final feelingId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final feeling = Provider.of<Feelings>(
      context,
    ).findById(feelingId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of the feelings log'),
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
                    DateFormat.yMEd().add_jm().format(feeling.date),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Logged at: ${DateFormat.yMEd().add_jm().format(feeling.dateTimeOfLog)}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.black45),
                  ),
                ],
              ),
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
                        'Overall Feeling:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(feeling.overallFeeling),
                    Divider(),
                  ],
                ),
              ),
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
                        'Feelings:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    ...feeling.moods
                        .map((mood) => Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Row(
                                    children: [
                                      Text(getEmojiTextView(mood)),
                                      SizedBox(width: 8),
                                      Text(mood),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            ))
                        .toList()
                  ],
                ),
              ),
            ),
            if (feeling.thoughts.isNotEmpty)
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
                      Text(feeling.thoughts),
                      Divider(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
