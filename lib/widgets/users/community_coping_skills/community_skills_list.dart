import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/community_coping_skills.dart';

import './community_skill_item.dart';

class CommunitySkillsList extends StatelessWidget {
  final int selectedCategoryIndex;
  final String selectedCategory;

  CommunitySkillsList(this.selectedCategoryIndex, this.selectedCategory);

  @override
  Widget build(BuildContext context) {
    final skillsData = Provider.of<CommunityCopingSkills>(context);
    List<CommunityCopingSkill> skills = [];
    if (selectedCategoryIndex == 0) {
      skills = skillsData.skills;
    } else if (selectedCategoryIndex == 1) {
      skills = skillsData.skillsSortedByLikes;
    }
    return (skills.isEmpty)
        ? Center(
            child: Text('There are not community coping skills.'),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: skills.length,
              itemBuilder: (_, i) {
                return ChangeNotifierProvider.value(
                  value: skills[i],
                  child: CommunitySkillItem(),
                );
              },
            ),
          );
  }
}
