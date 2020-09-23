import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/coping_skills.dart';
import '../../../providers/auth.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../widgets/clinicians/app_drawer_clinicians.dart';
import '../../../widgets/clinicians/coping_skills/coping_skills_list.dart';

import './add_coping_skill_for_patient_screen.dart';

class CopingSkillsOfPatientsScreen extends StatefulWidget {
  static const routeName = '/coping-skills-of-patients';

  @override
  _CopingSkillsOfPatientsScreenState createState() =>
      _CopingSkillsOfPatientsScreenState();
}

class _CopingSkillsOfPatientsScreenState
    extends State<CopingSkillsOfPatientsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Tab> tabsList = [
    Tab(text: 'All'),
    Tab(text: 'By You'),
    Tab(text: 'By Patient'),
  ];

  var selectedIndex = 0;

  @override
  void initState() {
    _tabController = new TabController(length: tabsList.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final clinicianId = Provider.of<Auth>(context, listen: false).userId;
      _refreshScreen(context, clinicianId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
              Navigator.of(context)
                  .pushNamed(AddCopingSkillForPatientScreen.routeName);
            },
          ),
        ],
        bottom: TabBar(
          tabs: tabsList,
          controller: _tabController,
          //isScrollable: true,
        ),
      ),
      drawer: AppDrawerClinicians(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: () => _refreshScreen(context, clinicianId),
                child: CopingSkillsList(
                    selectedIndex, tabsList[selectedIndex].text),
              ),
              RefreshIndicator(
                onRefresh: () => _refreshScreen(context, clinicianId),
                child: CopingSkillsList(
                    selectedIndex, tabsList[selectedIndex].text),
              ),
              RefreshIndicator(
                onRefresh: () => _refreshScreen(context, clinicianId),
                child: CopingSkillsList(
                    selectedIndex, tabsList[selectedIndex].text),
              ),
            ],
          ),
    );
  }
}
