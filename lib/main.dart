import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import './screens/users/logs_screens/general_logs_overview_screen.dart';
import './screens/users/logs_screens/meal_log_detail_screen.dart';
import './screens/users/add_input/add_meal_log_screen.dart';
import './screens/users/add_input/edit_meal_log_screen.dart';
import './screens/auth_screen.dart';
//import './screens/splash_screen.dart';
import './screens/users/settings_users/settings_logging_goals.dart';
import './screens/users/add_input/add_thought_screen.dart';
import './screens/users/logs_screens/calendar_logs_screen.dart';
import './screens/users/add_input/add_feeling_log_screen.dart';
import './screens/users/add_input/add_behavior_log_screen.dart';
import './screens/first_screen.dart';
import './screens/users/meal_plans.dart/meal_plans_overview_screen.dart';
import './screens/users/add_input/add_meal_plan.dart';
import './screens/users/settings_users/settings_for_logs_screen.dart';
import './screens/users/settings_users/general_settings_users_screen.dart';
import './screens/clinicians/overview/log_activity_of_patients_screen.dart';
import './screens/clinicians/overview/one_patient_logs_tabs_screen.dart';
import './screens/users/connect_with_clinician.dart/connect_with_clinician_screen.dart';
import './screens/users/connect_with_clinician.dart/add_clinician_screen.dart';
import './screens/clinicians/overview/my_patients_tabs_screen.dart';
import './screens/users/add_input/add_coping_skill_screen.dart';
import './screens/users/coping_skills/my_coping_skills_screen.dart';
import './screens/clinicians/coping_skills/coping_skills_of_patients_screen.dart';
import './screens/clinicians/coping_skills/add_coping_skill_for_patient_screen.dart';
import './screens/users/logs_screens/thought_log_detail_screen.dart';
import './screens/users/logs_screens/feeling_log_detail_screen.dart';
import './screens/users/logs_screens/behavior_log_detail_screen.dart';
import './screens/users/coping_skills/my_coping_skill_detail_screen.dart';
import './screens/clinicians/coping_skills/coping_skill_detail_screen.dart';
import './screens/clinicians/detail_screens/meal_log__of_patient_detail.dart';
import './screens/clinicians/detail_screens/feeling_log_of_patient_detail_screen.dart';
import './screens/clinicians/detail_screens/behavior_log_of_patient_detail_screen.dart';
import './screens/clinicians/detail_screens/thought_log_of_patient_detail_screen.dart';
import './screens/comments_of_logs_screen.dart';
import './screens/users/communtity_coping_skills/community_skills_overview_screen.dart';
import './screens/users/reminders/reminders_screen.dart';
import './screens/clinicians/overview/one_patient_screen.dart';
import './screens/clinicians/one_patient/one_patient_coping_skills_screen.dart';
import './screens/clinicians/one_patient/one_patient_meal_plans.dart';
import './screens/users/tips/tips_categories_screen.dart';
import './screens/users/tips/tips_one_category_screen.dart';
import './screens/users/tips/nutri_sources_categories_screen.dart';
import './screens/users/tips/nutri_source_one_category_screen.dart';
import './screens/users/add_input/add_goal_screen.dart';
import './screens/users/goals/my_goals_screen.dart';
import './screens/users/goals/my_goal_detail_screen.dart';
import './screens/clinicians/one_patient/one_patient_goals_screen.dart';
import './screens/clinicians/goals/goal_detail_screen.dart';
import './screens/clinicians/goals/goals_of_patients_screen.dart';

import './providers/meal_logs.dart';
import './providers/logging_goals.dart';
import './providers/thoughts.dart';
import './providers/feelings.dart';
import './providers/behaviors.dart';
import './providers/auth.dart';
import './providers/meal_plans.dart';
import './providers/settings_for_logs.dart';
import './providers/clinicians/patients_of_clinicians.dart';
import './providers/requests.dart';
import './providers/coping_skills.dart';
import './providers/community_coping_skills.dart';
import './providers/connected_clinician.dart';
import './providers/reminders.dart';
import './providers/goals.dart';

void main() {
  //runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        future: _initialization,
        builder: (context, appSnapshot) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => Auth(),
              ),
              ChangeNotifierProvider<MealLogs>(
                create: (_) => MealLogs(),
              ),
              ChangeNotifierProvider<Thoughts>(
                create: (_) => Thoughts(),
              ),
              ChangeNotifierProvider(
                create: (_) => LoggingGoals(),
              ),
              ChangeNotifierProvider(
                create: (_) => Feelings(),
              ),
              ChangeNotifierProvider(
                create: (_) => Behaviors(),
              ),
              ChangeNotifierProvider(
                create: (_) => MealPlans(),
              ),
              ChangeNotifierProvider(
                create: (_) => SettingsForLogs(),
              ),
              ChangeNotifierProvider(
                create: (_) => PatientsOfClinician(),
              ),
              ChangeNotifierProvider(
                create: (_) => Requests(),
              ),
              ChangeNotifierProvider(
                create: (_) => CopingSkills(),
              ),
              ChangeNotifierProvider(
                create: (_) => CommunityCopingSkills(),
              ),
              ChangeNotifierProvider(
                create: (_) => ConnectedClinician(),
              ),
              ChangeNotifierProvider(
                create: (_) => SettingsForReminders(),
              ),
              ChangeNotifierProvider(
                create: (_) => Goals(),
              ),
            ],
            child: Consumer<Auth>(
              builder: (ctx, auth, _) => MaterialApp(
                title: 'My diet app',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: Colors.teal[400],
                  primarySwatch: Colors.teal,
                  accentColor: Colors.teal[200],
                ),
                home: auth.user == null ? AuthScreen() : FirstScreen(),
                routes: {
                  MealLogDetailScreen.routeName: (ctx) => MealLogDetailScreen(),
                  GeneralLogsOverviewScreen.routeName: (ctx) =>
                      GeneralLogsOverviewScreen(),
                  CalendarLogsScreen.routeName: (ctx) => CalendarLogsScreen(),
                  AddMealLogScreen.routeName: (ctx) => AddMealLogScreen(),
                  EditMealLogScreen.routeName: (ctx) => EditMealLogScreen(),
                  SettingsLoggingGoals.routeName: (ctx) =>
                      SettingsLoggingGoals(),
                  AddThoughtScreen.routeName: (ctx) => AddThoughtScreen(),
                  AddFeelingLogScreen.routeName: (ctx) => AddFeelingLogScreen(),
                  AddBehaviorLogScreen.routeName: (ctx) =>
                      AddBehaviorLogScreen(),
                  MealPlansOverviewScreen.routeName: (ctx) =>
                      MealPlansOverviewScreen(),
                  AddMealPlan.routeName: (ctx) => AddMealPlan(),
                  SettingsForLogsScreen.routeName: (ctx) =>
                      SettingsForLogsScreen(),
                  GeneralSettingsUsersScreen.routeName: (ctx) =>
                      GeneralSettingsUsersScreen(),
                  LogActivityOfPatientsScreen.routeName: (ctx) =>
                      LogActivityOfPatientsScreen(),
                  OnePatientLogsTabsScreen.routeName: (ctx) =>
                      OnePatientLogsTabsScreen(),
                  ConnectWithClinicianScreen.routeName: (ctx) =>
                      ConnectWithClinicianScreen(),
                  AddClinicianScreen.routename: (ctx) => AddClinicianScreen(),
                  MyPatientsTabsScreen.routeName: (ctx) =>
                      MyPatientsTabsScreen(),
                  AddCopingSkillScreen.routeName: (ctx) =>
                      AddCopingSkillScreen(),
                  MyCopingSkillsScreen.routeName: (ctx) =>
                      MyCopingSkillsScreen(),
                  CopingSkillsOfPatientsScreen.routeName: (ctx) =>
                      CopingSkillsOfPatientsScreen(),
                  AddCopingSkillForPatientScreen.routeName: (ctx) =>
                      AddCopingSkillForPatientScreen(),
                  ThoughtLogDetailScreen.routeName: (ctx) =>
                      ThoughtLogDetailScreen(),
                  FeelingLogDetailScreen.routeName: (ctx) =>
                      FeelingLogDetailScreen(),
                  BehaviorLogDetailScreen.routeName: (ctx) =>
                      BehaviorLogDetailScreen(),
                  MyCopingSkillDetailScreen.routeName: (ctx) =>
                      MyCopingSkillDetailScreen(),
                  CopingSkillDetailScreen.routeName: (ctx) =>
                      CopingSkillDetailScreen(),
                  MealLogOfPatientDetailScreen.routeName: (ctx) =>
                      MealLogOfPatientDetailScreen(),
                  FeelingLogOfPatientDetailScreen.routeName: (ctx) =>
                      FeelingLogOfPatientDetailScreen(),
                  BehaviorLogOfPatientDetailScreen.routeName: (ctx) =>
                      BehaviorLogOfPatientDetailScreen(),
                  ThoughtLogOfPatientDetailScreen.routeName: (ctx) =>
                      ThoughtLogOfPatientDetailScreen(),
                  CommentsOfLogsScreen.routeName: (ctx) =>
                      CommentsOfLogsScreen(),
                  CommunityCopingSkillsOverviewScreen.routeName: (ctx) =>
                      CommunityCopingSkillsOverviewScreen(),
                  RemindersScreen.routeName: (ctx) => RemindersScreen(),
                  OnePatientScreen.routeName: (ctx) => OnePatientScreen(),
                  OnePatientSkillsScreen.routeName: (ctx) =>
                      OnePatientSkillsScreen(),
                  OnePatientMealPlansScreen.routeName: (ctx) =>
                      OnePatientMealPlansScreen(),
                  TipsCategoriesScreen.routeName: (ctx) =>
                      TipsCategoriesScreen(),
                  TipsOneCategoryScreen.routeName: (ctx) =>
                      TipsOneCategoryScreen(),
                  NutriSourceOneCategoryScreen.routeName: (ctx) =>
                      NutriSourceOneCategoryScreen(),
                  NutriSourcesCategoriesScreen.routeName: (ctx) =>
                      NutriSourcesCategoriesScreen(),
                  AddGoalScreen.routeName: (ctx) => AddGoalScreen(),
                  MyGoalsScreen.routeName: (ctx) => MyGoalsScreen(),
                  MyGoalDetailScreen.routeName: (ctx) => MyGoalDetailScreen(),
                  OnePatientGoalsScreen.routeName: (ctx) =>
                      OnePatientGoalsScreen(),
                  GoalDetailScreen.routeName: (ctx) => GoalDetailScreen(),
                  GoalsOfPatientsScreen.routeName: (ctx) => GoalsOfPatientsScreen()
                },
              ),
            ),
          );
        });
  }
}
