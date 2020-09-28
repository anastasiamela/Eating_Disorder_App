import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/http_exception.dart';

class PatientOfClinician with ChangeNotifier {
  final String patientId;
  final String patientName;
  final String patientPhoto;
  final String patientEmail;
  final Timestamp connectionDate;
  PatientOfClinician({
    @required this.patientId,
    @required this.patientName,
    @required this.patientPhoto,
    @required this.patientEmail,
    @required this.connectionDate,
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
    return list;
  }

  Future<void> fetchAndSetPatients(String clinicianId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('connectedClinician')
          .where('clinicianId', isEqualTo: clinicianId)
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
            connectionDate: patientData['createdAt'],
          ),
        );
      });
      _patients = loadedPatients;
      print(_patients);
      notifyListeners();
    } catch (error) {
      throw (error);
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
          .collection('connectedClinician')
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
