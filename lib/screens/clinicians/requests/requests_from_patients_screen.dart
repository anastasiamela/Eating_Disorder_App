import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/requests.dart';
//import '../../../providers/clinicians/patients_of_clinicians.dart';

import '../../../widgets/clinicians/app_drawer_clinicians.dart';
import '../../../widgets/clinicians/requests_from_patients/request_item.dart';

class RequestsFromPatientsScreen extends StatefulWidget {
  static const routeName = '/requests-from-patients';

  @override
  _RequestsFromPatientsScreenState createState() =>
      _RequestsFromPatientsScreenState();
}

class _RequestsFromPatientsScreenState
    extends State<RequestsFromPatientsScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final clinicianId = Provider.of<Auth>(context, listen: false).userId;
      Provider.of<Requests>(context)
          .fetchAndSetRequestsFromPatients(clinicianId)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<Requests>(context).requests;
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients\' Requests'),
      ),
      drawer: AppDrawerClinicians(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: requests[i],
                  child: RequestItem(),
                ),
              ),
            ),
    );
  }
}
