// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:rapid_cure_pharmacy/Constants/constants.dart';
import 'package:rapid_cure_pharmacy/Utils/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AuthController/firebase_uploads.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  UploadTask? task;
  File? file;
  var urlDownload = "N/A";
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Text(
                  "Profile",
                  style: utils.largeHeadingTextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 50,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          pic != null
              ? GestureDetector(
                  onTap: () {
                    dialogBox(context);
                  },
                  child: Container(
                    width: 120.0,
                    height: 120.0,
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
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    dialogBox(context);
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: blueColor,
                      ),
                    ),
                  ),
                ),
          const SizedBox(
            height: 30,
          ),
          Text(
            name ?? "Loading..",
            style: const TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    blueColor.withOpacity(0.8),
                    greenColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                email ?? "Loading...",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    blueColor.withOpacity(0.8),
                    greenColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                date ?? "Loading...",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  dialogBox(context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Center(child: Text('Choose your option')),
          content: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    pickImageFromCamera(context);
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 25,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pickImageFromGallery(context);
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const Center(
                      child: Icon(Icons.photo),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  pickImageFromGallery(context) async {
    final imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    file = File(imageFile!.path);
    if (kDebugMode) {
      print("This is the path of file ============$file");
    }
    if (file != null) {
      EasyLoading.show(status: "Loading..");
      uploadFile();
      EasyLoading.dismiss();
    }
    Navigator.pop(context);
    setState(() {});
  }

  pickImageFromCamera(context) async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.camera);

    file = File(imageFile!.path);
    if (file != null) {
      EasyLoading.show(status: "Loading..");
      uploadFile();
      EasyLoading.dismiss();
    }
    Navigator.pop(context);
    setState(() {});
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseUploads.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
    if (kDebugMode) {
      print("Url == == ===  == $urlDownload");
    }
    FirebaseFirestore.instance.collection("profilePictures").doc(email).set({
      "profilePicture": urlDownload,
    });
    getUser();
    setState(() {});
  }
}
