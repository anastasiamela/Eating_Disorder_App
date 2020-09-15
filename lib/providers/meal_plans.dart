import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/http_exception.dart';

class MealPlan with ChangeNotifier {
  final String id;
  final String userId;
  final String dayOfWeek;
  final String typeOfMeal;
  final List<String> mealItems;
  bool isTemplate;
  final DateTime createdAt;

  MealPlan(
      {@required this.id,
      @required this.userId,
      @required this.dayOfWeek,
      @required this.typeOfMeal,
      @required this.mealItems,
      this.isTemplate = false,
      @required this.createdAt});

  void _setTemplateValue(bool newValue) {
    isTemplate = newValue;
    notifyListeners();
  }

  Future<void> toggleTemplateStatus(String userId) async {
    final oldStatus = isTemplate;
    isTemplate = !isTemplate;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('mealPlans')
          .doc(id)
          .update({'isTemplate': isTemplate});
    } catch (error) {
      _setTemplateValue(oldStatus);
    }
  }
}

class MealPlans with ChangeNotifier {
  List<MealPlan> _mealPlans = [];

  MealPlans();

  List<MealPlan> get mealPlans {
    return [..._mealPlans];
  }

  List<MealPlan> get templateMealPlans {
    return _mealPlans.where((plan) => plan.isTemplate ?? () => null).toList();
  }

  List<MealPlan> mealPlansForADay(String day) {
    return _mealPlans
        .where((plan) => plan.dayOfWeek == day ?? () => null)
        .toList();
  }

  MealPlan findByDayAndType(String day, String type) {
    return _mealPlans.firstWhere(
        (plan) =>
            plan.dayOfWeek == day.toLowerCase() &&
            plan.typeOfMeal == type.toLowerCase(),
        orElse: () => null);
  }

  MealPlan findById(String id) {
    return _mealPlans.firstWhere((plan) => plan.id == id);
  }

  Future<void> fetchAndSetMealPlans(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('mealPlans')
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;

      if (extractedData == null) {
        return;
      }
      final List<MealPlan> loadedPlans = [];
      extractedData.forEach((plan) {
        var plansData = plan.data();
        loadedPlans.add(
          MealPlan(
            id: plan.id,
            userId: plansData['userId'],
            dayOfWeek: plansData['dayOfWeek'],
            typeOfMeal: plansData['typeOfMeal'],
            isTemplate: plansData['isTemplate'],
            mealItems: new List<String>.from(plansData['mealItems']),
            createdAt: DateTime.now(),
            //DateTime.fromMicrosecondsSinceEpoch(plansData['createdAt']),
          ),
        );
      });
      _mealPlans = loadedPlans;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addMealPlan(MealPlan planInput, String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('mealPlans')
          .add({
        'userId': userId,
        'dayOfWeek': planInput.dayOfWeek.toLowerCase(),
        'typeOfMeal': planInput.typeOfMeal.toLowerCase(),
        'mealItems': FieldValue.arrayUnion(planInput.mealItems),
        'isTemplate': false,
        'createdAt': Timestamp.fromDate(planInput.createdAt),
      });
      final newPlan = MealPlan(
        id: response.id,
        userId: userId,
        dayOfWeek: planInput.dayOfWeek,
        typeOfMeal: planInput.typeOfMeal,
        mealItems: planInput.mealItems,
        isTemplate: false,
        createdAt: planInput.createdAt,
      );
      _mealPlans.add(newPlan);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateMealPlan(
      String id, MealPlan planInput, String userId) async {
    final planIndex = _mealPlans.indexWhere((plan) => plan.id == id);
    if (planIndex >= 0) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('mealPlans')
          .doc(id)
          .set({
        'userId': userId,
        'dayOfWeek': planInput.dayOfWeek.toLowerCase(),
        'typeOfMeal': planInput.typeOfMeal.toLowerCase(),
        'mealItems': FieldValue.arrayUnion(planInput.mealItems),
        'isTemplate': planInput.isTemplate,
        'createdAt': Timestamp.fromDate(planInput.createdAt),
      }, SetOptions(merge: false));
      _mealPlans[planIndex] = planInput;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteMealPlan(String id, String userId) async {
    final existingPlanIndex = _mealPlans.indexWhere((plan) => plan.id == id);
    var existingPlan = _mealPlans[existingPlanIndex];
    _mealPlans.removeAt(existingPlanIndex);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('mealPlans')
          .doc(id)
          .delete();
      existingPlan = null;
    } catch (error) {
      _mealPlans.insert(existingPlanIndex, existingPlan);
      notifyListeners();
      throw HttpException('Could not delete the meal plan.');
    }
  }
}
