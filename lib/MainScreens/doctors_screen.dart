import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Constants/constants.dart';
import '../Utils/app_utils.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  var retypePasswordController = TextEditingController();
  var utils = AppUtils();
  final formKey = GlobalKey<FormState>();
  String? email;
  String? name;
  String? phoneNumber;
  String? specialisation;
  String? education;
  double? lat;
  double? long;

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      "assets/logo.png",
                      scale: 8,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Add Doctor",
                        style: utils.largeLabelTextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    utils.textField(
                        validator: (val) =>
                            (!val.isNotEmpty || !val.toString().contains("@"))
                                ? "Please Enter A Valid Email"
                                : null,
                        onChange: (value) => email = value,
                        hintText: "Please Enter your email",
                        obscureText: false,
                        labelText: "Email",
                        labelColor: blueColor),
                    const SizedBox(
                      height: 15,
                    ),
                    utils.textField(
                        validator: (val) => (!val.isNotEmpty)
                            ? "Please Enter A Valid Name"
                            : null,
                        onChange: (value) => name = value,
                        hintText: "Please Enter your name",
                        obscureText: false,
                        labelText: "Name",
                        labelColor: blueColor),
                    const SizedBox(
                      height: 15,
                    ),
                    utils.textField(
                        validator: (val) => (!val.isNotEmpty)
                            ? "Please Enter A Education"
                            : null,
                        onChange: (value) => education = value,
                        hintText: "Please Enter Education",
                        obscureText: false,
                        labelText: "Education",
                        labelColor: blueColor),
                    const SizedBox(
                      height: 15,
                    ),
                    utils.textField(
                        validator: (val) => (!val.isNotEmpty)
                            ? "Please Enter A Specialisation"
                            : null,
                        onChange: (value) => specialisation = value,
                        hintText: "Please Enter Specialisation",
                        obscureText: false,
                        labelText: "Specialisation",
                        labelColor: blueColor),
                    const SizedBox(
                      height: 15,
                    ),
                    utils.textField(
                        validator: (val) =>
                            (!val.isNotEmpty) ? "Please Enter Latitude" : null,
                        onChange: (value) => lat = double.parse(value),
                        hintText: "Please Enter Latitude",
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        labelText: "Latitude",
                        labelColor: blueColor),
                    const SizedBox(
                      height: 15,
                    ),
                    utils.textField(
                        validator: (val) =>
                            (!val.isNotEmpty) ? "Please Enter Longitude" : null,
                        onChange: (value) => long = double.parse(value),
                        hintText: "Please Enter Longitude",
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        labelText: "Longitude",
                        labelColor: blueColor),
                    const SizedBox(
                      height: 15,
                    ),
                    utils.textField(
                        validator: (val) => (!val.isNotEmpty)
                            ? "Please Enter Phone Number"
                            : null,
                        onChange: (value) => phoneNumber = value,
                        keyboardType: TextInputType.number,
                        hintText: "Please Enter Phone",
                        obscureText: false,
                        labelText: "Phone Number",
                        labelColor: blueColor),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: utils.bigButton(
                        width: MediaQuery.of(context).size.width * 0.9,
                        text: "Add",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        textColor: Colors.white,
                        borderRadius: 10.0,
                        onTap: () async {
                          Doctor newDoctor = Doctor(
                            lat: lat,
                            long: long,
                            name: name,
                            email: email,
                            education: education,
                            phoneNumber: phoneNumber,
                            specialization: specialisation,
                          );
                          // 31.474271949010465, 74.31747140430694
                          await addDoctor(newDoctor);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // 74.33289740171016

  Future<void> addDoctor(Doctor doctor) async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    EasyLoading.show(status: "Loading...");
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('Doctors')
          .doc()
          .set(doctor.toMap())
          .then((value) => EasyLoading.showSuccess("Doctor Added"));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    EasyLoading.dismiss();
  }
}

class Doctor {
  String? name;
  String? email;
  String? education;
  String? phoneNumber;
  String? specialization;
  double? lat;
  double? long;

  Doctor(
      {required this.name,
      required this.email,
      required this.education,
      required this.lat,
      required this.long,
      required this.phoneNumber,
      required this.specialization});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'education': education,
      'phoneNumber': phoneNumber,
      'specialization': specialization,
      'lat': lat,
      'long': long,
    };
  }
}
