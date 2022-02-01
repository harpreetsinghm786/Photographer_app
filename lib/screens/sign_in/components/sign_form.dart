import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glare_photographer_app/components/DefaultButton.dart';
import 'package:glare_photographer_app/helper/keyboard.dart';
import 'package:glare_photographer_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:glare_photographer_app/screens/sign_up/sign_up_screen.dart';
import 'package:glare_photographer_app/screens/user/usermain.dart';
import '../../../constants.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool progress = false;
  RegExp regExp=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    if (progress == false) {
      return  Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/logo.png"),
                height: 100,
                color: Colors.white,
              ),


              SizedBox(
                height: 10,
              ),

              buildEmailFormField(),
              SizedBox(height: 20),
              buildPasswordFormField(),
              SizedBox(height: 20),
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen())),
                    child: Text(
                      "Forgot Password?",
                      style: getstyle(12, FontWeight.normal, Colors.white),
                    ),
                  )
                ],
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: DefaultButton(
                      text: "Login",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          KeyboardUtil.hideKeyboard(context);
                          userLogin();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 5,
                    child: DefaultButton(
                        text: "Sign Up",
                        press: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => new SignUpScreen(),
                              ));
                        }),
                  )
                ],
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SocialCard(
              //       icon: "assets/icons/google-icon.svg",
              //       press: ()  {
              //
              //         _signInwithGoogle(context);
              //       },
              //     ),
              //     SocialCard(
              //       icon: "assets/icons/facebook-2.svg",
              //       press: () {
              //
              //       },
              //     ),
              //     SocialCard(
              //       icon: "assets/icons/twitter.svg",
              //       press: () {},
              //     ),
              //   ],
              // ),
            ],
          ),
        );

    } else {
      return Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          ],
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
        style: getstyle(13, FontWeight.normal, Colors.white),
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

  userLogin() async {
    setState(() {
      progress = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);

      if (userCredential.user!.email != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UserMain()),
            (route) => false);



      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          progress = false;
        });
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 13.0, color: Colors.white),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        setState(() {
          progress = false;
        });
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 13.0, color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    setState(() {
      progress = false;
    });
    super.dispose();
  }

  // Future<void> _signInwithGoogle(BuildContext context) async {
  //   setState(() {
  //     progress = true;
  //   });
  //   try {
  //     final googleSignin = GoogleSignIn();
  //     final account = await googleSignin.signIn();
  //     if (account != null) {
  //       GoogleSignInAuthentication googleauth = await account.authentication;
  //
  //       if (googleauth.accessToken != null && googleauth.idToken != null) {
  //         final credential = GoogleAuthProvider.credential(
  //             idToken: googleauth.idToken, accessToken: googleauth.accessToken);
  //         final result =
  //             await FirebaseAuth.instance.signInWithCredential(credential);
  //         Profile profile = new Profile(
  //             result.user!.email,
  //             result.user!.uid,
  //             "null",
  //             "null",
  //             "null",
  //             "null",
  //             "null",
  //             "null",
  //             "null",
  //             "null",
  //             "null",
  //             "null");
  //
  //         if (await result.user.toString().isNotEmpty) {
  //           DocumentReference doc = FirebaseFirestore.instance
  //               .collection("Userdata")
  //               .doc(result.user!.uid);
  //
  //           doc.get().then((value) => {
  //                 if (value.exists)
  //                   {
  //                     Navigator.pushAndRemoveUntil(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => UserMain()),
  //                         (route) => false),
  //                   }
  //                 else
  //                   {
  //                     Navigator.pushAndRemoveUntil(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) =>
  //                                 CompleteProfileScreen(profile: profile)),
  //                         (route) => false),
  //                   }
  //               });
  //         }
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       progress = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.black,
  //         content: Text(
  //           e.toString(),
  //           style: TextStyle(fontSize: 13.0, color: Colors.white),
  //         ),
  //       ),
  //     );
  //   }
  // }
}
