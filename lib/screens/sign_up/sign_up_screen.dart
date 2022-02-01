import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../size_config.dart';
import 'components/body.dart';
import 'components/sign_up_form.dart';


class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark
    ));

    return Scaffold(

      resizeToAvoidBottomInset: false,

      body: Body(),
    );
  }
}