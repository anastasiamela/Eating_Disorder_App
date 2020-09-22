import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/coping_skills.dart';

class CopingSkillItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final skill = Provider.of<CopingSkill>(context);
    final autoConditionsLength = skill.autoShowConditionsFeelings.length +
        skill.autoShowConditionsBehaviors.length;
    return Card(
      shadowColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                skill.name,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                skill.description,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            // ListTile(
            //   title: Text(skill.name),
            //   subtitle: Text(skill.description),
            // ),
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
          ],
        ),
      ),
    );
  }
}
