import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../size_config.dart';
import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,

      body: Body(),

    );
  }
}

