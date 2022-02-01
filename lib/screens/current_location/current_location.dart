import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glare_photographer_app/helper/profile_data.dart';


import '../../size_config.dart';
import 'components/body.dart';

class CurrentLocation extends StatefulWidget {
  Profile profile;

  CurrentLocation({Key? key,required this.profile}) : super(key: key);

  @override
  _CurrentLocationState createState() => _CurrentLocationState(profile: this.profile);
}

class _CurrentLocationState extends State<CurrentLocation> {
  Profile profile;
  _CurrentLocationState({required this.profile});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark));
    return Scaffold(

    body: Body(profile: this.profile,),
    );
  }
}
