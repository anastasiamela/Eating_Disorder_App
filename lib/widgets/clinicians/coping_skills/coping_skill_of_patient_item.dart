import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/coping_skills.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';
import 'package:intl/intl.dart';

class CopingSkillOfPatientItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final skill = Provider.of<CopingSkill>(context);
    final date = DateFormat.yMd().add_jm().format(skill.date);
    final autoConditionsLength = skill.autoShowConditionsFeelings.length +
        skill.autoShowConditionsBehaviors.length;
    PatientOfClinician patient = Provider.of<PatientsOfClinician>(context)
        .findPatientById(skill.patientId);
    return GestureDetector(
      //behavior: HitTestBehavior.translucent,
      onTap: () {
        print('jjjjjjjjjjjjjjjjjj');
      },
      child: Card(
        shadowColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                    patient.patientPhoto,
                  ),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(patient.patientName),
                subtitle: Text(patient.patientEmail),
              ),
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
                            '  Created by patient.',
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
                            '  Created by you.',
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
