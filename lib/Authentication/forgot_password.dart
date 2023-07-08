import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../AuthController/auth_controller.dart';
import '../Constants/constants.dart';
import '../Utils/app_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var emailAddressController = TextEditingController();
  GlobalKey<FormState> globalFomKey = GlobalKey<FormState>();

  var utils = AppUtils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Form(
        key: globalFomKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                "assets/logo.png",
                scale: 8,
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Forgot Password?",
                          style: utils.largeLabelTextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Don't worry it happens! Enter your email we will send reset link on that email.",
                          style: utils.smallTitleTextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      utils.textField(
                          controller: emailAddressController,
                          hintText: "Enter your email",
                          obscureText: false,
                          validator: (val) =>
                              (!val.isNotEmpty || !val.toString().contains("@"))
                                  ? "Please Enter A Valid Email"
                                  : null,
                          labelText: "Email",
                          labelColor: blueColor),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: utils.bigButton(
                          onTap: () {
                            sendEmailForgotPassword();
                          },
                          width: MediaQuery.of(context).size.width * 0.9,
                          text: "Send",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          textColor: Colors.white,
                          borderRadius: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendEmailForgotPassword() {
    if (!globalFomKey.currentState!.validate()) return;
    globalFomKey.currentState!.save();

    Authentication().enterEmailAuth(emailAddressController.text).then((result) {
      if (kDebugMode) {
        print(result);
      }
      if (result == null) {
        EasyLoading.showSuccess("Password Reset Email Sent");
        Navigator.pushNamedAndRemoveUntil(
            context, loginScreenRoute, (route) => false);
      }
    });
  }
}
