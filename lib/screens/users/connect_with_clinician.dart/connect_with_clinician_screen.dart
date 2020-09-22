import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';
import '../../../providers/requests.dart';

import '../../../widgets/users/app_drawer.dart';
import '../../../widgets/users/connect_with_clinician.dart/no_connection_or_request.dart';
import '../../../widgets/users/connect_with_clinician.dart/has_sent_request.dart';

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
      Provider.of<Requests>(context).fetchAndSetMyRequest(patientId).then((_) {
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
    final request = Provider.of<Requests>(context).requests;
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect with your clinician'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (request.isEmpty)
              ? NoConnectionOrRequest()
              : ChangeNotifierProvider.value(
                  value: request[0],
                  child: HasSentRequest(),
                ),
    );
  }
}
