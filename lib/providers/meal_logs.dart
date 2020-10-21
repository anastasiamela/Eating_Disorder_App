import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';

import '../models/http_exception.dart';
import './meal_log.dart';

class MealLogs with ChangeNotifier {
  List<MealLog> _meals = [];

  List<MealLog> _mealsCurrentDay = [];

  List<MealLog> get mealsCurrentDay {
    return [..._mealsCurrentDay];
  }

  MealLogs();

  List<MealLog> get meals {
    return [..._meals];
  }

  List<MealLog> get mealsSorted {
    _meals.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return [..._meals];
  }

  List<MealLog> get favoriteMeals {
    return _meals.where((meal) => meal.isFavorite ?? () => null).toList();
  }

  List<MealLog> get skippedMeals {
    return _meals.where((meal) => meal.skip ?? () => null).toList();
  }

  List<MealLog> get backLogMeals {
    return _meals.where((meal) => meal.isBackLog ?? () => null).toList();
  }

  List<MealLog> get mealsWithThoughts {
    return _meals.where((meal) => meal.thoughts != '' ?? () => null).toList();
  }

  List<MealLog> get mealsWithFeelings {
    return _meals
        .where((meal) =>
            (meal.feelingOverall != '' || meal.feelingsList.isNotEmpty) ??
            () => null)
        .toList();
  }

  List<MealLog> get mealsWithBehaviors {
    return _meals
        .where((meal) => (meal.behaviorsList.isNotEmpty) ?? () => null)
        .toList();
  }

  MealLog findById(String id) {
    return _meals.firstWhere((meal) => meal.id == id);
  }

  Future<void> fetchAndSetMealLogs(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('mealLogs')
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;

      if (extractedData == null) {
        return;
      }
      final List<MealLog> loadedMealLogs = [];
      extractedData.forEach((mealLog) {
        var mealData = mealLog.data();
        loadedMealLogs.add(MealLog(
          id: mealLog.id,
          userId: mealData['userId'],
          date: DateTime.parse(mealData['date']),
          skip: mealData['skip'],
          feelingOverall: mealData['feelingOverall'],
          mealType: mealData['mealType'],
          mealCompany: mealData['mealCompany'],
          mealLocation: mealData['mealLocation'],
          mealPhoto: mealData['mealPhoto'],
          mealDescription: mealData['mealDescription'],
          mealPortion: mealData['mealPortion'],
          thoughts: mealData['thoughts'],
          skippingReason: mealData['skippingReason'],
          isBackLog: mealData['isBackLog'],
          dateTimeOfLog: DateTime.parse(mealData['dateTimeOfLog']),
          dateTimeOfLastUpdate:
              DateTime.parse(mealData['dateTimeOfLastUpdate']),
          isFavorite: mealData['isFavorite'],
          behaviorsList: new List<String>.from(mealData['behaviorsList']),
          feelingsList: new List<String>.from(mealData['feelingsList']),
        ));
      });
      _meals = loadedMealLogs;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetMealLogsCurrentDay(String userId) async {
    var today = DateTime.now();
    today = new DateTime(today.year, today.month, today.day);
    var todayString = today.toIso8601String();
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('mealLogs')
          .where('date', isGreaterThanOrEqualTo: todayString)
          .get();
      final extractedData = response.docs;

      if (extractedData == null) {
        return;
      }
      final List<MealLog> loadedMealLogs = [];
      extractedData.forEach((mealLog) {
        var mealData = mealLog.data();
        loadedMealLogs.add(MealLog(
          id: mealLog.id,
          userId: mealData['userId'],
          date: DateTime.parse(mealData['date']),
          skip: mealData['skip'],
          feelingOverall: mealData['feelingOverall'],
          mealType: mealData['mealType'],
          mealCompany: mealData['mealCompany'],
          mealLocation: mealData['mealLocation'],
          mealPhoto: mealData['mealPhoto'],
          mealDescription: mealData['mealDescription'],
          mealPortion: mealData['mealPortion'],
          thoughts: mealData['thoughts'],
          skippingReason: mealData['skippingReason'],
          isBackLog: mealData['isBackLog'],
          dateTimeOfLog: DateTime.parse(mealData['dateTimeOfLog']),
          dateTimeOfLastUpdate:
              DateTime.parse(mealData['dateTimeOfLastUpdate']),
          isFavorite: mealData['isFavorite'],
          behaviorsList: new List<String>.from(mealData['behaviorsList']),
          feelingsList: new List<String>.from(mealData['feelingsList']),
        ));
      });
      _mealsCurrentDay = loadedMealLogs;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addMealLog(MealLog meal, String userId, File imageFile) async {
    final timestamp = DateTime.now();
    var today = DateTime.now();
    today = new DateTime(today.year, today.month, today.day);
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('mealLogs')
          .add({
        'userId': userId,
        'date': meal.date.toIso8601String(),
        'skip': meal.skip,
        'feelingOverall': meal.feelingOverall,
        'mealType': meal.mealType,
        'mealCompany': meal.mealCompany,
        'mealLocation': meal.mealLocation,
        'mealPhoto': meal.mealPhoto,
        'mealDescription': meal.mealDescription,
        'mealPortion': meal.mealPortion,
        'thoughts': meal.thoughts,
        'skippingReason': meal.skippingReason,
        'isBackLog': meal.isBackLog,
        'dateTimeOfLog': meal.dateTimeOfLog.toIso8601String(),
        'dateTimeOfLastUpdate': timestamp.toIso8601String(),
        'isFavorite': false,
        'createdAt': Timestamp.fromDate(timestamp),
        'behaviorsList': FieldValue.arrayUnion(meal.behaviorsList),
        'feelingsList': FieldValue.arrayUnion(meal.feelingsList)
      });
      final ref = FirebaseStorage.instance
          .ref()
          .child('meal_log_image')
          .child(response.id + '.jpg');
      await ref.putFile(imageFile).onComplete;

      final String url = await ref.getDownloadURL();
      print(url);

      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('mealLogs')
          .doc(response.id)
          .set({
        'userId': userId,
        'date': meal.date.toIso8601String(),
        'skip': meal.skip,
        'feelingOverall': meal.feelingOverall,
        'mealType': meal.mealType,
        'mealCompany': meal.mealCompany,
        'mealLocation': meal.mealLocation,
        'mealPhoto': url,
        'mealDescription': meal.mealDescription,
        'mealPortion': meal.mealPortion,
        'thoughts': meal.thoughts,
        'skippingReason': meal.skippingReason,
        'isBackLog': meal.isBackLog,
        'dateTimeOfLog': meal.dateTimeOfLog.toIso8601String(),
        'dateTimeOfLastUpdate': timestamp.toIso8601String(),
        'isFavorite': false,
        'createdAt': Timestamp.fromDate(timestamp),
        'behaviorsList': FieldValue.arrayUnion(meal.behaviorsList),
        'feelingsList': FieldValue.arrayUnion(meal.feelingsList)
      });
      final newMealLog = MealLog(
        id: response.id,
        userId: userId,
        date: meal.date,
        skip: meal.skip,
        feelingOverall: meal.feelingOverall,
        mealType: meal.mealType,
        mealCompany: meal.mealCompany,
        mealLocation: meal.mealLocation,
        mealPhoto: url,
        mealDescription: meal.mealDescription,
        mealPortion: meal.mealPortion,
        thoughts: meal.thoughts,
        skippingReason: meal.skippingReason,
        isBackLog: meal.isBackLog,
        dateTimeOfLog: meal.dateTimeOfLog,
        dateTimeOfLastUpdate: timestamp,
        behaviorsList: meal.behaviorsList,
        feelingsList: meal.feelingsList,
      );
      _meals.insert(0, newMealLog); // at the start of the list
      if (newMealLog.date.isAfter(today)) {
        _mealsCurrentDay.insert(0, newMealLog);
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateMealLog(
      String id, MealLog newMealLog, String userId) async {
    final mealIndex = _meals.indexWhere((meal) => meal.id == id);
    // var today = DateTime.now();
    // today = new DateTime(today.year, today.month, today.day);
    // int mealCurrentDayIndex = -1;
    // if(newMealLog.date.isAfter(today)) {
    //     mealCurrentDayIndex = _meals.indexWhere((meal) => meal.id == id);
    //   }
    if (mealIndex >= 0) {
      final timestamp = DateTime.now();
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('mealLogs')
          .doc(id)
          .set({
        'userId': userId,
        'date': newMealLog.date.toIso8601String(),
        'skip': newMealLog.skip,
        'feelingOverall': newMealLog.feelingOverall,
        'mealType': newMealLog.mealType,
        'mealCompany': newMealLog.mealCompany,
        'mealLocation': newMealLog.mealLocation,
        'mealPhoto': newMealLog.mealPhoto,
        'mealDescription': newMealLog.mealDescription,
        'mealPortion': newMealLog.mealPortion,
        'thoughts': newMealLog.thoughts,
        'skippingReason': newMealLog.skippingReason,
        'isBackLog': newMealLog.isBackLog,
        'dateTimeOfLog': newMealLog.dateTimeOfLog.toIso8601String(),
        'dateTimeOfLastUpdate': timestamp.toIso8601String(),
        'isFavorite': newMealLog.isFavorite,
        'createdAt': Timestamp.fromDate(newMealLog.date),
        'behaviorsList': FieldValue.arrayUnion(newMealLog.behaviorsList),
        'feelingsList': FieldValue.arrayUnion(newMealLog.feelingsList)
      });
      _meals[mealIndex] = newMealLog;
      // if (mealCurrentDayIndex >= 0) {
      //   _meals[mealIndex] = newMealLog;
      // }
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteMealLog(String id, String userId) async {
    final existingMealIndex = _meals.indexWhere((meal) => meal.id == id);
    var existingMeal = _meals[existingMealIndex];
    _meals.removeAt(existingMealIndex);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('mealLogs')
          .doc(id)
          .delete();
      existingMeal = null;
    } catch (error) {
      _meals.insert(existingMealIndex, existingMeal);
      notifyListeners();
      throw HttpException('Could not delete the meal log.');
    }
  }

  Future<void> fetchAndSetMealLogsOfPatients(List<String> patients) async {
    try {
      final response = await FirebaseFirestore.instance
          .collectionGroup('mealLogs')
          .where('userId', whereIn: patients)
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;

      if (extractedData == null) {
        return;
      }
      final List<MealLog> loadedMealLogs = [];
      extractedData.forEach((mealLog) {
        var mealData = mealLog.data();
        loadedMealLogs.add(MealLog(
          id: mealLog.id,
          userId: mealData['userId'],
          date: DateTime.parse(mealData['date']),
          skip: mealData['skip'],
          feelingOverall: mealData['feelingOverall'],
          mealType: mealData['mealType'],
          mealCompany: mealData['mealCompany'],
          mealLocation: mealData['mealLocation'],
          mealPhoto: mealData['mealPhoto'],
          mealDescription: mealData['mealDescription'],
          mealPortion: mealData['mealPortion'],
          thoughts: mealData['thoughts'],
          skippingReason: mealData['skippingReason'],
          isBackLog: mealData['isBackLog'],
          dateTimeOfLog: DateTime.parse(mealData['dateTimeOfLog']),
          dateTimeOfLastUpdate:
              DateTime.parse(mealData['dateTimeOfLastUpdate']),
          isFavorite: mealData['isFavorite'],
          behaviorsList: new List<String>.from(mealData['behaviorsList']),
          feelingsList: new List<String>.from(mealData['feelingsList']),
        ));
      });
      _meals = loadedMealLogs;
      print(_meals);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
