import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reminders {
  String breakfastReminder;
  String morningSnackReminder;
  String lunchReminder;
  String afternoonSnackReminder;
  String dinnerReminder;
  String eveningSnackReminder;
  String mealPlanReminder;
  bool areRemindersEnabled;
  String breakfastMessage;
  String morningSnackMessage;
  String lunchMessage;
  String afternoonSnackMessage;
  String dinnerMessage;
  String eveningSnackMessage;
  String mealPlanMessage;

  Reminders({
    @required this.breakfastReminder,
    @required this.morningSnackReminder,
    @required this.lunchReminder,
    @required this.afternoonSnackReminder,
    @required this.dinnerReminder,
    @required this.eveningSnackReminder,
    @required this.mealPlanReminder,
    @required this.areRemindersEnabled,
    @required this.breakfastMessage,
    @required this.morningSnackMessage,
    @required this.lunchMessage,
    @required this.afternoonSnackMessage,
    @required this.dinnerMessage,
    @required this.eveningSnackMessage,
    @required this.mealPlanMessage,
  });
}

class SettingsForReminders with ChangeNotifier {
  Reminders _remindersInfo = Reminders(
    breakfastReminder: '',
    morningSnackReminder: '',
    lunchReminder: '',
    afternoonSnackReminder: '',
    dinnerReminder: '',
    eveningSnackReminder: '',
    mealPlanReminder: '',
    areRemindersEnabled: true,
    breakfastMessage: '',
    morningSnackMessage: '',
    lunchMessage: '',
    afternoonSnackMessage: '',
    dinnerMessage: '',
    eveningSnackMessage: '',
    mealPlanMessage: '',
  );
  bool _settingsRemindersExist = false;

  bool get settingsRemindersExist => _settingsRemindersExist;

  Reminders get remindersInfo => _remindersInfo;

  Future<void> fetchAndSetSettingsForReminders(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('settingsForReminders')
          .doc(userId)
          .get();
      if (response.data() == null || response == null) {
        _settingsRemindersExist = false;
        notifyListeners();
        return;
      }
      var responseData = response.data();
      _remindersInfo.breakfastReminder = responseData['breakfastReminder'];
      _remindersInfo.morningSnackReminder =
          responseData['morningSnackReminder'];
      _remindersInfo.lunchReminder = responseData['lunchReminder'];
      _remindersInfo.afternoonSnackReminder =
          responseData['afternoonSnackReminder'];
      _remindersInfo.dinnerReminder = responseData['dinnerReminder'];
      _remindersInfo.eveningSnackReminder =
          responseData['eveningSnackReminder'];
      _remindersInfo.mealPlanReminder = responseData['mealPlanReminder'];
      _remindersInfo.areRemindersEnabled = responseData['areRemindersEnabled'];
      _settingsRemindersExist = true;
      _remindersInfo.breakfastMessage = responseData['breakfastMessage'];
      _remindersInfo.morningSnackMessage =
          responseData['morningSnackMessage'];
      _remindersInfo.lunchMessage = responseData['lunchMessage'];
      _remindersInfo.afternoonSnackMessage =
          responseData['afternoonSnackMessage'];
      _remindersInfo.dinnerMessage = responseData['dinnerMessage'];
      _remindersInfo.eveningSnackMessage =
          responseData['eveningSnackMessage'];
      _remindersInfo.mealPlanMessage = responseData['mealPlanMessage'];
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> setSettingsForReminders(
      Reminders remindersInput, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('settingsForReminders')
          .doc(userId)
          .set({
        'breakfastReminder': remindersInput.breakfastReminder,
        'morningSnackReminder': remindersInput.morningSnackReminder,
        'lunchReminder': remindersInput.lunchReminder,
        'afternoonSnackReminder': remindersInput.afternoonSnackReminder,
        'dinnerReminder': remindersInput.dinnerReminder,
        'eveningSnackReminder': remindersInput.eveningSnackReminder,
        'mealPlanReminder': remindersInput.mealPlanReminder,
        'areRemindersEnabled': remindersInput.areRemindersEnabled,
        'breakfastMessage': remindersInput.breakfastMessage,
        'morningSnackMessage': remindersInput.morningSnackMessage,
        'lunchMessage': remindersInput.lunchMessage,
        'afternoonSnackMessage': remindersInput.afternoonSnackMessage,
        'dinnerMessage': remindersInput.dinnerMessage,
        'eveningSnackMessage': remindersInput.eveningSnackMessage,
        'mealPlanMessage': remindersInput.mealPlanMessage,
      });
      _remindersInfo.breakfastReminder = remindersInput.breakfastReminder;
      _remindersInfo.morningSnackReminder = remindersInput.morningSnackReminder;
      _remindersInfo.lunchReminder = remindersInput.lunchReminder;
      _remindersInfo.afternoonSnackReminder =
          remindersInput.afternoonSnackReminder;
      _remindersInfo.dinnerReminder = remindersInput.dinnerReminder;
      _remindersInfo.eveningSnackReminder = remindersInput.eveningSnackReminder;
      _remindersInfo.mealPlanReminder = remindersInput.mealPlanReminder;
      _remindersInfo.areRemindersEnabled = remindersInput.areRemindersEnabled;
      _remindersInfo.breakfastMessage = remindersInput.breakfastMessage;
      _remindersInfo.morningSnackMessage =
          remindersInput.morningSnackMessage;
      _remindersInfo.lunchMessage = remindersInput.lunchMessage;
      _remindersInfo.afternoonSnackMessage =
          remindersInput.afternoonSnackMessage;
      _remindersInfo.dinnerMessage = remindersInput.dinnerMessage;
      _remindersInfo.eveningSnackMessage =
          remindersInput.eveningSnackMessage;
      _remindersInfo.mealPlanMessage = remindersInput.mealPlanMessage;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
