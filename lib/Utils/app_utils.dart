import 'package:flutter/material.dart';

import '../Constants/constants.dart';

class AppUtils {
  largeLabelTextStyle({color}) {
    return TextStyle(
      color: color,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    );
  }

  mediumTitleBoldTextStyle({color}) {
    return TextStyle(
      fontSize: 16,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  smallHeadingTextStyle({color}) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );
  }

  largeHeadingTextStyle({color}) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  tileText(text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  smallLableTextStyle({color}) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
  }

  smallTitleTextStyle({color}) {
    return TextStyle(
      color: color,
      fontSize: 14,
    );
  }

  mediumTitleTextStyle({color}) {
    return TextStyle(
      fontSize: 15,
      color: color,
    );
  }

  bigButton(
      {width,
      onTap,
      borderWidth,
      borderRadius,
      text,
      textColor,
      fontSize,
      fontWeight}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          gradient: const LinearGradient(
            colors: [
              blueColor,
              greenColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            text.toString(),
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontSize: fontSize == null ? 13.0 : fontSize.toDouble(),
              fontWeight: fontWeight ?? FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  textField(
      {controller,
      hintText,
      width,
      keyboardType,
      fontSize,
      obscureText,
      labelText,
      labelColor,
      suffixIcon,
      validator,
      onChange}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
              color: labelColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            child: TextFormField(
              onChanged: onChange,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: Colors.white,
              ),
              validator: validator,
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                  suffixIcon: suffixIcon,
                  suffixIconColor: blueColor,
                  contentPadding: const EdgeInsets.only(top: 5, left: 15),
                  hintText: hintText,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: fontSize,
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: blueColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: blueColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: blueColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
