import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glare_photographer_app/components/DefaultButton.dart';
import 'package:glare_photographer_app/components/no_account_text.dart';
import 'package:glare_photographer_app/screens/sign_in/sign_in_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {


  @override
  Widget build(BuildContext context) {



    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/bgcoversignin.jpg"),fit: BoxFit.cover)
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        child: Center(
          child:  Column(
            children: [

              Expanded(
                  flex: 8,
                  child: Container(
                    child: Center(
                      child:kIsWeb==true? Container(
                        width: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color:  darkglass,

                        ),

                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 100),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [


                            ForgotPassForm(),
                          ],
                        ),
                      ):Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color:  darkglass,

                        ),

                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 100),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [


                            ForgotPassForm(),
                          ],
                        ),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child:  Container(

                      decoration: BoxDecoration(color: Colors.white),
                      child:Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/icons/whatsapp.png"),size: 20,)),
                              IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/icons/youtube.png"))),
                              IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/icons/twitter.png"),size: 20,)),
                              IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/icons/insta.png"),size: 20,)),


                            ],),


                          Text("www.glare.social",style: getstyle(14, FontWeight.normal, Colors.black),)
                        ],
                      )
                  )),

            ],
          ),

        ),
      ),
    );


  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;
  bool progress=false;
  final emailController = TextEditingController();
  RegExp regExp=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    setState(() {
      progress=false;
    });
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    if(progress==false){
      return Form(

      key: _formKey,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            "Reset Password",
            style: getstyle(24 , FontWeight.w600, Colors.white),
          ),
          SizedBox(height: 10,),
          Text(
            "Please enter your email and we will send \nyou a link to return to your account",
            textAlign: TextAlign.center,
            style:getstyle(13, FontWeight.normal, Colors.white),
          ),

          SizedBox(height: 20),
          buildEmailFormField(),
          SizedBox(height: 30),


          Row(
            children: [
              Expanded(
                flex: 5,
                child: DefaultButton(
                  text: "Reset",
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      resetPassword(context);
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
                    text: "Sign In",
                    press: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignInScreen()), (route) => false);
                    }),
              )
            ],
          ),

          SizedBox(height: 30),
          NoAccountText(),
        ],
      ),);
    }else{
      return Container(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: c1,),
            )

          ],
        ),
      );
    }


  }

  resetPassword(BuildContext context) async {
    setState(() {
      progress=true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
      setState(() {
        progress=false;
      });
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: light,
          content: Text(
            'Password Reset Email has been sent !',
            style: getstyle(13,FontWeight.normal,Colors.green)
          ),
        ),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          progress=false;
        });
        Scaffold.of(context).showSnackBar(
          SnackBar(
            elevation: 50,
            backgroundColor: Colors.black,
            content: Text(
              'No user found for that email.',
              style: TextStyle(fontSize: 13.0,color: Colors.white),
            ),
          ),
        );
      }
    }
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

}
