import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glare_photographer_app/components/DefaultButton.dart';
import 'package:glare_photographer_app/helper/profile_data.dart';
import 'package:glare_photographer_app/screens/complete_profile/complete_profile_screen.dart';
import '../../../constants.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? confirm_password;
  bool remember = false;
  final List<String?> errors = [];
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool progress = false;

  RegExp regExp=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.center,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                "Hello User",
                style: getstyle(24, FontWeight.w600, Colors.white),
              ),
              Text(
                "Enter Details to continue with Glare",
                style: getstyle(13, FontWeight.normal, Colors.white),
              ),
              SizedBox(height: 20),
              buildEmailFormField(),
              SizedBox(height: 20),
              buildPasswordFormField(),
              SizedBox(
                height: 20,
              ),
              buildConfirmPassFormField(),
              SizedBox(height: 30),
              Container(
                width: 200,
                child: DefaultButton(
                  text: "Continue",
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Registration();
                      ;
                      // registration();
                    }
                  },
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
        progress
            ? Container(
                child: Center(
                  child: Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white)),
                ),
              )
            : Container(),
      ],
    );
  }

  void Registration() async {
    setState(() {
      progress = true;
    });
    if (password == confirm_password) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);
        if (userCredential.user != null) {
          Profile profile = new Profile(
              email,
              userCredential.user!.uid,
              "null",
              "null",
              "null",
              "null",
              "null",
              "null",
              "null",
              "null",
              "null",
              "null",
              "null",
              "null",
          );
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CompleteProfileScreen(profile: profile)),
              (route) => false);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          setState(() {
            progress = false;
          });

          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 13.0, color: Colors.white),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            progress = false;
          });
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 13.0, color: Colors.white),
              ),
            ),
          );
        }
      }
    } else {
      print("Password and Confirm Password doesn't match");
      setState(() {
        progress = false;
      });
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "Password and Confirm Password doesn't match",
            style: TextStyle(fontSize: 13.0, color: Colors.white),
          ),
        ),
      );
    }
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
        obscureText: true,
        onSaved: (newValue) => password = newValue,
        controller: passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter Password';
          }
          return null;
        },
        style: TextStyle(color: kTextColor),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kTextColor),
          ),
          focusColor: c1,
          hintStyle: getstyle(13, FontWeight.normal, Colors.grey),
          alignLabelWithHint: true,
          hintText: "Password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.lock,
                color: Colors.white,
              )),
        ));
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        onSaved: (newValue) => email = newValue,
        controller: emailController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter Email';
          } else if (!regExp.hasMatch(value.toString())) {
            return 'Please Enter Valid Email';
          }
          return null;
        },
        style: getstyle(14, FontWeight.normal, Colors.white),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kTextColor),
          ),
          focusColor: c1,
          hintStyle: getstyle(13, FontWeight.normal, Colors.grey),
          alignLabelWithHint: true,
          hintText: "Email",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.email,
                color: Colors.white,
              )),
        ));
  }

  TextFormField buildConfirmPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirm_password = newValue,
      controller: confirmPasswordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter Password';
        }
        return null;
      },
      style: TextStyle(color: kTextColor),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kTextColor),
        ),
        focusColor: c1,
        hintStyle: getstyle(13, FontWeight.normal, Colors.grey),
        alignLabelWithHint: true,
        hintText: "Confirm Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.lock,
              color: Colors.white,
            )),
      ),
    );
  }
}
