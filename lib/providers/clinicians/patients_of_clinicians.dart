import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/http_exception.dart';

class PatientOfClinician with ChangeNotifier {
  final String patientId;
  final String patientName;
  final String patientPhoto;
  final String patientEmail;
  PatientOfClinician({
    @required this.patientId,
    @required this.patientName,
    @required this.patientPhoto,
    @required this.patientEmail,
  });
}

class PatientsOfClinician with ChangeNotifier {
  List<PatientOfClinician> _patients = [];

  PatientsOfClinician();

  List<PatientOfClinician> get patients {
    return [..._patients];
  }

  PatientOfClinician findPatientById(String id) {
    return _patients.firstWhere((patient) => patient.patientId == id);
  }

  List<String> getPatientsIds() {
    List<String> list = [];
    _patients.forEach((patient) => list.add(patient.patientId));
    print('2');
    print(list);
    return list;
  }

  Future<void> fetchAndSetPatients(String clinicianId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('clinicians')
          .doc(clinicianId)
          .collection('myPatients')
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;

      if (extractedData == null) {
        return;
      }
      final List<PatientOfClinician> loadedPatients = [];
      extractedData.forEach((patient) {
        var patientData = patient.data();
        loadedPatients.add(
          PatientOfClinician(
            patientId: patientData['patientId'],
            patientName: patientData['patientName'],
            patientPhoto: patientData['patientPhoto'],
            patientEmail: patientData['patientEmail'],
          ),
        );
      });
      _patients = loadedPatients;
      print('1');
      print(_patients);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addPatient(
      PatientOfClinician patientInput, String clinicianId) async {
    final timestamp = DateTime.now();
    try {
      await FirebaseFirestore.instance
          .collection('clinicians')
          .doc(clinicianId)
          .collection('myPatients')
          .doc(patientInput.patientId)
          .set({
        'patientId': patientInput.patientId,
        'patientName': patientInput.patientName,
        'patientPhoto': patientInput.patientPhoto,
        'createdAt': Timestamp.fromDate(timestamp),
        'patientEmail': patientInput.patientEmail,
      });
      final newPatient = PatientOfClinician(
        patientId: patientInput.patientId,
        patientName: patientInput.patientName,
        patientPhoto: patientInput.patientPhoto,
        patientEmail: patientInput.patientEmail,
      );
      _patients.add(newPatient);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deletePatient(String id, String clinicianId) async {
    final existingPatientIndex =
        _patients.indexWhere((patient) => patient.patientId == id);
    var existingPatient = _patients[existingPatientIndex];
    _patients.removeAt(existingPatientIndex);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('clinicians')
          .doc(clinicianId)
          .collection('myPatients')
          .doc(id)
          .delete();
      existingPatient = null;
    } catch (error) {
      patients.insert(existingPatientIndex, existingPatient);
      notifyListeners();
      throw HttpException('Could not delete the patient.');
    }
  }
}
