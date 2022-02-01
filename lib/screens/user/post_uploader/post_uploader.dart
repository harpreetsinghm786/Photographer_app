import 'dart:io';

import 'package:flutter/material.dart';

import 'Components/body.dart';


class Post_uploader extends StatelessWidget {
  Post_uploader({Key? key,required this.image}) : super(key: key);
  File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(image: image,) ,
    );
  }
}
