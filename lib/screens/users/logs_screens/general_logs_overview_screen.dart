import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/meal_logs.dart';
import '../../../providers/thoughts.dart';
import '../../../providers/feelings.dart';
import '../../../providers/auth.dart';
import '../../../providers/logging_goals.dart';
import '../../../providers/behaviors.dart';

import '../../../widgets/users/app_drawer.dart';
import '../../../widgets/users/overview/general_list.dart';
import '../../../widgets/users/overview/logging_goals_overview.dart';
import '../add_input/add_meal_log_screen.dart';
import '../add_input/add_thought_screen.dart';

import '../settings_users/settings_logging_goals.dart';

class GeneralLogsOverviewScreen extends StatefulWidget {
  static const routeName = '/generalLogs-overview';
  @override
  _GeneralLogsOverviewScreenState createState() =>
      _GeneralLogsOverviewScreenState();
}

class _GeneralLogsOverviewScreenState extends State<GeneralLogsOverviewScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Tab> tabsList = [
    Tab(text: 'All'),
    Tab(text: 'Favorite'),
    Tab(text: 'Skipped meals'),
    Tab(text: 'Back logs'),
    Tab(text: 'Goals'),
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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final userId = Provider.of<Auth>(context, listen: false).userId;
      Provider.of<LoggingGoals>(context)
          .fetchAndSetLoggingGoalsSettings(userId);
      Provider.of<Thoughts>(context).fetchAndSetThoughts(userId);
      Provider.of<Feelings>(context).fetchAndSetFeelings(userId);
      Provider.of<Behaviors>(context).fetchAndSetBehaviors(userId);
      Provider.of<MealLogs>(context).fetchAndSetMealLogs(userId).then((_) {
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
        title: (selectedIndex < 2)
            ? Text('${tabsList[selectedIndex].text} logs')
            : Text('${tabsList[selectedIndex].text}'),
        actions: <Widget>[
          (selectedIndex != 4)
              ? IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    return showDialog(
                      context: context,
                      builder: (ctx) => SimpleDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.all(8),
                        titlePadding: EdgeInsets.all(8),
                        title: const Text(
                          'Select to add:',
                          textAlign: TextAlign.center,
                        ),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: const Text(
                              'Meal log',
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed(AddMealLogScreen.routeName);
                            },
                          ),
                          SimpleDialogOption(
                            child: const Text(
                              'Thought',
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed(AddThoughtScreen.routeName);
                            },
                          )
                        ],
                      ),
                    );
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(SettingsLoggingGoals.routeName);
                  },
                ),
        ],
        bottom: TabBar(
          tabs: tabsList,
          controller: _tabController,
          isScrollable: true,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GeneralList(selectedIndex, tabsList[selectedIndex].text),
          GeneralList(selectedIndex, tabsList[selectedIndex].text),
          GeneralList(selectedIndex, tabsList[selectedIndex].text),
          GeneralList(selectedIndex, tabsList[selectedIndex].text),
          LoggingGoalsOverview(),
          GeneralList(selectedIndex, tabsList[selectedIndex].text),
          GeneralList(selectedIndex, tabsList[selectedIndex].text),
          GeneralList(selectedIndex, tabsList[selectedIndex].text),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
