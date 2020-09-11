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
  final String thoughts;

  final DateTime date;
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
    @required this.bodyCheckType,
    @required this.thoughts,
    @required this.date,
    this.isFavorite = false,
  });

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
          .collection('users')
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

  Behavior findById(String id) {
    return _behaviors.firstWhere((behavior) => behavior.id == id);
  }

  Future<void> fetchAndSetBehaviors(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('behaviors')
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
            thoughts: behaviorData['thoughts'],
            isFavorite: behaviorData['isFavorite'],
          ),
        );
      });
      _behaviors = loadedBehaviors;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addBehavior(Behavior behaviorInput, String userId) async {
    final timestamp = DateTime.now();
    try {
      final response = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('behaviors')
          .add({
        'userId': userId,
        'date': timestamp.toIso8601String(),
        'behaviorsList': FieldValue.arrayUnion(behaviorInput.behaviorsList),
        'restrictGrade': behaviorInput.restrictGrade,
        'bingeGrade': behaviorInput.bingeGrade,
        'purgeGrade': behaviorInput.purgeGrade,
        'exerciseGrade': behaviorInput.exerciseGrade,
        'laxativesNumber': behaviorInput.laxativesNumber,
        'dietPillsNumber': behaviorInput.dietPillsNumber,
        'drinksNumber': behaviorInput.drinksNumber,
        'bodyCheckType': FieldValue.arrayUnion(behaviorInput.bodyCheckType),
        'thoughts': behaviorInput.thoughts,
        'isFavorite': false,
        'createdAt': Timestamp.fromDate(timestamp),
      });
      final newBehavior = Behavior(
        id: response.id,
        userId: userId,
        date: timestamp,
        behaviorsList: behaviorInput.behaviorsList,
        restrictGrade: behaviorInput.restrictGrade,
        bingeGrade: behaviorInput.bingeGrade,
        purgeGrade: behaviorInput.purgeGrade,
        exerciseGrade: behaviorInput.exerciseGrade,
        laxativesNumber: behaviorInput.laxativesNumber,
        dietPillsNumber: behaviorInput.dietPillsNumber,
        drinksNumber: behaviorInput.drinksNumber,
        bodyCheckType: behaviorInput.bodyCheckType,
        thoughts: behaviorInput.thoughts,
      );
      _behaviors.add(newBehavior);
      //_feelings.insert(0, newFeeling); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
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
          .collection('users')
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
}
