import 'package:flutter/material.dart';
import 'package:glare_photographer_app/screens/sign_up/sign_up_screen.dart';


import '../constants.dart';
import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don’t have an account? ",
          style: TextStyle(fontSize: 15),
        ),
        GestureDetector(
          onTap: () =>  Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new SignUpScreen(),
              )),
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 15,
                color: Colors.black,
            fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}