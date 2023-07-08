// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart';
import 'package:rapid_cure_pharmacy/Constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AuthController/firebase_uploads.dart';
import '../Utils/app_utils.dart';

class UploadProfilePictureScreen extends StatefulWidget {
  const UploadProfilePictureScreen({Key? key}) : super(key: key);

  @override
  State<UploadProfilePictureScreen> createState() =>
      _UploadProfilePictureScreenState();
}

class _UploadProfilePictureScreenState
    extends State<UploadProfilePictureScreen> {
  var utils = AppUtils();
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Upload Profile Picture",
                style: utils.largeLabelTextStyle(color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: () {
                dialogBox(context);
              },
              child: Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    color: blueColor,
                    shape: BoxShape.circle,
                  ),
                  child: task != null
                      ? Center(child: buildUploadStatus(task!))
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.upload,
                              color: Colors.black,
                              size: 25,
                            ),
                          ],
                        ))),
            ),
            Align(
              alignment: Alignment.center,
              child: utils.bigButton(
                  width: MediaQuery.of(context).size.width * 0.9,
                  text: "Upload",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  textColor: Colors.white,
                  borderRadius: 10.0,
                  onTap: () async {
                    Position currentPosition =
                        await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );
                    Navigator.pushNamed(context, homeScreenRoute,
                        arguments: LatLng(currentPosition.latitude,
                            currentPosition.longitude));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  var urlDownload = "N/A";

  Future uploadFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("currentUserEmail");
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
}

Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(2);
          return Text(
            percentage == "100.00" ? "Uploaded" : "$percentage%",
            style: TextStyle(
                color: Colors.white,
                fontSize: percentage == "100.00" ? 16 : 16,
                fontWeight: FontWeight.bold),
          );
        } else {
          return Container();
        }
      },
    );
