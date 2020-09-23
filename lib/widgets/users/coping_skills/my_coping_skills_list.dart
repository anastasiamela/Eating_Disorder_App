import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/coping_skills.dart';

import './coping_skill_item.dart';

class MyCopingSkillsList extends StatelessWidget {
  final int selectedCategoryIndex;
  final String selectedCategory;

  MyCopingSkillsList(this.selectedCategoryIndex, this.selectedCategory);
  @override
  Widget build(BuildContext context) {
    final skillsData = Provider.of<CopingSkills>(context);
    List<CopingSkill> skills = [];
    if (selectedCategoryIndex == 0) {
      skills = skillsData.skills;
    } else if (selectedCategoryIndex == 1) {
      skills = skillsData.copingSkillsByPatient;
    } else if (selectedCategoryIndex == 2) {
      skills = skillsData.copingSkillsByClinician;
    }

    return (skills.isEmpty)
        ? Center(
            child: Text('You have not coping skills.'),
          )
        : ListView.builder(
            itemCount: skills.length,
            itemBuilder: (_, i) {
              return ChangeNotifierProvider.value(
                value: skills[i],
                child: CopingSkillItem(),
              );
            },
          );
  }
}
