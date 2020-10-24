import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/community_coping_skills.dart';
import '../../../providers/coping_skills.dart';
import '../../../providers/auth.dart';

import '../../../screens/users/add_input/add_coping_skill_screen.dart';

class CommunitySkillItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context).userId;
    final skill = Provider.of<CommunityCopingSkill>(context);
    final date = DateFormat('MMM d, y').add_jm().format(skill.date);
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(skill.description),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('${skill.likes}'),
                      IconButton(
                        color: (skill.isLiked)
                            ? Theme.of(context).primaryColor
                            : Colors.black26,
                        icon: Icon(Icons.thumb_up),
                        onPressed: () {
                          Provider.of<CommunityCopingSkill>(context,
                                  listen: false)
                              .likeToggleCommunityCopingSkill(userId);
                        },
                      ),
                    ],
                  ),
                  OutlineButton.icon(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      final entry = CopingSkill(
                          id: '',
                          name: '',
                          description: skill.description,
                          autoShowConditionsBehaviors: [],
                          autoShowConditionsFeelings: [],
                          examples: [],
                          patientId: '',
                          createdBy: '',
                          date: null);
                      Navigator.of(context).pushNamed(
                          AddCopingSkillScreen.routeName,
                          arguments: entry);
                    },
                    icon: Icon(Icons.near_me),
                    label: Text('Add to coping skill'),
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
