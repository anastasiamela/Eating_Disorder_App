import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/http_exception.dart';

class ConnectedClinician with ChangeNotifier {
  String _clinicianId;
  String _clinicianName;
  String _clinicianPhoto;
  String _clinicianEmail;
  Timestamp _connectionDate;
  bool _clinicianExists;

  String get clinicianName => _clinicianName;

  String get clinicianPhoto => _clinicianPhoto;

  String get clinicianEmail => _clinicianEmail;

  String get clinicianId => _clinicianId;

  Timestamp get connectionDate => _connectionDate;

  bool get clinicianExists => _clinicianExists;

  Future<void> fetchAndSetClinician(String patientId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('connectedClinician')
          .doc(patientId)
          .get();
      if (response.data() == null) {
        _clinicianExists = false;
        return;
      }
      _clinicianExists = true;
      _clinicianId = response.data()['clinicianId'];
      _clinicianName = response.data()['clinicianName'];
      _clinicianPhoto = response.data()['clinicianPhoto'];
      _clinicianEmail = response.data()['clinicianEmail'];
      _connectionDate =
         response.data()['createdAt'];
    } catch (error) {
      _clinicianExists = false;
      throw (error);
    }
  }

  Future<void> deleteConnectedClinician(String patientId) async { 
    try {
      await FirebaseFirestore.instance
          .collection('connectedClinician')
          .doc(patientId)
          .delete();
      _clinicianExists = false;
      _clinicianId = '';
      _clinicianName = '';
      _clinicianPhoto = '';
      _clinicianEmail = '';
      _connectionDate = new Timestamp(0, 0);
      notifyListeners();
    } catch (error) {
      throw HttpException('Could not delete the clinician.');
    }
  }
}
