import 'package:flutter/material.dart';

import '../Constants/constants.dart';
import '../Utils/app_utils.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  var utils = AppUtils();
  String? email;
  String? name;
  String? description;
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
                    "Contact Us",
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
                Icons.contact_mail,
                size: 150,
                color: Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              utils.textField(
                  validator: (val) =>
                      (!val.isNotEmpty || !val.toString().contains("@"))
                          ? "Please Enter A Valid Email"
                          : null,
                  obscureText: false,
                  onChange: (value) => email = value,
                  hintText: "Enter your Email",
                  labelText: "Email",
                  labelColor: blueColor),
              const SizedBox(
                height: 20,
              ),
              utils.textField(
                  obscureText: false,
                  onChange: (value) => name = value,
                  hintText: "Enter your Name",
                  labelText: "Name",
                  labelColor: blueColor),
              const SizedBox(
                height: 20,
              ),
              utils.textField(
                  obscureText: false,
                  onChange: (value) => description = value,
                  hintText: "Enter your email",
                  labelText: "Description",
                  labelColor: blueColor),
              const SizedBox(
                height: 100,
              ),
              utils.bigButton(
                width: MediaQuery.of(context).size.width * 0.9,
                text: "Send",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                textColor: Colors.white,
                borderRadius: 10.0,
                onTap: () {},
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
