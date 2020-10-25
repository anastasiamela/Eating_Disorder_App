import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/http_exception.dart';

class Request with ChangeNotifier {
  final String clinicianId;
  final String patientId;
  final String patientName;
  final String patientEmail;
  final String patientPhoto;
  final String messageFromPatient;
  final DateTime date;

  Request({
    @required this.clinicianId,
    @required this.patientId,
    @required this.patientName,
    @required this.patientEmail,
    @required this.patientPhoto,
    @required this.messageFromPatient,
    @required this.date,
  });
}

class Requests with ChangeNotifier {
  List<Request> _requests = [];

  Requests();

  List<Request> get requests {
    return [..._requests];
  }

  Request findById(String id) {
    return _requests.firstWhere((request) => request.patientId == id);
  }

  int get requestsLength => _requests.length;

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
            patientPhoto: requestData['patientPhoto'],
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
        print('null');
        return;
      }
      final Request loadedRequest = Request(
        clinicianId: extractedData['clinicianId'],
        patientId: extractedData['patientId'],
        patientName: extractedData['patientName'],
        patientEmail: extractedData['patientEmail'],
        patientPhoto: extractedData['patientPhoto'],
        messageFromPatient: extractedData['messageFromPatient'],
        date: DateTime.parse(extractedData['date']),
      );
      _requests = [loadedRequest];
      print('2');
      print(loadedRequest.patientId);
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
        'messageFromPatient': requestInput.messageFromPatient,
        'date': requestInput.date.toIso8601String(),
        'patientName': requestInput.patientName,
        'patientEmail': requestInput.patientEmail,
        'patientPhoto': requestInput.patientPhoto,
        'createdAt': Timestamp.fromDate(timestamp),
      });
      final Request newRequest = Request(
        clinicianId: requestInput.clinicianId,
        patientId: requestInput.patientId,
        patientName: requestInput.patientName,
        patientEmail: requestInput.patientEmail,
        patientPhoto: requestInput.patientPhoto,
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

  Future<void> deleteRequestFromPatient(String patientId) async {
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
      throw HttpException('Could not delete the request.');
    }
  }

  Future<void> acceptRequestFromPatient({
    String clinicianId,
    String patientId,
    String patientName,
    String patientEmail,
    String patientPhoto,
    String clinicianEmail,
    String clinicianName,
    String clinicianPhoto,
  }) async {
    final timestamp = DateTime.now();
    try {
      await FirebaseFirestore.instance
          .collection('connectedClinician')
          .doc(patientId)
          .set({
        'patientId': patientId,
        'clinicianId': clinicianId,
        'clinicianName': clinicianName,
        'clinicianEmail': clinicianEmail,
        'clinicianPhoto': clinicianPhoto,
        'patientName': patientName,
        'patientEmail': patientEmail,
        'patientPhoto': patientPhoto,
        'createdAt': Timestamp.fromDate(timestamp),
      });
    } catch (error) {
      throw HttpException('Could not accept the request.');
    }
  }
}
