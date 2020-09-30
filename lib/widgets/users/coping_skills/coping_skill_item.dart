import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/coping_skills.dart';

import '../../../screens/users/coping_skills/my_coping_skill_detail_screen.dart';
import '../../../screens/users/add_input/add_coping_skill_screen.dart';

class CopingSkillItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final skill = Provider.of<CopingSkill>(context);
    final date = DateFormat.yMd().add_jm().format(skill.date);
    final autoConditionsLength = skill.autoShowConditionsFeelings.length +
        skill.autoShowConditionsBehaviors.length;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          MyCopingSkillDetailScreen.routeName,
          arguments: skill.id,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shadowColor: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  skill.name,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: (skill.patientId == skill.createdBy)
                    ? Wrap(
                        children: [
                          IconButton(
                            splashColor: Colors.transparent,
                            icon: Icon(
                              Icons.edit,
                              size: 28,
                              color: (skill.patientId == skill.createdBy)
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  AddCopingSkillScreen.routeName,
                                  arguments: skill);
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            splashColor: Colors.transparent,
                            icon: Icon(
                              Icons.delete,
                              size: 28,
                              color: (skill.patientId == skill.createdBy)
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                            ),
                            onPressed: () {
                              Provider.of<CopingSkills>(context, listen: false)
                                  .deleteCopingSkill(skill.id, skill.patientId);
                            },
                          ),
                        ],
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  skill.description,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              if (skill.examples.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Examples:  ',
                      ),
                      Expanded(
                        child: Column(
                          children: skill.examples
                              .map((example) => Row(
                                    children: [
                                      Text('- '),
                                      Expanded(
                                        child: Text(example),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    '$autoConditionsLength condition(s) chosen for auto showing.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: (skill.patientId == skill.createdBy)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            date,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            '  Created by you.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            date,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            '  Created by your clinician.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
