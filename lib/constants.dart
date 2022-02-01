import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xffe14627);

const c1=Color(0xff242424);
const c2=Color(0xffac011f);
const c3=Color(0xff5c103b);
const c4=Color(0xff78a6c8);
const c5=Color(0xffe9eef2);

//pastels
const p1=Color(0xffffdac1);
const p2=Color(0xffC7CEEA);
const p3=Color(0xffB5EAD7);
const p4=Color(0xffffeec1);
const p5=Color(0xffd6f6f4);
const p6=Color(0xffffd1be);

const kTextColor = Color(0xFF757575);
const textcolor = Color(0xFF444444);
const bodytextcolor=Color(0xff888880);
const finalgrey=Color(0xffc9c9c9);
const mapgrey=Color(0xffe3e3e3);
const light=Color(0xffefefef);
const darkglass=Color(0xA6000000);
const glass=Color(0x8B000000);
const kAnimationDuration = Duration(milliseconds: 200);

const defaultpadding= 20.0;
const defaultduration=Duration(seconds: 1);
const maxWidth=1440.0;

final headingStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: c1,
  height: 1.5,
);



//text style
TextStyle getstyle(double size,FontWeight w,Color c1){
  return GoogleFonts.poppins(fontSize: size,fontWeight: w,color: c1);
}


final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";