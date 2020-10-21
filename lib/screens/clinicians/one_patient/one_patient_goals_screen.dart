import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/goals.dart';
import '../../../providers/auth.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../widgets/clinicians/goals/goals_list.dart';

class OnePatientGoalsScreen extends StatefulWidget {
  static const routeName = '/one-patient-goals';

  @override
  _OnePatientGoalsScreenState createState() => _OnePatientGoalsScreenState();
}

class _OnePatientGoalsScreenState extends State<OnePatientGoalsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Tab> tabsList = [
    Tab(text: 'Active'),
    Tab(text: 'Delayed'),
    Tab(text: 'Completed'),
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

  PatientOfClinician patient;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      patient = ModalRoute.of(context).settings.arguments as PatientOfClinician;
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
    await Provider.of<Goals>(context, listen: false)
        .fetchAndSetGoals(patient.patientId);
  }

  @override
  Widget build(BuildContext context) {
    final clinicianId = Provider.of<Auth>(context, listen: false).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('${patient.patientName}\'s Goals'),
        bottom: TabBar(
          tabs: tabsList,
          controller: _tabController,
          //isScrollable: true,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  onRefresh: () => _refreshScreen(context, clinicianId),
                  child: GoalsList(selectedIndex, tabsList[selectedIndex].text),
                ),
                RefreshIndicator(
                  onRefresh: () => _refreshScreen(context, clinicianId),
                  child: GoalsList(selectedIndex, tabsList[selectedIndex].text),
                ),
                RefreshIndicator(
                  onRefresh: () => _refreshScreen(context, clinicianId),
                  child: GoalsList(selectedIndex, tabsList[selectedIndex].text),
                ),
              ],
            ),
    );
  }
}
