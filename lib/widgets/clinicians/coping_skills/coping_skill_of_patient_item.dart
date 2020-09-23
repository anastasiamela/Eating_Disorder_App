import 'package:disorder_app/screens/users/add_input/add_coping_skill_screen.dart';
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
      onTap: () {
        Navigator.of(context)
            .pushNamed(AddCopingSkillScreen.routeName, arguments: skill);
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(patient.patientName),
                    Text(date),
                  ],
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
