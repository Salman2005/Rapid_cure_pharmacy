// ignore_for_file: avoid_print, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants/constants.dart';
import '../Utils/app_utils.dart';
import 'doctors_screen.dart';

class MyDoctorsScreen extends StatefulWidget {
  const MyDoctorsScreen({Key? key}) : super(key: key);

  @override
  State<MyDoctorsScreen> createState() => _MyDoctorsScreenState();
}

class _MyDoctorsScreenState extends State<MyDoctorsScreen> {
  List<Doctor> doctorsList = [];
  @override
  void initState() {
    getUser();

    super.initState();
  }

  String? email;
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString("currentUserEmail");
    FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }

      email = value.data()!["email"];

      setState(() {});
      getDocs();
    });

    setState(() {});
  }

  getDocs() async {
    doctorsList = await getDoctors();
  }

  Future<List<Doctor>> getDoctors() async {
    List<Doctor> doctors = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(email!.toLowerCase())
          .collection('Doctors')
          .get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        Doctor doctor = Doctor(
          name: data['name'],
          email: data['email'],
          education: data['education'],
          phoneNumber: data['phoneNumber'],
          specialization: data['specialization'],
          long: data['long'],
          lat: data['lat'],
        );
        doctors.add(doctor);
        if (kDebugMode) {
          print(doctor);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    setState(() {});
    return doctors;
  }

  var utils = AppUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Text(
                    "My Doctors",
                    style: utils.mediumTitleBoldTextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.medication,
                size: 50,
                color: Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              for (int i = 0; i < doctorsList.length; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        doctorsList[i].email.toString(),
                        style: utils.largeHeadingTextStyle(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name",
                            style: utils.mediumTitleTextStyle(),
                          ),
                          Text(
                            doctorsList[i].name.toString(),
                            style: utils.mediumTitleTextStyle(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Specialization",
                            style: utils.mediumTitleTextStyle(),
                          ),
                          Text(
                            doctorsList[i].specialization.toString(),
                            style: utils.mediumTitleTextStyle(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Education",
                            style: utils.mediumTitleTextStyle(),
                          ),
                          Text(
                            doctorsList[i].education.toString(),
                            style: utils.mediumTitleTextStyle(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Phone Number",
                            style: utils.mediumTitleTextStyle(),
                          ),
                          Text(
                            doctorsList[i].phoneNumber.toString(),
                            style: utils.mediumTitleTextStyle(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      utils.bigButton(
                        width: MediaQuery.of(context).size.width * 0.9,
                        text: "Call",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        textColor: Colors.white,
                        borderRadius: 10.0,
                        onTap: () async {
                          await makePhoneCall(
                              doctorsList[i].phoneNumber.toString());
                          final FirebaseFirestore firestore =
                              FirebaseFirestore.instance;

                          try {
                            await firestore
                                .collection("users")
                                .doc(email!.toLowerCase().toString())
                                .collection('Doctors')
                                .doc()
                                .set(doctorsList[i].toMap())
                                .then((value) => print("DONE"));
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}
