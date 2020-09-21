import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/http_exception.dart';

class Request with ChangeNotifier {
  final String clinicianId;
  final String patientId;
  final String patientName;
  final String patientEmail;
  final String messageFromPatient;
  final DateTime date;

  Request({
    @required this.clinicianId,
    @required this.patientId,
    @required this.patientName,
    @required this.patientEmail,
    @required this.messageFromPatient,
    @required this.date,
  });
}

class Requests with ChangeNotifier {
  List<Request> _requests;

  Requests();

  List<Request> get requests {
    return [..._requests];
  }

  Request findById(String id) {
    return _requests.firstWhere((request) => request.patientId == id);
  }

  Future<void> fetchAndSetRequestsFromPatients(String clinicianId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('requests')
          .where('clinicianId', isEqualTo: clinicianId)
          .orderBy("createdAt", descending: true)
          .get();
      final extractedData = response.docs;

      if (extractedData == null) {
        return;
      }
      final List<Request> loadedRequests = [];
      extractedData.forEach((request) {
        var requestData = request.data();
        loadedRequests.add(
          Request(
            clinicianId: clinicianId,
            patientId: requestData['patientId'],
            patientName: requestData['patientName'],
            patientEmail: requestData['patientEmail'],
            messageFromPatient: requestData['messageFromPatient'],
            date: DateTime.parse(requestData['date']),
          ),
        );
      });
      _requests = loadedRequests;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetMyRequest(String patientId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('requests')
          .doc(patientId)
          .get();
      final extractedData = response.data();

      if (extractedData == null) {
        return;
      }
      final Request loadedRequest = Request(
        clinicianId: extractedData['clinicianId'],
        patientId: extractedData['patientId'],
        patientName: extractedData['patientName'],
        patientEmail: extractedData['patientEmail'],
        messageFromPatient: extractedData['messageFromPatient'],
        date: DateTime.parse(extractedData['date']),
      );
      _requests.add(loadedRequest);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> sendRequestToClinician(Request requestInput) async {
    final timestamp = DateTime.now();
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestInput.patientId)
          .set({
        'patientId': requestInput.patientId,
        'clinicianId': requestInput.clinicianId,
        'message': requestInput.messageFromPatient,
        'date': requestInput.date.toIso8601String(),
        'patientName': requestInput.patientName,
        'patientEmail': requestInput.patientEmail,
        'createdAt': Timestamp.fromDate(timestamp),
      });
      final Request newRequest = Request(
        clinicianId: requestInput.clinicianId,
        patientId: requestInput.patientId,
        patientName: requestInput.patientName,
        patientEmail: requestInput.patientEmail,
        messageFromPatient: requestInput.messageFromPatient,
        date: requestInput.date,
      );
      _requests.add(newRequest);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteRequestFromPatient(
      String clinicianId, String patientId) async {
    final existingRequestIndex =
        _requests.indexWhere((request) => request.patientId == patientId);
    var existingRequest = _requests[existingRequestIndex];
    _requests.removeAt(existingRequestIndex);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(patientId)
          .delete();
      existingRequest = null;
    } catch (error) {
      requests.insert(existingRequestIndex, existingRequest);
      notifyListeners();
      throw HttpException('Could not delete the patient.');
    }
  }

  Future<void> acceptRequestFromPatient(
      String clinicianId, String patientId) async {
    final timestamp = DateTime.now();
    final existingRequestIndex =
        _requests.indexWhere((request) => request.patientId == patientId);
    var existingRequest = _requests[existingRequestIndex];
    _requests.removeAt(existingRequestIndex);
    try {
      await FirebaseFirestore.instance
          .collection('connectedClinician')
          .doc(patientId)
          .set({
        'patientId': patientId,
        'clinicianId': clinicianId,
        'createdAt': Timestamp.fromDate(timestamp),
      });
      deleteRequestFromPatient(clinicianId, patientId);
      //then add the patient to my patients
      notifyListeners();
    } catch (error) {
      requests.insert(existingRequestIndex, existingRequest);
      notifyListeners();
      throw HttpException('Could not accept the request.');
    }
  }
}
