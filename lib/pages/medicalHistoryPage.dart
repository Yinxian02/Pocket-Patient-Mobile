import 'package:flutter/material.dart';
import '../resources/colours.dart';
import '../resources/components.dart';
import '../resources/fonts.dart';
import '../resources/globals.dart';

// MEDICAL HISTORY PAGE
class MedicalHistoryPage extends StatelessWidget {
  const MedicalHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> medHis = {'20/4/23': 'Broke a leg, fixed leg zsdfgasdfsdfasfdssdf', '30/4/23': 'died'};
    return Scaffold(
      body: Stack(
        children: [
          Container(
              padding: const EdgeInsets.all(50.0),
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        medicalHistoryTitle,
                        SizedBox(height: 30,),
                      ] + showMedicalHistory(patientData!.getMedHisSummary(), context, false)))),
          homeIcon,
        ],
      ),
    );
  }
}

class MedicalHistoryTitle extends StatelessWidget {
  const MedicalHistoryTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ColouredBox(
        height: 80,
        width: MediaQuery.of(context).size.width,
        padding: 10.0,
        colour: superLightCyan,
        radius: 10.0,
        outerPadding: 0.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(style: smallTitle, child: Text('My Medical History')),
            DefaultTextStyle(style: smallInfo, child: Text('Last Updated: 25/4/2023')),
          ],
        ));
  }

}