import 'dart:async';
import 'package:flutter/material.dart';

import '../AuthController/auth_navigation_controller.dart';
import '../Constants/constants.dart';
import '../Utils/app_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var utils = AppUtils();
  @override
  void initState() {
    super.initState();
    splashNavigator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          scale: 4,
        ),
      ),
    );
  }

  splashNavigator() {
    Timer(const Duration(seconds: 3), () {
      AuthController().checkUserExistence(context);
    });
  }
}
