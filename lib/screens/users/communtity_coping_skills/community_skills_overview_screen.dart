import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/community_coping_skills.dart';
import '../../../providers/auth.dart';

import '../../../widgets/users/app_drawer.dart';
import '../../../widgets/users/community_coping_skills/community_skills_list.dart';

class CommunityCopingSkillsOverviewScreen extends StatefulWidget {
  static const routeName = '/community-coping-skills';
  @override
  _CommunityCopingSkillsOverviewScreenState createState() =>
      _CommunityCopingSkillsOverviewScreenState();
}

class _CommunityCopingSkillsOverviewScreenState
    extends State<CommunityCopingSkillsOverviewScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Tab> tabsList = [
    Tab(text: 'Recent'),
    Tab(text: 'Most Liked'),
  ];

  var selectedIndex = 0;

  final _form = GlobalKey<FormState>();
  String _descriptionInput;

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
      _descriptionInput = '';
      _refreshScreen(context).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final date = DateTime.now();
    final skillInput = CommunityCopingSkill(
      id: '',
      description: _descriptionInput,
      likedBy: [],
      likes: 0,
      date: date,
    );
    Provider.of<CommunityCopingSkills>(context, listen: false)
        .addCommunityCopingSkill(skillInput);
    Navigator.of(context).pop();
  }

  Future<void> _refreshScreen(BuildContext context) async {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    await Provider.of<CommunityCopingSkills>(context, listen: false)
        .fetchAndSetCommunityCopingSkills(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Coping Skills'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Add a community coping skill.'),
                  content: Form(
                    key: _form,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      onSaved: (value) => _descriptionInput = value,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'You have to enter a description.';
                        }
                        if (value.trim().length < 5) {
                          return 'Descrpiption should be at least 5 characters long.';
                        }
                        return null;
                      },
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: _saveForm,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          tabs: tabsList,
          controller: _tabController,
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
                  onRefresh: () => _refreshScreen(context),
                  child: CommunitySkillsList(
                    selectedIndex,
                    tabsList[selectedIndex].text,
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () => _refreshScreen(context),
                  child: CommunitySkillsList(
                    selectedIndex,
                    tabsList[selectedIndex].text,
                  ),
                ),
              ],
            ),
    );
  }
}
