import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glare_photographer_app/helper/profile_data.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'components/body.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";
  Profile profile;
  CompleteProfileScreen({required this.profile});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Body(profile: profile),
    );
  }
}