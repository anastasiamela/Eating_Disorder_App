import 'package:flutter/material.dart';

import './calendar_logs_screen.dart';
import './general_logs_overview_screen.dart';
import '../../../widgets/users/app_drawer.dart';

class GeneralLogsTabsScreen extends StatefulWidget {
  static const routeName = '/generalLogs-tabsbottom-screen';
  @override
  _GeneralTabsScreenState createState() => _GeneralTabsScreenState();
}

class _GeneralTabsScreenState extends State<GeneralLogsTabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;


  @override
  void initState() {
    _pages = [
      {
        'page': GeneralLogsOverviewScreen(),
        'title': 'My Meal Logs',
      },
      {
        'page': CalendarLogsScreen(),
        'title': 'Log Calendar',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_pages[_selectedPageIndex]['title']),
      // ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).accentColor,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.account_box),
            title: Text('My feed'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.calendar_today),
            title: Text('Log Calendar'),
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}