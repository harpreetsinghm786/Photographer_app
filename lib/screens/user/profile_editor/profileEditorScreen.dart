import 'package:flutter/material.dart';

import 'Components/body.dart';

class ProfileEditorScreen extends StatelessWidget {
  String firstname,lastname,bio,website,image;

  ProfileEditorScreen({Key? key,required this.firstname,
  required this.lastname,
  required this.bio,
  required this.website,
  required this.image}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Body(firstname: firstname,lastname: lastname,website: website,bio: bio,image: image,),
    );
  }
}
