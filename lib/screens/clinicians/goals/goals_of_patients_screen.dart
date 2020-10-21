import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/goals.dart';
import '../../../providers/auth.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../widgets/clinicians/app_drawer_clinicians.dart';
import '../../../widgets/clinicians/goals/goals_list.dart';

class GoalsOfPatientsScreen extends StatefulWidget {
  static const routeName = '/goals-of-patients';

  @override
  _GoalsOfPatientsScreenState createState() =>
      _GoalsOfPatientsScreenState();
}

class _GoalsOfPatientsScreenState
    extends State<GoalsOfPatientsScreen>
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
    await Provider.of<Goals>(context, listen: false)
        .fetchAndSetGoalsOfPatients(patients);
  }

  @override
  Widget build(BuildContext context) {
    final clinicianId = Provider.of<Auth>(context, listen: false).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients\' Goals'),
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
                child: GoalsList(
                    selectedIndex, tabsList[selectedIndex].text),
              ),
              RefreshIndicator(
                onRefresh: () => _refreshScreen(context, clinicianId),
                child: GoalsList(
                    selectedIndex, tabsList[selectedIndex].text),
              ),
              RefreshIndicator(
                onRefresh: () => _refreshScreen(context, clinicianId),
                child: GoalsList(
                    selectedIndex, tabsList[selectedIndex].text),
              ),
            ],
          ),
    );
  }
}
