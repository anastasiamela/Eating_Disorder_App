import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  // String _token;
  // DateTime _expiryDate;
  String _userId;
  //Timer _authTimer;

  User _user;

  User get user => _user;

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

  signup(String email, String password) async {
    UserCredential authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((error) => print(error.code));

    if (authResult != null) {
      // UserUpdateInfo updateInfo = UserUpdateInfo();
      // updateInfo.displayName = user.displayName;

      User firebaseUser = authResult.user;

      if (firebaseUser != null) {
        // await firebaseUser.updateProfile(updateInfo);

        // await firebaseUser.reload();

        print("Sign up: $firebaseUser");

        User currentUser = FirebaseAuth.instance.currentUser;
        _user = currentUser;
        _userId = currentUser.uid;
        notifyListeners();
      }
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

  // String get token {
  //   if (_expiryDate != null &&
  //       _expiryDate.isAfter(DateTime.now()) &&
  //       _token != null) {
  //     return _token;
  //   }
  //   return null;
  // }

  String get userId {
    return _userId;
  }

  // Future<void> _authenticate(
  //     String email, String password, String urlSegment) async {
  //   final url =
  //       'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBzWYgB4mlFbQ5A24N920xXDuo60SH8DLo';
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode(
  //         {
  //           'email': email,
  //           'password': password,
  //           'returnSecureToken': true,
  //         },
  //       ),
  //     );
  //     print(response);

  //     final responseData = json.decode(response.body);
  //     print(responseData);
  //     if (responseData['error'] != null) {
  //       throw HttpException(responseData['error']['message']);
  //     }
  //     _token = responseData['idToken'];
  //     _userId = responseData['localId'];
  //     _expiryDate = DateTime.now().add(
  //       Duration(
  //         seconds: int.parse(
  //           responseData['expiresIn'],
  //         ),
  //       ),
  //     );
  //     _autoLogout();
  //     notifyListeners();
  //     final prefs = await SharedPreferences.getInstance();
  //     final userData = json.encode(
  //       {
  //         'token': _token,
  //         'userId': _userId,
  //         'expiryDate': _expiryDate.toIso8601String(),
  //       },
  //     );
  //     prefs.setString('userData', userData);
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  // Future<void> signup(String email, String password) async {
  //   print('1');
  //   return _authenticate(email, password, 'signUp');
  // }

  // Future<void> login(String email, String password) async {
  //   return _authenticate(email, password, 'signInWithPassword');
  // }

  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //     return false;
  //   }
  //   final extractedUserData =
  //       json.decode(prefs.getString('userData')) as Map<String, Object>;
  //   final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

  //   if (expiryDate.isBefore(DateTime.now())) {
  //     return false;
  //   }
  //   _token = extractedUserData['token'];
  //   _userId = extractedUserData['userId'];
  //   _expiryDate = expiryDate;
  //   notifyListeners();
  //   _autoLogout();
  //   return true;
  // }

  // Future<void> logout() async {
  //   _token = null;
  //   _userId = null;
  //   _expiryDate = null;
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //     _authTimer = null;
  //   }
  //   notifyListeners();
  //   final prefs = await SharedPreferences.getInstance();
  //   // prefs.remove('userData');
  //   prefs.clear();
  // }

  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //   }
  //   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }
}
