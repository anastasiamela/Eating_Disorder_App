import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/clinicians/patients_of_clinicians.dart';
import '../../../providers/auth.dart';

import '../../../widgets/clinicians/app_drawer_clinicians.dart';
import '../../../widgets/clinicians/overview/patient_item.dart';

class MyPatientsScreen extends StatelessWidget {
  static const routeName = '/my-patients';

  Future<void> _refreshScreen(BuildContext context, String clinicianId) async {
    await Provider.of<PatientsOfClinician>(context, listen: false)
        .fetchAndSetPatients(clinicianId);
  }

  @override
  Widget build(BuildContext context) {
    final clinicianId = Provider.of<Auth>(context, listen: false).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Patients'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _refreshScreen(context, clinicianId),
          ),
        ],
      ),
      drawer: AppDrawerClinicians(),
      body: FutureBuilder(
        future: _refreshScreen(context, clinicianId),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshScreen(context, clinicianId),
                    child: Consumer<PatientsOfClinician>(
                      builder: (ctx, patientsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: patientsData.patients.length,
                          itemBuilder: (_, i) => ChangeNotifierProvider.value(
                            value: patientsData.patients[i],
                            child: PatientItem()
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
