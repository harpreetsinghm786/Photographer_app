import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../../size_config.dart';
import 'Components/body.dart';

class PhotgrapherDetails extends StatelessWidget {
  PhotgrapherDetails({Key? key,this.uid}) : super(key: key);

  String? uid;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark
    ));

    return Scaffold(
      body :Body(uid: this.uid,),
    );
  }
}
