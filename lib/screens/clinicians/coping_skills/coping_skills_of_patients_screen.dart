import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/coping_skills.dart';
import '../../../providers/auth.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../widgets/clinicians/app_drawer_clinicians.dart';
import '../../../widgets/clinicians/coping_skills/coping_skill_of_patient_item.dart';

class CopingSkillsOfPatientsScreen extends StatelessWidget {
  static const routeName = '/coping-skills-of-patients';

  Future<void> _refreshScreen(BuildContext context, String clinicianId) async {
    
    await Provider.of<PatientsOfClinician>(context, listen: false)
        .fetchAndSetPatients(clinicianId);
    List<String> patients =
        Provider.of<PatientsOfClinician>(context, listen: false)
            .getPatientsIds();
    await Provider.of<CopingSkills>(context, listen: false)
        .fetchAndSetCopingSkillsOfPatients(patients);
  }

  @override
  Widget build(BuildContext context) {
    final clinicianId = Provider.of<Auth>(context, listen: false).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients\' Coping Skills'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //Navigator.of(context).pushNamed(AddCopingSkillScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawerClinicians(),
      body: FutureBuilder(
        future: _refreshScreen(context, clinicianId),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshScreen(context, clinicianId),
                child: Consumer<CopingSkills>(
                  builder: (ctx, copingSkillsData, _) => Padding(
                    padding: EdgeInsets.all(8),
                    child: (copingSkillsData.skills.isEmpty)
                        ? Center(
                            child:
                                Text('Your patients have not coping skills.'),
                          )
                        : ListView.builder(
                            itemCount: copingSkillsData.skills.length,
                            itemBuilder: (_, i) {
                              print(
                                  '--------------${copingSkillsData.skills[i].name}');
                              return ChangeNotifierProvider.value(
                                value: copingSkillsData.skills[i],
                                child: CopingSkillOfPatientItem(),
                              );
                            }),
                  ),
                ),
              ),
      ),
    );
  }
}
