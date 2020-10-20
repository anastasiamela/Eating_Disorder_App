import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/http_exception.dart';

class Goal with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String patientId;
  final String createdBy;
  final DateTime creationDate;
  final DateTime scheduleToCompleteDate;
  final DateTime completeDate;
  final bool isCompleted;

  Goal({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.patientId,
    @required this.createdBy,
    @required this.creationDate,
    @required this.scheduleToCompleteDate,
    @required this.completeDate,
    @required this.isCompleted,
  });
}

class Goals with ChangeNotifier {
  List<Goal> _goals = [];

  Goals();

  List<Goal> get goals {
    return [..._goals];
  }

  List<Goal> get goalsByPatient {
    return _goals
        .where((goal) => goal.patientId == goal.createdBy ?? () => null)
        .toList();
  }

  List<Goal> get copingSkillsByClinician {
    return _goals
        .where((goal) => goal.patientId != goal.createdBy ?? () => null)
        .toList();
  }

  Goal findById(String id) {
    return _goals.firstWhere((goal) => goal.id == id);
  }

  Future<void> fetchAndSetGoals(String patientId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .collection('goals')
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;
      if (extractedData == null) {
        return;
      }
      final List<Goal> loadedGoals = [];
      extractedData.forEach((goal) {
        var goalData = goal.data();
        loadedGoals.add(
          Goal(
            id: goal.id,
            patientId: goalData['patientId'],
            createdBy: goalData['createdBy'],
            name: goalData['name'],
            description: goalData['description'],
            creationDate: DateTime.parse(goalData['creationDate']),
            scheduleToCompleteDate:
                DateTime.parse(goalData['scheduleToCompleteDate']),
            completeDate: DateTime.parse(goalData['completeDate']),
            isCompleted: goalData['isCompleted'],
          ),
        );
      });
      _goals = loadedGoals;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addGoal(Goal goalInput) async {
    final timestamp = DateTime.now();
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(goalInput.patientId)
          .collection('goals')
          .add({
        'patientId': goalInput.patientId,
        'createdBy': goalInput.createdBy,
        'creationDate': goalInput.creationDate.toIso8601String(),
        'scheduleToCompleteDate':
            goalInput.scheduleToCompleteDate.toIso8601String(),
        'completeDate': goalInput.completeDate.toIso8601String(),
        'isCompleted': goalInput.isCompleted,
        'name': goalInput.name,
        'description': goalInput.description,
        'createdAt': Timestamp.fromDate(timestamp),
      });
      final newGoal = Goal(
        id: response.id,
        patientId: goalInput.patientId,
        createdBy: goalInput.createdBy,
        creationDate: goalInput.creationDate,
        scheduleToCompleteDate: goalInput.scheduleToCompleteDate,
        completeDate: goalInput.completeDate,
        isCompleted: goalInput.isCompleted,
        name: goalInput.name,
        description: goalInput.description,
      );
      _goals.add(newGoal);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateGoal(String id, Goal newGoal) async {
    final goalIndex = _goals.indexWhere((goal) => goal.id == id);
    if (goalIndex >= 0) {
      final timestamp = DateTime.now();
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(newGoal.patientId)
          .collection('goals')
          .doc(id)
          .set({
        'patientId': newGoal.patientId,
        'createdBy': newGoal.createdBy,
        'creationDate': newGoal.creationDate.toIso8601String(),
        'scheduleToCompleteDate':
            newGoal.scheduleToCompleteDate.toIso8601String(),
        'completeDate': newGoal.completeDate.toIso8601String(),
        'isCompleted': newGoal.isCompleted,
        'name': newGoal.name,
        'description': newGoal.description,
        'createdAt': Timestamp.fromDate(timestamp),
      });
      _goals[goalIndex] = newGoal;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteGoal(String id, String patientId) async {
    final existingGoalIndex = _goals.indexWhere((goal) => goal.id == id);
    var existingGoal = _goals[existingGoalIndex];
    _goals.removeAt(existingGoalIndex);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .collection('goals')
          .doc(id)
          .delete();
      existingGoal = null;
    } catch (error) {
      _goals.insert(existingGoalIndex, existingGoal);
      notifyListeners();
      throw HttpException('Could not delete the goal.');
    }
  }

  Future<void> fetchAndSetCopingSkillsOfPatients(List<String> patients) async {
    try {
      final response = await FirebaseFirestore.instance
          .collectionGroup('goals')
          .where('patientId', whereIn: patients)
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;
      if (extractedData == null) {
        return;
      }
      final List<Goal> loadedGoals = [];
      extractedData.forEach((goal) {
        var goalData = goal.data();
        loadedGoals.add(
          Goal(
            id: goal.id,
            patientId: goalData['patientId'],
            createdBy: goalData['createdBy'],
            creationDate: DateTime.parse(goalData['creationDate']),
            scheduleToCompleteDate:
                DateTime.parse(goalData['scheduleToCompleteDate']),
            completeDate: DateTime.parse(goalData['completeDate']),
            isCompleted: goalData['isCompleted'],
            name: goalData['name'],
            description: goalData['description'],
          ),
        );
      });
      _goals = loadedGoals;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
