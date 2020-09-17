import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _userRole;

  User _user;

  User get user => _user;

  String get userRole => _userRole;

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
        notifyListeners();
      }
    }
  }

  signup(String email, String password, String role) async {
    try {
      UserCredential authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((error) => print(error.code));

      if (authResult != null) {
        User firebaseUser = authResult.user;
        if (firebaseUser != null) {
          print("Sign up: $firebaseUser");
          User currentUser = FirebaseAuth.instance.currentUser;
          _user = currentUser;
          _userId = currentUser.uid;
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_userId)
                .set({
              'role': role,
            });
            _userRole = '';
          } catch (error) {
            print(error);
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

  String get userId {
    return _userId;
  }
}
