import 'package:flutter/material.dart';

import './one_patient_info_screen.dart';
import './one_patient_navigation_choices_screen.dart';


import '../../../providers/clinicians/patients_of_clinicians.dart';

class OnePatientScreen extends StatefulWidget {
  static const routeName = '/one-patient-tabs-screen';
  @override
  _OnePatientScreenState createState() => _OnePatientScreenState();
}

class _OnePatientScreenState extends State<OnePatientScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Tab> tabsList = [
    Tab(text: 'Menu'),
    Tab(text: 'Info'),
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

  PatientOfClinician patient;

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      patient = ModalRoute.of(context).settings.arguments as PatientOfClinician;
      
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.patientName),
        bottom: TabBar(
          tabs: tabsList,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          OnePatientNavigationChoicesScreen(patient),
          OnePatientInfoScreen(patient),
        ],
      ),
    );
  }
}
