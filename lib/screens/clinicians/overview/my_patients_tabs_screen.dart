import 'package:flutter/material.dart';

import './my_patients_screen.dart';
import '../requests/requests_from_patients_screen.dart';

class MyPatientsTabsScreen extends StatefulWidget {
   static const routeName = '/my-patients-tabs-screen';
  @override
  _MyPatientsTabsScreenState createState() => _MyPatientsTabsScreenState();
}

class _MyPatientsTabsScreenState extends State<MyPatientsTabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _pages = [
        {
          'page': MyPatientsScreen(),
          'title': 'My Patients',
        },
        {
          'page': RequestsFromPatientsScreen(),
          'title': 'Patients\' Requests',
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
            icon: Icon(Icons.people),
            title: Text('My Patients'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.queue),
            title: Text('Requests'),
          ),
        ],
      ),
    );
  }
}