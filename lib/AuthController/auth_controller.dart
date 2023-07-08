import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/constants.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  Future signUp({String? email, String? password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      return null;
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
      return e.message;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }

      return e.message;
    } on SocketException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }

      return e.message;
    }
  }

  Future signIn({String? email, String? password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      return null;
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());

      return e.message;
    } on PlatformException catch (e) {
      EasyLoading.showError(e.message.toString());

      return e.message;
    } on SocketException catch (e) {
      EasyLoading.showError(e.message.toString());

      return e.message;
    }
  }

  Future signOut(context) async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, loginScreenRoute, (route) => false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  deleteAccount(context) async {
    try {
      await user.delete();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString("currentUserEmail");

      FirebaseFirestore.instance
          .collection('users')
          .doc(email!.toLowerCase())
          .collection("products")
          .get()
          .then((querySnapshot) {
        for (var document in querySnapshot.docs) {
          document.reference.delete();
        }
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(email.toLowerCase())
          .collection("sales")
          .get()
          .then((querySnapshot) {
        for (var document in querySnapshot.docs) {
          document.reference.delete();
        }
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(email.toLowerCase())
          .collection("notifications")
          .get()
          .then((querySnapshot) {
        for (var document in querySnapshot.docs) {
          document.reference.delete();
        }
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(email.toLowerCase())
          .delete();

      EasyLoading.showSuccess("Account Deleted Successfully");

      Navigator.pushNamedAndRemoveUntil(
          context, loginScreenRoute, (route) => false);
      prefs.clear();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  late EmailAuth auth;

  Future enterEmailAuth(email) async {
    try {
      _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
      return e.message;
    } on PlatformException catch (e) {
      EasyLoading.showError(e.message.toString());

      if (kDebugMode) {
        print(e.message);
      }
      return e.message;
    } on SocketException catch (e) {
      EasyLoading.showError(e.message.toString());

      if (kDebugMode) {
        print(e.message);
      }
      return e.message;
    }
  }
}
