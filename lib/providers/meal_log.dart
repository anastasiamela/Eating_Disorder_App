import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealLog with ChangeNotifier {
  final String id;
  final String userId;
  DateTime date; //dateTimeOfMeal
  bool skip;
  final String feelingOverall;
  final String mealType;
  final String mealCompany;
  final String mealLocation;
  final String mealPhoto;
  final String mealDescription;
  final String mealPortion;
  final String thoughts;
  final String skippingReason;
  bool isFavorite;
  final bool isBackLog;
  final DateTime dateTimeOfLog;
  DateTime dateTimeOfLastUpdate;
  Timestamp createdAt;

  final List<String> behaviorsList;
  final List<String> feelingsList;

  MealLog({
    @required this.id,
    @required this.userId,
    @required this.date,
    @required this.skip,
    @required this.feelingOverall,
    @required this.mealType,
    @required this.mealCompany,
    @required this.mealLocation,
    @required this.mealPhoto,
    @required this.mealDescription,
    @required this.mealPortion,
    @required this.thoughts,
    @required this.skippingReason,
    this.isFavorite = false,
    @required this.isBackLog,
    @required this.dateTimeOfLog,
    this.dateTimeOfLastUpdate,
    @required this.behaviorsList,
    @required this.feelingsList,
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
          .collection('patients')
          .doc(userId)
          .collection('mealLogs')
          .doc(id)
          .update({'isFavorite': isFavorite});
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
