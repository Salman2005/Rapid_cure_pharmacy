// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, depend_on_referenced_packages, deprecated_member_use, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:rapid_cure_pharmacy/AuthController/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants/constants.dart';
import '../Utils/app_utils.dart';
import 'doctors_screen.dart';

class HomeScreen extends StatefulWidget {
  var location;
  HomeScreen(this.location, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  List<Doctor> doctorsList = [];

  @override
  void initState() {
    getUser();
    getDocs();
    super.initState();
  }

  getDocs() async {
    doctorsList = await getDoctors();
  }

  Future<List<Doctor>> getDoctors() async {
    List<Doctor> doctors = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Doctors').get();
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
    return doctors;
  }

  String? name;
  String? email;
  String? pic;
  String? date;
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
      name = value.data()!["name"];
      email = value.data()!["email"];
      DateTime now = DateTime.fromMillisecondsSinceEpoch(value.data()!["date"]);
      date = DateFormat('dd MMMM, yyyy').format(now);
      if (kDebugMode) {
        print(name);
      }
      if (kDebugMode) {
        print(email);
      }
      setState(() {});
    });
    FirebaseFirestore.instance
        .collection("profilePictures")
        .doc(user)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      pic = value.data()!["profilePicture"];

      setState(() {});
    });
  }

  var utils = AppUtils();
  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: blueColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 100),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                pic != null
                    ? Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              pic!,
                            ),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      )
                    : Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: blueColor,
                          ),
                        ),
                      ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? "Loading..",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      email ?? "Loading..",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            ListTile(
              onTap: () async {
                await Navigator.pushNamed(context, profileScreenRoute);
                getUser();
              },
              visualDensity: const VisualDensity(vertical: -3),
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: Text(
                'My Account',
                style: utils.smallTitleTextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, myDoctorsScreenRoute);
              },
              visualDensity: const VisualDensity(vertical: -3),
              leading: const Icon(
                Icons.medication,
                color: Colors.black,
              ),
              title: Text(
                'Doctors',
                style: utils.smallTitleTextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, termsAndConditionsScreenRoute);
              },
              visualDensity: const VisualDensity(vertical: -3),
              leading: const Icon(
                Icons.sticky_note_2_sharp,
                color: Colors.black,
              ),
              title: Text(
                'Terms And Conditions',
                style: utils.smallTitleTextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, aboutScreenRoute);
              },
              visualDensity: const VisualDensity(vertical: -3),
              leading: const Icon(
                Icons.info,
                color: Colors.black,
              ),
              title: Text(
                'About',
                style: utils.smallTitleTextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, contactUsScreenRoute);
              },
              visualDensity: const VisualDensity(vertical: -3),
              leading: const Icon(
                Icons.chat,
                color: Colors.black,
              ),
              title: Text(
                'Contact Us',
                style: utils.smallTitleTextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            ListTile(
              onTap: () {
                logoutDialogBox();
              },
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              visualDensity: const VisualDensity(vertical: -3),
              title: Text(
                'Log Out',
                style: utils.smallHeadingTextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: widget.location,
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: widget.location,
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                        size: 50.0,
                        color: Colors.black,
                      ),
                    ),
                    for (int i = 0; i < doctorsList.length; i++)
                      if (doctorsList[i].lat != null &&
                          doctorsList[i].long != null)
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point:
                              LatLng(doctorsList[i].lat!, doctorsList[i].long!),
                          builder: (ctx) => GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: const EdgeInsets.all(20.0),
                                    height: 270,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Name",
                                              style:
                                                  utils.mediumTitleTextStyle(),
                                            ),
                                            Text(
                                              doctorsList[i].name.toString(),
                                              style:
                                                  utils.mediumTitleTextStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Specialization",
                                              style:
                                                  utils.mediumTitleTextStyle(),
                                            ),
                                            Text(
                                              doctorsList[i]
                                                  .specialization
                                                  .toString(),
                                              style:
                                                  utils.mediumTitleTextStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Education",
                                              style:
                                                  utils.mediumTitleTextStyle(),
                                            ),
                                            Text(
                                              doctorsList[i]
                                                  .education
                                                  .toString(),
                                              style:
                                                  utils.mediumTitleTextStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Phone Number",
                                              style:
                                                  utils.mediumTitleTextStyle(),
                                            ),
                                            Text(
                                              doctorsList[i]
                                                  .phoneNumber
                                                  .toString(),
                                              style:
                                                  utils.mediumTitleTextStyle(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        utils.bigButton(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          text: "Call",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          textColor: Colors.white,
                                          borderRadius: 10.0,
                                          onTap: () async {
                                            await makePhoneCall(doctorsList[i]
                                                .phoneNumber
                                                .toString());
                                            final FirebaseFirestore firestore =
                                                FirebaseFirestore.instance;

                                            try {
                                              await firestore
                                                  .collection("users")
                                                  .doc(email!
                                                      .toLowerCase()
                                                      .toString())
                                                  .collection('Doctors')
                                                  .doc()
                                                  .set(doctorsList[i].toMap())
                                                  .then(
                                                      (value) => print("DONE"));
                                            } catch (e) {
                                              if (kDebugMode) {
                                                print(e.toString());
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.location_on,
                              size: 50.0,
                              color: Colors.red,
                            ),
                          ),
                        ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _handleMenuButtonPressed();
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Map",
                        style: utils.largeHeadingTextStyle(),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
    setState(() {});
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  logoutDialogBox() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      transitionDuration: const Duration(seconds: 0),
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SizedBox(
                height: 190,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                        ),
                        color: blueColor,
                      ),
                      child: Center(
                        child: Text(
                          "Log Out?",
                          style: utils.mediumTitleBoldTextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Are you sure you want to logout?",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 120,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Center(
                                child: Text(
                                  "Decline",
                                  style: utils.smallTitleTextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey[300],
                          ),
                          GestureDetector(
                            onTap: () {
                              Authentication().signOut(context);
                            },
                            child: Container(
                              width: 120,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Center(
                                child: Text(
                                  "Logout",
                                  style: utils.smallHeadingTextStyle(
                                    color: blueColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
