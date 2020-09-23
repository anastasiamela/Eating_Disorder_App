import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/coping_skills.dart';
import '../../../providers/auth.dart';

import '../add_input/add_coping_skill_screen.dart';

import '../../../widgets/users/app_drawer.dart';
import '../../../widgets/users/coping_skills/my_coping_skills_list.dart';

class MyCopingSkillsScreen extends StatefulWidget {
  static const routeName = '/my-coping-skills';

  @override
  _MyCopingSkillsScreenState createState() => _MyCopingSkillsScreenState();
}

class _MyCopingSkillsScreenState extends State<MyCopingSkillsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Tab> tabsList = [
    Tab(text: 'All'),
    Tab(text: 'By You'),
    Tab(text: 'By Clinician'),
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
      final patientId = Provider.of<Auth>(context, listen: false).userId;
      _refreshScreen(context, patientId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshScreen(BuildContext context, String patientId) async {
    await Provider.of<CopingSkills>(context, listen: false)
        .fetchAndSetCopingSkills(patientId);
  }

  @override
  Widget build(BuildContext context) {
    final patientId = Provider.of<Auth>(context, listen: false).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Coping Skills'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddCopingSkillScreen.routeName);
            },
          ),
        ],
        bottom: TabBar(
          tabs: tabsList,
          controller: _tabController,
          //isScrollable: true,
        ),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: () => _refreshScreen(context, patientId),
                child: MyCopingSkillsList(
                    selectedIndex, tabsList[selectedIndex].text),
              ),
              RefreshIndicator(
                onRefresh: () => _refreshScreen(context, patientId),
                child: MyCopingSkillsList(
                    selectedIndex, tabsList[selectedIndex].text),
              ),
              RefreshIndicator(
                onRefresh: () => _refreshScreen(context, patientId),
                child: MyCopingSkillsList(
                    selectedIndex, tabsList[selectedIndex].text),
              ),
            ],
          ),
    );
  }
}
