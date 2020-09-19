import 'package:disorder_app/providers/clinicians/patients_of_clinicians.dart';
import 'package:flutter/material.dart';

import './one_patient_logs_screen.dart';
import './calendar_one_patient_screen.dart';

class OnePatientLogsTabsScreen extends StatefulWidget {
  static const routeName = '/one-patient-logs-tabs-screen';
  @override
  _OnePatientLogsTabsScreenState createState() =>
      _OnePatientLogsTabsScreenState();
}

class _OnePatientLogsTabsScreenState extends State<OnePatientLogsTabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  PatientOfClinician patient;

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      patient = ModalRoute.of(context).settings.arguments as PatientOfClinician;
      _pages = [
        {
          'page': OnePatientLogsScreen(patient),
          'title': 'Logs',
        },
        {
          'page': CalendarOnePatientScreen(patient),
          'title': 'Log Calendar',
        },
      ];
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.account_box),
            title: Text('Feed'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.calendar_today),
            title: Text('Log Calendar'),
          ),
        ],
      ),
    );
  }
}
