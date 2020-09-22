import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/coping_skills.dart';
import '../../../providers/auth.dart';

import '../add_input/add_coping_skill_screen.dart';

import '../../../widgets/users/app_drawer.dart';
import '../../../widgets/users/coping_skills/coping_skill_item.dart';

class MyCopingSkillsScreen extends StatelessWidget {
  static const routeName = '/my-coping-skills';

  Future<void> _refreshScreen(BuildContext context, String patientId) async {
    await Provider.of<CopingSkills>(context, listen: false)
        .fetchAndSetCopingSkills(patientId);
  }

  @override
  Widget build(BuildContext context) {
    final patientId = Provider.of<Auth>(context, listen: false).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Coping Skills'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddCopingSkillScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshScreen(context, patientId),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshScreen(context, patientId),
                    child: Consumer<CopingSkills>(
                      builder: (ctx, copingSkillsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: (copingSkillsData.skills.isEmpty)
                            ? Center(
                                child: Text('There are not coping skills.'),
                              )
                            : ListView.builder(
                                itemCount: copingSkillsData.skills.length,
                                itemBuilder: (_, i) =>
                                    ChangeNotifierProvider.value(
                                        value: copingSkillsData.skills[i],
                                        child: CopingSkillItem()),
                              ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
