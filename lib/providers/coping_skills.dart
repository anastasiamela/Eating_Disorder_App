import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/http_exception.dart';

class CopingSkill with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final List<String> autoShowConditionsBehaviors;
  final List<String> autoShowConditionsFeelings;
  final String patientId;
  final String createdBy;
  final DateTime date;

  CopingSkill({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.autoShowConditionsBehaviors,
    @required this.autoShowConditionsFeelings,
    @required this.patientId,
    @required this.createdBy,
    @required this.date,
  });
}

class CopingSkills with ChangeNotifier {
  List<CopingSkill> _skills = [];

  CopingSkills();

  List<CopingSkill> get skills {
    return [..._skills];
  }

  CopingSkill findById(String id) {
    return _skills.firstWhere((skill) => skill.id == id);
  }

  Future<void> fetchAndSetCopingSkills(String patientId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .collection('copingSkils')
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;
      if (extractedData == null) {
        return;
      }
      final List<CopingSkill> loadedSkills = [];
      extractedData.forEach((skill) {
        var skillData = skill.data();
        loadedSkills.add(
          CopingSkill(
            id: skill.id,
            patientId: skillData['patientId'],
            createdBy: skillData['createdBy'],
            date: DateTime.parse(skillData['date']),
            autoShowConditionsBehaviors:
                new List<String>.from(skillData['autoShowConditionsBehaviors']),
            autoShowConditionsFeelings:
                new List<String>.from(skillData['autoShowConditionsFeelings']),
            name: skillData['name'],
            description: skillData['description'],
          ),
        );
      });
      _skills = loadedSkills;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addCopingSkill(CopingSkill skillInput) async {
    final timestamp = DateTime.now();
    try {
      final response = await FirebaseFirestore.instance
          .collection('patients')
          .doc(skillInput.patientId)
          .collection('copingSkills')
          .add({
            'patientId': skillInput.patientId,
            'createdBy': skillInput.createdBy,
            'date': skillInput.date.toIso8601String(),
            'autoShowConditionsBehaviors':
                FieldValue.arrayUnion(skillInput.autoShowConditionsBehaviors),
            'autoShowConditionsFeelings':
                FieldValue.arrayUnion(skillInput.autoShowConditionsFeelings),
            'name': skillInput.name,
            'description': skillInput.description,
            'createdAt': Timestamp.fromDate(timestamp),
      });
      final newSkill = CopingSkill(
        id: response.id,
        patientId: skillInput.patientId,
        createdBy: skillInput.createdBy,
        autoShowConditionsBehaviors: skillInput.autoShowConditionsBehaviors,
        autoShowConditionsFeelings: skillInput.autoShowConditionsFeelings,
        date: skillInput.date,
        name: skillInput.name,
        description: skillInput.description,
      );
      _skills.add(newSkill);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteCopingSkill(String id, String patientId) async {
    final existingSkillIndex =
        _skills.indexWhere((skill) => skill.id == id);
    var existingSkill = _skills[existingSkillIndex];
    _skills.removeAt(existingSkillIndex);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(patientId)
          .collection('copingSkills')
          .doc(id)
          .delete();
      existingSkill = null;
    } catch (error) {
      _skills.insert(existingSkillIndex, existingSkill);
      notifyListeners();
      throw HttpException('Could not delete the coping skill.');
    }
  }
}
