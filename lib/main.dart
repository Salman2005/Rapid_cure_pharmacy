import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rapid_cure_pharmacy/MainScreens/contact_us_screen.dart';

import 'Authentication/forgot_password.dart';
import 'Authentication/login_screen.dart';
import 'Authentication/sign_up_screen.dart';
import 'Authentication/splash_screen.dart';
import 'Authentication/upload_profile_pic.dart';
import 'Constants/constants.dart';
import 'MainScreens/about_us_screen.dart';
import 'MainScreens/doctors_screen.dart';
import 'MainScreens/home_screen.dart';
import 'MainScreens/my_doctors_screen.dart';
import 'MainScreens/profile_screen.dart';
import 'MainScreens/terms_and_conditions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.white
    ..indicatorColor = blueColor
    ..textColor = Colors.white
    ..maskColor = blueColor.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: splashScreenRoute,
      builder: EasyLoading.init(),
      routes: {
        splashScreenRoute: (context) => const SplashScreen(),
        loginScreenRoute: (context) => const LoginScreen(),
        forgotPasswordScreenRoute: (context) => const ForgotPasswordScreen(),
        signUpScreenRoute: (context) => const SignUpScreen(),
        doctorsScreenRoute: (context) => const DoctorsScreen(),
        myDoctorsScreenRoute: (context) => const MyDoctorsScreen(),
        aboutScreenRoute: (context) => const AboutScreen(),
        profileScreenRoute: (context) => const ProfileScreen(),
        contactUsScreenRoute: (context) => const ContactUsScreen(),
        uploadProfilePictureScreenRoute: (context) =>
            const UploadProfilePictureScreen(),
        termsAndConditionsScreenRoute: (context) =>
            const TermsAndConditionsScreen(),
        homeScreenRoute: (context) {
          var i = ModalRoute.of(context)!.settings.arguments;
          return HomeScreen(i);
        },
      },
    );
  }
}
