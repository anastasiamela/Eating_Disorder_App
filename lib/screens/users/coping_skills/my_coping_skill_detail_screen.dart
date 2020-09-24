import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/coping_skills.dart';

import '../../../models/auto_show_copping_skill_message.dart';

class MyCopingSkillDetailScreen extends StatelessWidget {
  static const routeName = '/my-coping-skill-detail';
  @override
  Widget build(BuildContext context) {
    final skillId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final skill = Provider.of<CopingSkills>(
      context,
    ).findById(skillId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of the feelings log'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Created at: ${DateFormat.yMEd().add_jm().format(skill.date)}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.black45),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Center(
                child: (skill.patientId == skill.createdBy)
                    ? Text(
                        'Created by you.',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            color: Colors.black45),
                      )
                    : Text(
                        'Created by your clinician.',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            color: Colors.black45),
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
                        'Name:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(skill.name),
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
                        'Description:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(skill.description),
                    Divider(),
                  ],
                ),
              ),
            ),
            if (skill.examples.isNotEmpty)
              Card(
                shadowColor: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'Examples:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      ...skill.examples
                          .map((mood) => Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.navigate_next),
                                      Text(mood),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ))
                          .toList()
                    ],
                  ),
                ),
              ),
            if (skill.autoShowConditionsBehaviors.isNotEmpty ||
                skill.autoShowConditionsFeelings.isNotEmpty)
              Card(
                shadowColor: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'Auto show conditions:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      ...skill.autoShowConditionsBehaviors
                          .map((condition) => Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.navigate_next),
                                      Text(getTitle(condition)),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ))
                          .toList(),
                      ...skill.autoShowConditionsFeelings
                          .map((condition) => Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.navigate_next),
                                      Text(getTitle(condition)),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ))
                          .toList()
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
