import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_mobile_app/pages/hospitalVisitDetails.dart';
import 'package:patient_mobile_app/resources/globals.dart';
import 'package:patient_mobile_app/resources/objects.dart';
import '../resources/colours.dart';
import '../resources/fonts.dart';
import '../resources/components.dart';
import 'package:file_picker/file_picker.dart';

class EditHospitalVisitPage extends StatefulWidget {
  const EditHospitalVisitPage({super.key, required this.data});
  final HealthcareHistoryDataEntry data;

  @override
  State<StatefulWidget> createState() => _EditHospitalVisitPageState(data: data);

}
class _EditHospitalVisitPageState extends State<EditHospitalVisitPage> {

  _EditHospitalVisitPageState({required this.data});

  final HealthcareHistoryDataEntry data;

  bool addToMh = true;
  String dropdownValue = 'GP Consultation';
  DateTime admissionDate = DateTime.now();
  DateTime dischargeDate = DateTime.now();
  TextEditingController summaryController = TextEditingController();
  TextEditingController consultantController = TextEditingController();
  late Future<String?> _filePathFuture;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    _filePathFuture = Future.value('');
    addToMh = data.addToMedicalHistory;
    dropdownValue = data.visitType;
    admissionDate = DateTime.parse(data.admissionDate);
    dischargeDate = DateTime.parse(data.dischargeDate);
    summaryController.text = data.summary;
    consultantController.text = data.consultant;
  }

  void updateAdmissionDate(DateTime newDate) {
    admissionDate = newDate;
  }

  void updateDischargeDate(DateTime newDate) {
    dischargeDate = newDate;
  }

  DateTime getAdmissionDate() {
    return admissionDate;
  }

  DateTime getDischargeDate() {
    return dischargeDate;
  }

  void addToLetterUrls() {
    setState(() {
      _filePathFuture = _openFilePicker();
    });
  }

  Future<String?> _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      print('result:$result');
      if (result != null) {
        return result.files.single.path!;
      }
    } catch (e) {
      print('Error while picking the file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget checkBox = Checkbox(
      value: addToMh,
      onChanged: (bool? value) {
        setState(() {
          addToMh = value!;
        });
      },
    );
    Widget dropDown = DropdownButton<String>(
        focusColor: lighterGrey,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        value: dropdownValue,
        isExpanded: true,
        items: [
          DropdownMenuItem(
              value: 'GP Consultation',
              child: Text('GP Consultation')),
          DropdownMenuItem(
              value: 'Hospital Clinic',
              child: Text('Hospital Clinic')),
          DropdownMenuItem(
              value: 'Hospital Admission',
              child: Text('Hospital Admission'))
        ],
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
        });

    return Scaffold(
        body: Stack(
            children: [
              TitlePageFormat(
                  children: [BackButtonBlue(),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children:
                        addDateField(
                            'Date of Admission', getAdmissionDate,
                            updateAdmissionDate) +
                            addDateField(
                                'Date Discharged', getDischargeDate,
                                updateDischargeDate) +
                            addVisitText(
                                'Discharge Summary', summaryController,
                                'Summary', 80) +
                            addVisitText(
                                'Consultant', consultantController,
                                'Consultant', 40) +
                            addDropDown(dropDown) +
                            [
                              Flexible(
                                  flex: 5,
                                  fit: FlexFit.loose,
                                  child: SizedBox(height: 20,)),
                              Flexible(
                                  flex: 10,
                                  fit: FlexFit.loose,
                                  child:
                                  Row(children: [
                                    Flexible(
                                        fit: FlexFit.tight,
                                        flex: 1,
                                        child: SizedBox(width: 5,)),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        flex: 10,
                                        child: Container(
                                            width: 50,
                                            child: requiredField('Discharge Letter', requiredStr)
                                        )
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        flex: 15,
                                        child: Container(
                                            height: 100,
                                            width: 250,
                                            child: Column(
                                              children: [
                                                Flexible(
                                                    fit: FlexFit.loose,
                                                    flex: 7,
                                                    child: Container(
                                                        width: 250,
                                                        constraints: BoxConstraints(
                                                            maxHeight: 40),
                                                        child: ElevatedButton
                                                            .icon(
                                                          icon: Icon(Icons
                                                              .upload),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                top: 3,
                                                                bottom: 3),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10.0),
                                                              side: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            backgroundColor: lighterGrey,
                                                            foregroundColor: Colors
                                                                .black,
                                                          ),
                                                          onPressed: addToLetterUrls,
                                                          label: Text(
                                                            'upload attachment',
                                                            textAlign: TextAlign
                                                                .center,),
                                                        ))
                                                ),
                                                Flexible(child: SizedBox(
                                                  height: 5,)),
                                                Flexible(
                                                  flex: 6,
                                                  child: isVisible ? Container(
                                                    height: 20,
                                                    child: data.letterUrl == null ? const Text( '')
                                                        : getUploadedFilePath(data.letterUrl)
                                                  ) : const Text('')
                                                ),
                                                Flexible(
                                                    flex: 5,
                                                    fit: FlexFit.loose,
                                                    child: Container(
                                                        height: 40,
                                                        width: 250,
                                                        child: FutureBuilder<
                                                            String?>(
                                                          future: _filePathFuture,
                                                          builder: (
                                                              context,
                                                              snapshot) {
                                                            if (snapshot.hasData) {
                                                              print(snapshot.data);
                                                              if (snapshot.data !='') {
                                                                letterFilePath = snapshot.data!;
                                                              }
                                                              print('letterfilepath: $letterFilePath');
                                                              isVisible = false;
                                                              return getUploadedFilePath(letterFilePath);
                                                            } else
                                                            if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  'Error: ${snapshot
                                                                      .error}');
                                                            } else {
                                                              return CircularProgressIndicator();
                                                            }
                                                          },
                                                        )))
                                              ],
                                            )
                                        )
                                    ),
                                  ])
                              ),
                            ] +
                            addToMedHistCheck(checkBox) +
                            [SizedBox(height: 10,),
                              SizedBox(height: 20,),
                              LongButton(word: 'Update Entry', onPress: () {
                                  HealthcareHistoryDataEntry newEntry =
                                  HealthcareHistoryDataEntry(
                                      id: data.id,
                                      admissionDate: admissionDate.date
                                          .toString(),
                                      dischargeDate: dischargeDate.date
                                          .toString(),
                                      consultant: consultantController.text,
                                      visitType: dropdownValue,
                                      summary: summaryController.text,
                                      addToMedicalHistory: addToMh);
                                  print('filePath: ');
                                  editHospHistory(
                                      letterFilePath, newEntry);
                                  Navigator.pop(context);
                                }),
                              SizedBox(height: 50,)
                            ]
                      // generateVisitDetail('Type of Visit', data.visitType) +
                    )
                  ]),
              homeIcon,
              const ProfileLogo(),
            ]));
  }
}

class AddVisitDetailsText extends StatelessWidget {
  const AddVisitDetailsText({super.key, required this.title,  required this.controller, required this.hint, required this.height});

  final String title;
  final TextEditingController controller;
  final String hint;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: SizedBox(width: 5,)),
      Flexible(
          fit: FlexFit.tight,
          flex: 10,
          child: Container(
              width: 50,
              child: requiredField(title, requiredStr)
          )
      ),
      Flexible(
          fit: FlexFit.tight,
          flex:15,
          child: Container(
            width: 250,
            child: TextFormField(
              maxLines: 50,
              controller: controller,
              decoration: InputDecoration(
                  fillColor: lighterGrey,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  hintText: hint,
                  hintStyle: TextStyle(color: bgGrey),
                  constraints: BoxConstraints(
                      maxHeight: height
                  ),
                  contentPadding: EdgeInsets.only(left: 10.0)
              ),
            ),
          )),
    ]);
  }
}

List<Widget> addVisitText(String title, TextEditingController controller, String hint, double height) {
  return [
    Flexible(
        flex: 5,
        fit: FlexFit.loose,
        child: SizedBox(height: 20,)),
    Flexible(
        flex: 1,
        fit: FlexFit.loose,
        child: DefaultTextStyle(style: smallInfo,
            child: AddVisitDetailsText(title: title, controller: controller, hint: hint, height: height,), softWrap: true)),
  ];
}

List<Widget> addToMedHistCheck(Widget checkBox) {
  return [
    Flexible(
        flex: 1,
        fit: FlexFit.loose,
        child:
        Row(children: [
          Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: SizedBox(width: 5,)),
          Flexible(
              fit: FlexFit.loose,
              flex: 15,
              child: Container(
                  width: 250,
                  child: requiredField('Added to my medical history', requiredStr)
              )
          ),
          Flexible(
              fit: FlexFit.loose,
              flex:5,
              child: Container(
                  width: 20,
                  child: checkBox
              )
          )
        ]))];
}

List<Widget> addDropDown(Widget dropDown) {
  return [
    Flexible(
        flex: 5,
        fit: FlexFit.loose,
        child: SizedBox(height: 20,)),
    Flexible(
        flex: 1,
        fit: FlexFit.loose,
        child:
        Row(children: [
          Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: SizedBox(width: 5,)),
          Flexible(
              fit: FlexFit.loose,
              flex: 10,
              child: Container(
                  width: 250,
                  child: requiredField('Type of Visit', requiredStr)
              )
          ),
          Flexible(
              fit: FlexFit.loose,
              flex:15,
              child: Container(
                // padding: EdgeInsets.only(left: 38),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0) //
                    ),
                    color: lighterGrey,
                  ),
                  constraints: BoxConstraints(maxHeight: 40),
                  padding: EdgeInsets.only(left: 10.0),
                  width: 250,
                  child: dropDown
              )
          )
        ]))];
}

List<Widget> addDateField(String title, ValueGetter<DateTime> getDate, ValueSetter<DateTime> setDate) {
  return [
    Flexible(
        flex: 5,
        fit: FlexFit.loose,
        child: SizedBox(height: 20,)),
    Flexible(
        flex: 1,
        fit: FlexFit.loose,
        child:
        Row(children: [
          Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: SizedBox(width: 5,)),
          Flexible(
              fit: FlexFit.loose,
              flex: 10,
              child:
              requiredField(title, requiredStr)
          ),
          Flexible(
              fit: FlexFit.loose,
              flex:15,
              child: Container(
                  constraints: BoxConstraints(maxHeight: 60),
                  padding: EdgeInsets.zero,
                  width: 250,
                  child: DateTimeFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: lighterGrey,
                      suffixIcon: Icon(Icons.edit_calendar),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    onDateSelected: (DateTime value) {
                      setDate(value);
                    },
                    dateFormat: DateFormat.yMd(),
                    initialValue: getDate(),
                    mode: DateTimeFieldPickerMode.date,
                  ))
          )
        ]))];
}