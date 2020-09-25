import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> behaviorsAll = [
  'restrict',
  'binge',
  'purge',
  'chewAndSpit',
  'swallowAndRegurgitate',
  'hideFood',
  'eatInSecret',
  'countCalories',
  'useLaxatives',
  'useDietPills',
  'drinkAlcohol',
  'weigh',
  'bodyAvoid',
  'bodyCheck',
  'exercise',
];
List<String> feelingsAll = [
  'Happy',
  'Tired',
  'Anxious',
  'Sad',
  'Lonely',
  'Proud',
  'Hopeful',
  'Frustrated',
  'Guilty',
  'Disgust',
  'Bored',
  'Physical Pain',
  'Intrusive Food Thoughts',
  'Dizzy / Headache',
  'Irritable',
  'Angry',
  'Depressed',
  'Motivated',
  'Excited',
  'Grateful',
  'Joy',
  'Loved',
  'Satisfied',
  'Fearful',
  'Dynamic',
];

class SettingsForLogs with ChangeNotifier {
  List<String> _behaviorTypesList = [];
  List<String> _feelingTypesList = [];
  bool _settingsExist = false;

  List<String> get behaviorTypesList {
    return [..._behaviorTypesList];
  }

  List<String> get feelingTypesList {
    return [..._feelingTypesList];
  }

  bool get settingsExist {
    return _settingsExist;
  }

  Future<void> fetchAndSetSettingsForLogs(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('settingsForLogs')
          .doc(userId)
          .get();
      if (response.data() == null) {
        _behaviorTypesList = behaviorsAll;
        _feelingTypesList = feelingsAll;
        _settingsExist = false;
        notifyListeners();
        return;
      }
      var responseData = response.data();
      _behaviorTypesList =
          new List<String>.from(responseData['behaviorTypesList']);
      _feelingTypesList =
          new List<String>.from(responseData['feelingTypesList']);
      _settingsExist = true;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> setSettingsForLogs(List<String> behaviorsInput,
      List<String> feelingsInput, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('settingsForLogs')
          .doc(userId)
          .set({
        'behaviorTypesList': FieldValue.arrayUnion(behaviorsInput),
        'feelingTypesList': FieldValue.arrayUnion(feelingsInput),
      });
      _behaviorTypesList = behaviorsInput;
      _feelingTypesList = feelingsInput;
      _settingsExist = true;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
