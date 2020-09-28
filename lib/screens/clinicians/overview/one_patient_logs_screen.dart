import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/meal_logs.dart';
import '../../../providers/thoughts.dart';
import '../../../providers/feelings.dart';
import '../../../providers/behaviors.dart';
import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../widgets/clinicians/overview/log_activity_list.dart';

class OnePatientLogsScreen extends StatefulWidget {
  static const routeName = '/one-patient-logs';
  final PatientOfClinician patient;

  OnePatientLogsScreen(this.patient);

  @override
  _OnePatientLogsScreenState createState() => _OnePatientLogsScreenState();
}

class _OnePatientLogsScreenState extends State<OnePatientLogsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Tab> tabsList = [
    Tab(text: 'All'),
    Tab(text: 'Meal Logs'),
    Tab(text: 'Skipped meals'),
    Tab(text: 'Back logs'),
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
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Thoughts>(context, listen: false)
        .fetchAndSetThoughts(widget.patient.patientId);
    await Provider.of<Feelings>(context, listen: false)
        .fetchAndSetFeelings(widget.patient.patientId);
    await Provider.of<Behaviors>(context, listen: false)
        .fetchAndSetBehaviors(widget.patient.patientId);
    await Provider.of<MealLogs>(context, listen: false)
        .fetchAndSetMealLogs(widget.patient.patientId);
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

      print('then');
      print(widget.patient.patientId);
      Provider.of<Thoughts>(context, listen: false)
          .fetchAndSetThoughts(widget.patient.patientId);
      Provider.of<Feelings>(context, listen: false)
          .fetchAndSetFeelings(widget.patient.patientId);
      Provider.of<Behaviors>(context, listen: false)
          .fetchAndSetBehaviors(widget.patient.patientId);
      Provider.of<MealLogs>(context, listen: false)
          .fetchAndSetMealLogs(widget.patient.patientId)
          .then((_) {
        setState(() {
          _isLoading = false;
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
            ? Text('${widget.patient.patientName} \'s logs')
            : Text('${widget.patient.patientName} \'s ${tabsList[selectedIndex].text}'),
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
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, false),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, false),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, false),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, false),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, false),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, false),
                LogActivityList(selectedIndex, tabsList[selectedIndex].text, false),
              ],
            ),
    );
  }
}
