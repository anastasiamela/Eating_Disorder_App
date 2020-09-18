import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealsPerDayData {
  final int mainMeals;
  final int snacks;

  MealsPerDayData({
    @required this.mainMeals,
    @required this.snacks,
  });
}

class LoggingGoals with ChangeNotifier {
  Map<DateTime, MealsPerDayData> _loggingGoals = new Map();

  var _mainMealsWeekday = 3;
  var _snacksWeekday = 2;
  var _mainMealsWeekend = 3;
  var _snacksWeekend = 2;

  Future<void> fetchAndSetLoggingGoalsSettings(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('loggingGoalsSettings')
          .doc(userId)
          .get();

      if (response == null) {
        return;
      }
      var responseData = response.data();
      _mainMealsWeekday = responseData['mainMealsWeekday'];
      _snacksWeekday = responseData['snacksWeekDay'];
      _mainMealsWeekend = responseData['mainMealsWeekend'];
      _snacksWeekend = responseData['snacksWeekend'];
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> setSettings(int mainMealsWeekdayInput, int snacksWeekdayInput,
      int mainMealsWeekendInput, int snacksWeekendInput, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('loggingGoalsSettings')
          .doc(userId)
          .set({
        'mainMealsWeekday': mainMealsWeekdayInput,
        'snacksWeekDay': snacksWeekdayInput,
        'mainMealsWeekend': mainMealsWeekendInput,
        'snacksWeekend': snacksWeekendInput,
      });
      _mainMealsWeekday = mainMealsWeekdayInput;
      _snacksWeekday = snacksWeekdayInput;
      _mainMealsWeekend = mainMealsWeekendInput;
      _snacksWeekend = snacksWeekendInput;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Map<DateTime, MealsPerDayData> get loggingGoals {
    return {..._loggingGoals};
  }

  int get mainMealsWeekday {
    return _mainMealsWeekday;
  }

  int get mainMealsWeekend {
    return _mainMealsWeekend;
  }

  int get snacksWeekday {
    return _snacksWeekday;
  }

  int get snacksWeekend {
    return _snacksWeekend;
  }

  void addMealForGoals(DateTime dateOfMeal, String typeOfMeal) {
    final date = DateTime(
      dateOfMeal.year,
      dateOfMeal.month,
      dateOfMeal.day,
    );
    if (_loggingGoals.containsKey(date)) {
      _loggingGoals.update(
        date,
        (existingData) => (typeOfMeal == 'breakfast' ||
                typeOfMeal == 'lunch' ||
                typeOfMeal == 'dinner')
            ? MealsPerDayData(
                mainMeals: existingData.mainMeals + 1,
                snacks: existingData.snacks,
              )
            : MealsPerDayData(
                mainMeals: existingData.mainMeals,
                snacks: existingData.snacks + 1,
              ),
      );
    } else {
      _loggingGoals.putIfAbsent(
        date,
        () => (typeOfMeal == 'breakfast' ||
                typeOfMeal == 'lunch' ||
                typeOfMeal == 'dinner')
            ? MealsPerDayData(
                mainMeals: 1,
                snacks: 0,
              )
            : MealsPerDayData(
                mainMeals: 0,
                snacks: 1,
              ),
      );
    }
  }

  void removeSingleMeal(DateTime dateOfMeal, String typeOfMeal) {
    final date = DateTime(
      dateOfMeal.year,
      dateOfMeal.month,
      dateOfMeal.day,
    );
    if (!_loggingGoals.containsKey(date)) {
      return;
    }
    if (typeOfMeal == 'breakfast' ||
        typeOfMeal == 'lunch' ||
        typeOfMeal == 'dinner') {
      if (_loggingGoals[date].mainMeals > 1) {
        _loggingGoals.update(
          date,
          (existingData) => MealsPerDayData(
            mainMeals: existingData.mainMeals - 1,
            snacks: existingData.snacks,
          ),
        );
      }
    } else {
      if (_loggingGoals[date].snacks > 1) {
        _loggingGoals.update(
          date,
          (existingData) => MealsPerDayData(
            mainMeals: existingData.mainMeals,
            snacks: existingData.snacks - 1,
          ),
        );
      }
    }
    if (_loggingGoals[date].mainMeals == 0 && _loggingGoals[date].snacks == 0) {
      _loggingGoals.remove(date);
    }
  }

  void clear() {
    _loggingGoals = new Map();
  }
}
