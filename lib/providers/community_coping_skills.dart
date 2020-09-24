import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityCopingSkill with ChangeNotifier {
  final String id;
  final String description;
  List<String> likedBy;
  int likes;
  final DateTime date;

  bool isLiked;

  CommunityCopingSkill({
    @required this.id,
    @required this.description,
    @required this.likedBy,
    @required this.likes,
    @required this.date,
    this.isLiked = false,
  });

  void _setLike(String userId, bool newValue) {
    isLiked = newValue;
    if (newValue) {
      likes++;
      likedBy.add(userId);
    } else {
      likes--;
      likedBy.remove(userId);
    }
    notifyListeners();
  }

  Future<void> likeToggleCommunityCopingSkill(String userId) async {
    if (isLiked) {
      try {
        await FirebaseFirestore.instance
            .collection('communityCopingSkills')
            .doc(id)
            .update({
          'likedBy': FieldValue.arrayRemove([userId]),
          'likes': FieldValue.increment(-1),
        });
        _setLike(userId, false);
      } catch (error) {
        print(error);
      }
    } else {
      try {
        await FirebaseFirestore.instance
            .collection('communityCopingSkills')
            .doc(id)
            .update({
          'likedBy': FieldValue.arrayUnion([userId]),
          'likes': FieldValue.increment(1),
        });
        _setLike(userId, true);
      } catch (error) {
        print(error);
      }
    }
  }
}

class CommunityCopingSkills with ChangeNotifier {
  List<CommunityCopingSkill> _skills = [];

  CommunityCopingSkills();

  List<CommunityCopingSkill> get skills {
    return [..._skills];
  }

  List<CommunityCopingSkill> get skillsSortedByLikes {
    List<CommunityCopingSkill> list = [..._skills];
    list.sort(
      (a, b) => b.likes.compareTo(a.likes),
    );
    return [...list];
  }

  CommunityCopingSkill findById(String id) {
    return _skills.firstWhere((skill) => skill.id == id);
  }

  Future<void> fetchAndSetCommunityCopingSkills(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('communityCopingSkills')
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;
      if (extractedData == null) {
        return;
      }
      final List<CommunityCopingSkill> loadedSkills = [];
      extractedData.forEach((skill) {
        var skillData = skill.data();
        bool isLiked = false;
        List<String> likedByLoaded =
            new List<String>.from(skillData['likedBy']);
        if (likedByLoaded.contains(userId)) {
          isLiked = true;
        } else {
          isLiked = false;
        }
        loadedSkills.add(
          CommunityCopingSkill(
              id: skill.id,
              date: DateTime.parse(skillData['date']),
              likedBy: likedByLoaded,
              likes: skillData['likes'],
              description: skillData['description'],
              isLiked: isLiked),
        );
      });
      _skills = loadedSkills;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addCommunityCopingSkill(CommunityCopingSkill skillInput) async {
    final timestamp = DateTime.now();
    try {
      final response = await FirebaseFirestore.instance
          .collection('communityCopingSkills')
          .add({
        'date': skillInput.date.toIso8601String(),
        'likedBy': FieldValue.arrayUnion(skillInput.likedBy),
        'likes': skillInput.likes,
        'description': skillInput.description,
        'createdAt': Timestamp.fromDate(timestamp),
      });
      final newSkill = CommunityCopingSkill(
        id: response.id,
        likedBy: skillInput.likedBy,
        date: skillInput.date,
        likes: skillInput.likes,
        description: skillInput.description,
      );
      _skills.insert(0, newSkill);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateLikesCommunityCopingSkill(String id, String userId) async {
    final skillIndex = _skills.indexWhere((skill) => skill.id == id);
    if (skillIndex >= 0) {
      await FirebaseFirestore.instance
          .collection('communtyCopingSkills')
          .doc(id)
          .update({
        'likedBy': FieldValue.arrayUnion([userId]),
        'likes': FieldValue.increment(1),
      });
      skills[skillIndex].likes++;
      skills[skillIndex].likedBy.add(userId);
      notifyListeners();
    } else {
      print('...');
    }
  }
}
