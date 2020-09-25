import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/requests.dart';
import '../../../providers/connected_clinician.dart';

import '../../../widgets/users/app_drawer.dart';
import '../../../widgets/users/connect_with_clinician/no_connection_or_request.dart';
import '../../../widgets/users/connect_with_clinician/has_sent_request.dart';
import '../../../widgets/users/connect_with_clinician/the_connected_clinician.dart';

class ConnectWithClinicianScreen extends StatefulWidget {
  static const routeName = '/connect-with-clinician';
  @override
  _ConnectWithClinicianScreenState createState() =>
      _ConnectWithClinicianScreenState();
}

class _ConnectWithClinicianScreenState
    extends State<ConnectWithClinicianScreen> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final patientId = Provider.of<Auth>(context, listen: false).userId;
      _fetchRequests(patientId);
      _fetchConnectedClinician(patientId);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _fetchRequests(String patientId) async {
    await Provider.of<Requests>(context).fetchAndSetMyRequest(patientId);
  }

  void _fetchConnectedClinician(String patientId) async {
    await Provider.of<ConnectedClinician>(context)
        .fetchAndSetClinician(patientId);
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<Requests>(context).requests;
    final clinicianExists =
        Provider.of<ConnectedClinician>(context).clinicianExists;
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect with your clinician'),
      ),
      drawer: AppDrawer(),
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (clinicianExists)
              ? TheConnectedClinician()
              : (request.isEmpty)
                  ? NoConnectionOrRequest()
                  : ChangeNotifierProvider.value(
                      value: request[0],
                      child: HasSentRequest(),
                    ),
    );
  }
}
