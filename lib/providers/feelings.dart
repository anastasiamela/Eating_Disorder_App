import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/http_exception.dart';

class Feeling with ChangeNotifier {
  final String id;
  final String userId;
  final String overallFeeling;
  final List<String> moods;
  final String thoughts;
  final DateTime date;
  bool isFavorite;
  Timestamp createdAt;

  Feeling({
    @required this.id,
    @required this.userId,
    @required this.overallFeeling,
    @required this.moods,
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
          .collection('feelings')
          .doc(id)
          .update({'isFavorite': isFavorite});
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}

class Feelings with ChangeNotifier {
  List<Feeling> _feelings = [];

  Feelings();

  List<Feeling> get feelingsSorted {
    _feelings.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return [..._feelings];
  }

  List<Feeling> get favoriteFeelings {
    return _feelings
        .where((feeling) => feeling.isFavorite ?? () => null)
        .toList();
  }

  Feeling findById(String id) {
    return _feelings.firstWhere((feeling) => feeling.id == id);
  }

  Future<void> fetchAndSetFeelings(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('feelings')
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;

      if (extractedData == null) {
        return;
      }
      final List<Feeling> loadedFeelings = [];
      extractedData.forEach((feeling) {
        var feelingData = feeling.data();
        loadedFeelings.add(
          Feeling(
            id: feeling.id,
            userId: feelingData['userId'],
            date: DateTime.parse(feelingData['date']),
            overallFeeling: feelingData['overallFeeling'],
            moods: feelingData['moods'],
            thoughts: feelingData['thoughts'],
            isFavorite: feelingData['isFavorite'],
          ),
        );
      });
      _feelings = loadedFeelings;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addFeeling(String overallFeelingInput,
      List<String> moodsInput, String thoughtsInput, String userId) async {
    final timestamp = DateTime.now();
    try {
      final response = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('feelings')
          .add({
        'userId': userId,
        'date': timestamp.toIso8601String(),
        'overallFeeling': overallFeelingInput,
        'moods': FieldValue.arrayUnion(moodsInput),
        'thoughts': thoughtsInput,
        'isFavorite': false,
        'createdAt': Timestamp.fromDate(timestamp),
      });
      final newFeeling = Feeling(
        id: response.id,
        userId: userId,
        date: timestamp,
        overallFeeling: overallFeelingInput,
        moods: moodsInput,
        thoughts: thoughtsInput,
      );
      _feelings.add(newFeeling);
      //_feelings.insert(0, newFeeling); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteFeeling(String id, String userId) async {
    final existingFeelingIndex =
        _feelings.indexWhere((feeling) => feeling.id == id);
    var existingFeeling = _feelings[existingFeelingIndex];
    _feelings.removeAt(existingFeelingIndex);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('feelings')
          .doc(id)
          .delete();
      existingFeeling = null;
    } catch (error) {
      _feelings.insert(existingFeelingIndex, existingFeeling);
      notifyListeners();
      throw HttpException('Could not delete the feeling log.');
    }
  }
}
