import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../widgets/clinicians/app_drawer_clinicians.dart';
import '../widgets/users/app_drawer.dart';

import './users/first_screen_user.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final role = Provider.of<Auth>(context).userRole;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      drawer: (role == 'patient') ? AppDrawer() : AppDrawerClinicians(),
      body: (role == 'patient') ? FirstScreenUser() : Text('clinician'),
    );
  }
}
