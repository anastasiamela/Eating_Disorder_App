import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/http_exception.dart';

class Thought with ChangeNotifier {
  final String id;
  final String userId;
  final DateTime date;
  final String thought;
  bool isFavorite;
  final bool isBackLog;
  final DateTime dateTimeOfLog;
  Timestamp createdAt;

  Thought({
    @required this.id,
    @required this.userId,
    @required this.date,
    @required this.thought,
    @required this.isBackLog,
    @required this.dateTimeOfLog,
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
          .collection('patients')
          .doc(userId)
          .collection('thoughts')
          .doc(id)
          .update({'isFavorite': isFavorite});
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}

class Thoughts with ChangeNotifier {
  List<Thought> _thoughts = [];

  Thoughts();

  List<Thought> get thoughts {
    return [..._thoughts];
  }

  List<Thought> get thoughtsSorted {
    _thoughts.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return [..._thoughts];
  }

  List<Thought> get favoriteThoughts {
    return _thoughts
        .where((thought) => thought.isFavorite ?? () => null)
        .toList();
  }

  List<Thought> get backLogThoughts {
    return _thoughts.where((thought) => thought.isBackLog ?? () => null).toList();
  }

  Thought findById(String id) {
    return _thoughts.firstWhere((thought) => thought.id == id);
  }

  Future<void> fetchAndSetThoughts(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('thoughts')
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;

      if (extractedData == null) {
        return;
      }
      final List<Thought> loadedThoughts = [];
      extractedData.forEach((thought) {
        var thoughtData = thought.data();
        loadedThoughts.add(
          Thought(
            id: thought.id,
            userId: thoughtData['userId'],
            date: DateTime.parse(thoughtData['date']),
            thought: thoughtData['thought'],
            isFavorite: thoughtData['isFavorite'],
            isBackLog: thoughtData['isBackLog'],
            dateTimeOfLog: DateTime.parse(thoughtData['dateTimeOfLog']),
          ),
        );
      });
      _thoughts = loadedThoughts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addThought(Thought thoughtInput, String userId) async {
    final timestamp = DateTime.now();
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('thoughts')
          .add({
        'userId': userId,
        'date': thoughtInput.date.toIso8601String(),
        'thought': thoughtInput.thought,
        'isFavorite': false,
        'createdAt': Timestamp.fromDate(thoughtInput.date),
        'isBackLog': thoughtInput.isBackLog,
        'dateTimeOfLog': timestamp.toIso8601String()
      });
      final newThought = Thought(
        id: response.id,
        userId: userId,
        date: thoughtInput.date,
        thought: thoughtInput.thought,
        isBackLog: thoughtInput.isBackLog,
        dateTimeOfLog: timestamp,
      );
      _thoughts.add(newThought);
      //_thoughts.insert(0, newThought); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteThought(String id, String userId) async {
    final existingThoughtIndex =
        _thoughts.indexWhere((thought) => thought.id == id);
    var existingThought = _thoughts[existingThoughtIndex];
    _thoughts.removeAt(existingThoughtIndex);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .collection('thoughts')
          .doc(id)
          .delete();
      existingThought = null;
    } catch (error) {
      _thoughts.insert(existingThoughtIndex, existingThought);
      notifyListeners();
      throw HttpException('Could not delete the thought log.');
    }
  }

  Future<void> fetchAndSetThoughtsOfPatients(List<String> patients) async {
    try {
      final response = await FirebaseFirestore.instance
          .collectionGroup('thoughts')
          .where('userId', whereIn: patients)
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;

      if (extractedData == null) {
        return;
      }
      final List<Thought> loadedThoughts = [];
      extractedData.forEach((thought) {
        var thoughtData = thought.data();
        loadedThoughts.add(
          Thought(
            id: thought.id,
            userId: thoughtData['userId'],
            date: DateTime.parse(thoughtData['date']),
            thought: thoughtData['thought'],
            isFavorite: thoughtData['isFavorite'],
            isBackLog: thoughtData['isBackLog'],
            dateTimeOfLog: DateTime.parse(thoughtData['dateTimeOfLog']),
          ),
        );
      });
      _thoughts = loadedThoughts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
