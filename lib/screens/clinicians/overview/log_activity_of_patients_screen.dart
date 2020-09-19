import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/clinicians/patients_of_clinicians.dart';
import '../../../providers/meal_logs.dart';
import '../../../providers/thoughts.dart';
import '../../../providers/feelings.dart';
import '../../../providers/auth.dart';
import '../../../providers/behaviors.dart';

import '../../../widgets/clinicians/app_drawer_clinicians.dart';
import '../../../widgets/clinicians/overview/log_activity_list.dart';

class LogActivityOfPatientsScreen extends StatefulWidget {
  static const routeName = '/log-activity-of-patients';
  @override
  _LogActivityOfPatientsScreenState createState() =>
      _LogActivityOfPatientsScreenState();
}

class _LogActivityOfPatientsScreenState
    extends State<LogActivityOfPatientsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Tab> tabsList = [
    Tab(text: 'All'),
    Tab(text: 'Meal Logs'),
    Tab(text: 'Skipped meals'),
    Tab(text: 'Back logs'),
    //Tab(text: 'Goals'),
    Tab(text: 'Thoughts'),
    Tab(text: 'Feelings'),
    Tab(text: 'Behaviors'),
  ];

  var selectedIndex = 0;
  var _isInit = true;
  var _isLoading = false;

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

  Future<void> _refreshScreen(BuildContext context) async {
    print('aaaaaaaaaaa');
    setState(() {
      _isLoading = true;
    });
    final clinicianId = Provider.of<Auth>(context, listen: false).userId;
    await Provider.of<PatientsOfClinician>(context, listen: false)
        .fetchAndSetPatients(clinicianId);
    List<String> patients =
        Provider.of<PatientsOfClinician>(context, listen: false)
            .getPatientsIds();
    await Provider.of<Thoughts>(context, listen: false)
        .fetchAndSetThoughtsOfPatients(patients);
    await Provider.of<Feelings>(context, listen: false)
        .fetchAndSetFeelingsOfPatients(patients);
    await Provider.of<Behaviors>(context, listen: false)
        .fetchAndSetBehaviorsOfPatients(patients);
    await Provider.of<MealLogs>(context, listen: false)
        .fetchAndSetMealLogsOfPatients(patients);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final clinicianId = Provider.of<Auth>(context, listen: false).userId;
      Provider.of<PatientsOfClinician>(context, listen: false)
          .fetchAndSetPatients(clinicianId)
          .then((_) {
        List<String> patients =
            Provider.of<PatientsOfClinician>(context, listen: false)
                .getPatientsIds();
        print('then');
        print(patients);
        Provider.of<Thoughts>(context, listen: false)
            .fetchAndSetThoughtsOfPatients(patients);
        Provider.of<Feelings>(context, listen: false)
            .fetchAndSetFeelingsOfPatients(patients);
        Provider.of<Behaviors>(context, listen: false)
            .fetchAndSetBehaviorsOfPatients(patients);
        Provider.of<MealLogs>(context, listen: false)
            .fetchAndSetMealLogsOfPatients(patients)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (selectedIndex == 0)
            ? Text('${tabsList[selectedIndex].text} logs')
            : Text('${tabsList[selectedIndex].text}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _refreshScreen(context),
          ),
        ],
        bottom: TabBar(
          tabs: tabsList,
          controller: _tabController,
          isScrollable: true,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: <Widget>[
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, true),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, true),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, true),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, true),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, true),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, true),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, true),
              ],
            ),
      drawer: AppDrawerClinicians(),
    );
  }
}
