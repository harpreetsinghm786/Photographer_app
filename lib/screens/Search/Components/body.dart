import 'package:flutter/material.dart';
import 'package:glare_photographer_app/screens/user/Map/maptab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../../constants.dart';


class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Text("Find Anywhere, Anytime",style: GoogleFonts.montserrat(color: textcolor,fontSize: 13,fontWeight: FontWeight.w500,),),
          SizedBox(height: 10,),
          FlatButton(
            padding: EdgeInsets.all(0),
              onPressed: () {

              Navigator.push(context, MaterialPageRoute(builder: (context)=>Maptab(type: 2, keyword: "")));
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: light,
                        blurRadius: 3,
                        spreadRadius: 3)
                  ],
                  color: Colors.white,
                  border: Border.all(
                      width: 0, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GradientText(
                      "I'm Flexible",
                      colors: [c1,c2, c2],
                      style:
                      TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.chevron_right),
                  ],

                ),
              ))
        ],
      )
    );
  }
}
