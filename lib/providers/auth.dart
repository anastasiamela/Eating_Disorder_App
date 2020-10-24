import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _userRole;
  String _userName;
  String _userPhoto;
  String _userEmail;
  int _remindersNumber; //for goals reminders

  User _user;

  User get user => _user;

  String get userRole => _userRole;

  String get userName => _userName;

  String get userPhoto => _userPhoto;

  String get userEmail => _userEmail;

  String get userId => _userId;

  int get remindersNumber => _remindersNumber;

  login(String email, String password) async {
    UserCredential authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error) => print(error.code));

    if (authResult != null) {
      User firebaseUser = authResult.user;

      if (firebaseUser != null) {
        print("Log In: $firebaseUser");
        _user = firebaseUser;
        _userId = firebaseUser.uid;
        _userEmail = email;
        try {
          final response = await FirebaseFirestore.instance
              .collection('patients')
              .doc(_userId)
              .get();
          if (response.data() == null) {
            try {
              final response = await FirebaseFirestore.instance
                  .collection('clinicians')
                  .doc(_userId)
                  .get();
              if (response.data() == null) {
                return;
              }
              _userRole = 'clinician';
              _userName = response.data()['displayName'];
              _userPhoto = response.data()['photo'];
              notifyListeners();
              return;
            } catch (error) {
              print(error);
            }
          }
          _userRole = 'patient';
          _userName = response.data()['displayName'];
          _userPhoto = response.data()['photo'];
          _remindersNumber = response.data()['remindersNumber'];
          notifyListeners();
          return;
        } catch (error) {
          print(error);
        }
      }
    }
  }

  signup(String email, String password, String role, String displayName,
      File imageFile) async {
    try {
      UserCredential authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((error) => print(error.code));

      if (authResult != null) {
        User firebaseUser = authResult.user;

        if (firebaseUser != null) {
          //print("Sign up: $firebaseUser");
          User currentUser = FirebaseAuth.instance.currentUser;
          _user = currentUser;
          _userId = currentUser.uid;
          _userName = displayName;
          _userEmail = email;

          StorageReference ref;
          if (role == 'patient') {
            ref = FirebaseStorage.instance
                .ref()
                .child('profile_images_patients')
                .child(_userId + '.jpg');
            await ref.putFile(imageFile).onComplete;
          } else {
            ref = FirebaseStorage.instance
                .ref()
                .child('profile_images_clinicians')
                .child(_userId + '.jpg');
            await ref.putFile(imageFile).onComplete;
          }
          final String url = await ref.getDownloadURL();
          _userPhoto = url;

          if (role == 'patient') {
            await FirebaseFirestore.instance
                .collection('patients')
                .doc(_userId)
                .set({
              'role': role,
              'displayName': displayName,
              'photo': url,
              'email': email,
              'remindersNumber': 6,
            }).catchError((error) => print(error.code));
            _userRole = role;
          } else {
            await FirebaseFirestore.instance
                .collection('clinicians')
                .doc(_userId)
                .set({
              'role': role,
              'displayName': displayName,
              'photo': url,
              'email': email
            }).catchError((error) => print(error.code));
            _userRole = role;
          }
          notifyListeners();
        }
      }
    } catch (error) {
      print(error);
    }
  }

  signout() async {
    await FirebaseAuth.instance
        .signOut()
        .catchError((error) => print(error.code));
    _user = null;
    _userId = null;
    notifyListeners();
  }

  initializeCurrentUser() async {
    User firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      print(firebaseUser);
      _user = firebaseUser;
      _userId = firebaseUser.uid;
      notifyListeners();
    }
  }

  Future<void> setRemindersNumber(int number) async {
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .update({
        'remindersNumber': number,
      });
      _remindersNumber = number;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
