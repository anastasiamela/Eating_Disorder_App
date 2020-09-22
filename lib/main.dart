import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

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
import './screens/clinicians/overview/my_patients_screen.dart';
import './screens/clinicians/overview/one_patient_logs_tabs_screen.dart';
import './screens/users/connect_with_clinician.dart/connect_with_clinician_screen.dart';
import './screens/users/connect_with_clinician.dart/add_clinician_screen.dart';
import './screens/clinicians/requests/requests_from_patients_screen.dart';

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

void main() {
  runApp(MyApp());
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
            ],
            child: Consumer<Auth>(
              builder: (ctx, auth, _) => MaterialApp(
                title: 'My diet app',
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
                  SettingsForLogsScreen.routeName: (ctx) => SettingsForLogsScreen(),
                  GeneralSettingsUsersScreen.routeName: (ctx) => GeneralSettingsUsersScreen(),
                  LogActivityOfPatientsScreen.routeName: (ctx) => LogActivityOfPatientsScreen(),
                  MyPatientsScreen.routeName: (ctx) => MyPatientsScreen(),
                  OnePatientLogsTabsScreen.routeName: (ctx) => OnePatientLogsTabsScreen(),
                  ConnectWithClinicianScreen.routeName: (ctx) => ConnectWithClinicianScreen(),
                  AddClinicianScreen.routename: (ctx) => AddClinicianScreen(),
                  RequestsFromPatientsScreen.routeName: (ctx) => RequestsFromPatientsScreen(),
                },
              ),
            ),
          );
        });
  }
}
