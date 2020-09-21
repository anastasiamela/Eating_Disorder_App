import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Clinician with ChangeNotifier {
  final String clinicianId;
  final String clinicianName;
  final String clinicianPhoto;
  bool sendedRequest;

  Clinician({
    @required this.clinicianId,
    @required this.clinicianName,
    @required this.clinicianPhoto,
    this.sendedRequest = false,
  });
}

class Clinicians with ChangeNotifier {
  List<Clinician> _clinicians;

  Clinicians();

  List<Clinician> get clinicians {
    return [..._clinicians];
  }

  Clinician findById(String id) {
    return _clinicians.firstWhere((clinician) => clinician.clinicianId == id);
  }

  Future<void> fetchAndSetClinicians() async {
    try {
      final response =
          await FirebaseFirestore.instance.collection('clinicians').get();
      final extractedData = response.docs;

      if (extractedData == null) {
        return;
      }
      final List<Clinician> loadedClinicians = [];
      extractedData.forEach((clinician) {
        var clinicianData = clinician.data();
        loadedClinicians.add(
          Clinician(
            clinicianId: clinician.id,
            clinicianName: clinicianData['clinicianName'],
            clinicianPhoto: clinicianData['clinicianPhoto'],
          ),
        );
      });
      _clinicians = loadedClinicians;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
