import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/http_exception.dart';

class Behavior with ChangeNotifier {
  final String id;
  final String userId;
  final List<String> behaviorsList;
  final String restrictGrade;
  final String bingeGrade;
  final String purgeGrade;
  final String exerciseGrade;
  final int laxativesNumber;
  final int dietPillsNumber;
  final int drinksNumber;
  final List<String> bodyCheckType;
  final List<String> bodyAvoidType;
  final String thoughts;
  final DateTime date;
  final bool isBackLog;
  final DateTime dateTimeOfLog;
  final bool usedCopingSkills;

  bool isFavorite;
  Timestamp createdAt;

  Behavior({
    @required this.id,
    @required this.userId,
    @required this.behaviorsList,
    this.restrictGrade = '',
    this.bingeGrade = '',
    this.purgeGrade = '',
    this.exerciseGrade = '',
    this.laxativesNumber = -1,
    this.dietPillsNumber = -1,
    this.drinksNumber = -1,
    @required this.bodyAvoidType,
    @required this.bodyCheckType,
    @required this.thoughts,
    @required this.date,
    @required this.isBackLog,
    @required this.dateTimeOfLog,
    this.isFavorite = false,
    @required this.usedCopingSkills,
  });

  int get behaviorsListLenght {
    return behaviorsList.length;
  }

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('behaviors')
          .doc(id)
          .update({'isFavorite': isFavorite});
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}

class Behaviors with ChangeNotifier {
  List<Behavior> _behaviors = [];

  Behaviors();

  List<Behavior> get behaviors {
    return [..._behaviors];
  }

  List<Behavior> get behaviorsSorted {
    _behaviors.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return [..._behaviors];
  }

  List<Behavior> get favoriteBehaviors {
    return _behaviors
        .where((behavior) => behavior.isFavorite ?? () => null)
        .toList();
  }

  List<Behavior> get backLogBehaviors {
    return _behaviors
        .where((behavior) => behavior.isBackLog ?? () => null)
        .toList();
  }

  List<Behavior> get behaviorsWithThoughts {
    return _behaviors
        .where((behavior) => behavior.thoughts != '' ?? () => null)
        .toList();
  }

  List<Behavior> get behaviorsWithCopingSkills {
    return _behaviors
        .where((behavior) => behavior.usedCopingSkills ?? () => null)
        .toList();
  }

  Behavior findById(String id) {
    return _behaviors.firstWhere((behavior) => behavior.id == id);
  }

  Future<void> fetchAndSetBehaviors(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('behaviors')
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;
      if (extractedData == null) {
        return;
      }
      final List<Behavior> loadedBehaviors = [];
      extractedData.forEach((behavior) async {
        var behaviorData = behavior.data();
        loadedBehaviors.add(
          Behavior(
            id: behavior.id,
            userId: behaviorData['userId'],
            date: DateTime.parse(behaviorData['date']),
            behaviorsList: new List<String>.from(behaviorData['behaviorsList']),
            restrictGrade: behaviorData['restrictGrade'],
            bingeGrade: behaviorData['bingeGrade'],
            purgeGrade: behaviorData['purgeGrade'],
            exerciseGrade: behaviorData['exerciseGrade'],
            laxativesNumber: behaviorData['laxativesNumber'],
            dietPillsNumber: behaviorData['dietPillsNumber'],
            drinksNumber: behaviorData['drinksNumber'],
            bodyCheckType: new List<String>.from(behaviorData['bodyCheckType']),
            bodyAvoidType: new List<String>.from(behaviorData['bodyAvoidType']),
            thoughts: behaviorData['thoughts'],
            isFavorite: behaviorData['isFavorite'],
            isBackLog: behaviorData['isBackLog'],
            dateTimeOfLog: DateTime.parse(behaviorData['dateTimeOfLog']),
            usedCopingSkills: behaviorData['usedCopingSkills'],
          ),
        );
      });
      _behaviors = loadedBehaviors;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addBehavior(Behavior behaviorInput, String userId,
      List<UsedCopingSkill> skills) async {
    final timestamp = DateTime.now();
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('behaviors')
          .add({
        'userId': userId,
        'date': behaviorInput.date.toIso8601String(),
        'behaviorsList': FieldValue.arrayUnion(behaviorInput.behaviorsList),
        'restrictGrade': behaviorInput.restrictGrade,
        'bingeGrade': behaviorInput.bingeGrade,
        'purgeGrade': behaviorInput.purgeGrade,
        'exerciseGrade': behaviorInput.exerciseGrade,
        'laxativesNumber': behaviorInput.laxativesNumber,
        'dietPillsNumber': behaviorInput.dietPillsNumber,
        'drinksNumber': behaviorInput.drinksNumber,
        'bodyCheckType': FieldValue.arrayUnion(behaviorInput.bodyCheckType),
        'bodyAvoidType': FieldValue.arrayUnion(behaviorInput.bodyAvoidType),
        'thoughts': behaviorInput.thoughts,
        'isFavorite': false,
        'createdAt': Timestamp.fromDate(behaviorInput.date),
        'isBackLog': behaviorInput.isBackLog,
        'dateTimeOfLog': timestamp.toIso8601String(),
        'usedCopingSkills': behaviorInput.usedCopingSkills,
      });
      final newBehavior = Behavior(
        id: response.id,
        userId: userId,
        date: behaviorInput.date,
        behaviorsList: behaviorInput.behaviorsList,
        restrictGrade: behaviorInput.restrictGrade,
        bingeGrade: behaviorInput.bingeGrade,
        purgeGrade: behaviorInput.purgeGrade,
        exerciseGrade: behaviorInput.exerciseGrade,
        laxativesNumber: behaviorInput.laxativesNumber,
        dietPillsNumber: behaviorInput.dietPillsNumber,
        drinksNumber: behaviorInput.drinksNumber,
        bodyAvoidType: behaviorInput.bodyAvoidType,
        bodyCheckType: behaviorInput.bodyCheckType,
        thoughts: behaviorInput.thoughts,
        isBackLog: behaviorInput.isBackLog,
        dateTimeOfLog: timestamp,
        usedCopingSkills: behaviorInput.usedCopingSkills,
      );
      _behaviors.add(newBehavior);
      if (newBehavior.usedCopingSkills) {
        await addUsedCopingSkills(skills, userId, response.id);
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addUsedCopingSkills(
      List<UsedCopingSkill> skills, String userId, String logId) async {
    for (UsedCopingSkill skill in skills) {
      try {
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(userId)
            .collection('behaviors')
            .doc(logId)
            .collection('usedCopingSkills')
            .add({
          'userId': userId,
          'name': skill.name,
          'description': skill.description,
          'createdAt': Timestamp.fromDate(DateTime.now()),
        });
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> updateBehavior(
      String id, Behavior newBehavior, String userId) async {
    final behaviorIndex =
        _behaviors.indexWhere((behavior) => behavior.id == id);
    if (behaviorIndex >= 0) {
      //final timestamp = DateTime.now();
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('behaviors')
          .doc(id)
          .set({
        'userId': userId,
        'date': newBehavior.date.toIso8601String(),
        'behaviorsList': FieldValue.arrayUnion(newBehavior.behaviorsList),
        'restrictGrade': newBehavior.restrictGrade,
        'bingeGrade': newBehavior.bingeGrade,
        'purgeGrade': newBehavior.purgeGrade,
        'exerciseGrade': newBehavior.exerciseGrade,
        'laxativesNumber': newBehavior.laxativesNumber,
        'dietPillsNumber': newBehavior.dietPillsNumber,
        'drinksNumber': newBehavior.drinksNumber,
        'bodyCheckType': FieldValue.arrayUnion(newBehavior.bodyCheckType),
        'bodyAvoidType': FieldValue.arrayUnion(newBehavior.bodyAvoidType),
        'thoughts': newBehavior.thoughts,
        'isFavorite': false,
        'createdAt': Timestamp.fromDate(newBehavior.date),
        'isBackLog': newBehavior.isBackLog,
        'dateTimeOfLog': newBehavior.dateTimeOfLog.toIso8601String(),
      });
      _behaviors[behaviorIndex] = newBehavior;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteBehavior(String id, String userId) async {
    final existingBehaviorIndex =
        _behaviors.indexWhere((behavior) => behavior.id == id);
    var existingBehavior = _behaviors[existingBehaviorIndex];
    _behaviors.removeAt(existingBehaviorIndex);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('behaviors')
          .doc(id)
          .delete();
      existingBehavior = null;
    } catch (error) {
      _behaviors.insert(existingBehaviorIndex, existingBehavior);
      notifyListeners();
      throw HttpException('Could not delete the behavior log.');
    }
  }

  Future<void> fetchAndSetBehaviorsOfPatients(List<String> patients) async {
    try {
      final response = await FirebaseFirestore.instance
          .collectionGroup('behaviors')
          .where('userId', whereIn: patients)
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;
      if (extractedData == null) {
        return;
      }
      final List<Behavior> loadedBehaviors = [];
      extractedData.forEach((behavior) {
        var behaviorData = behavior.data();
        loadedBehaviors.add(
          Behavior(
            id: behavior.id,
            userId: behaviorData['userId'],
            date: DateTime.parse(behaviorData['date']),
            behaviorsList: new List<String>.from(behaviorData['behaviorsList']),
            restrictGrade: behaviorData['restrictGrade'],
            bingeGrade: behaviorData['bingeGrade'],
            purgeGrade: behaviorData['purgeGrade'],
            exerciseGrade: behaviorData['exerciseGrade'],
            laxativesNumber: behaviorData['laxativesNumber'],
            dietPillsNumber: behaviorData['dietPillsNumber'],
            drinksNumber: behaviorData['drinksNumber'],
            bodyCheckType: new List<String>.from(behaviorData['bodyCheckType']),
            bodyAvoidType: new List<String>.from(behaviorData['bodyAvoidType']),
            thoughts: behaviorData['thoughts'],
            isFavorite: behaviorData['isFavorite'],
            isBackLog: behaviorData['isBackLog'],
            dateTimeOfLog: DateTime.parse(behaviorData['dateTimeOfLog']),
            usedCopingSkills: behaviorData['usedCopingSkills'],
          ),
        );
      });
      _behaviors = loadedBehaviors;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<List<UsedCopingSkill>> fetchAndSetUsedCopingSkills(
      String userId, String logId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('behaviors')
          .doc(logId)
          .collection('usedCopingSkills')
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;

      if (extractedData == null) {
        return [];
      }
      final List<UsedCopingSkill> loadedSkills = [];
      extractedData.forEach((skill) {
        var skillData = skill.data();
        loadedSkills.add(
          UsedCopingSkill(
            name: skillData['name'],
            description: skillData['description'],
          ),
        );
      });
      return loadedSkills;
    } catch (error) {
      throw (error);
    }
  }
}

class UsedCopingSkill {
  final String name;
  final String description;

  UsedCopingSkill({
    @required this.name,
    @required this.description,
  });
}
