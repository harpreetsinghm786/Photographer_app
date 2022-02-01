import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glare_photographer_app/screens/sign_in/sign_in_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../constants.dart';

class Dashboard extends StatefulWidget {
  Dashboard();


  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  _DashboardState();
 // final gsignin=GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 7,
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.camera,color: Colors.black,),
              //Image.asset("assets/icons/Bookfillicon.png",width: 30,fit: BoxFit.cover,color: Colors.black,),

              SizedBox(width: 5,),

              Text(
                "Glare",
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 5,
        //   titleTextStyle: TextStyle(color: kTextColor),
        //   systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        //       systemNavigationBarColor: Colors.white,
        //       statusBarColor: Colors.white,
        //       statusBarBrightness: Brightness.dark),
        //   title: FlatButton(
        //     onPressed: (){
        //       //Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
        //     },
        //     padding:  EdgeInsets.all(0),
        //     child: Container(
        //       padding: EdgeInsets.symmetric(
        //         horizontal: 10,
        //         vertical: 10,
        //       ),
        //       decoration: BoxDecoration(
        //           border: Border.all(width: 0, color: Colors.transparent),
        //           borderRadius: BorderRadius.circular(50),
        //           color: light),
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Icon(
        //             Icons.search,
        //             color: c2,
        //             size: 20,
        //           ),
        //           SizedBox(
        //             width: 5,
        //           ),
        //           Text(
        //             "What are you finding?",
        //             style: TextStyle(fontWeight: FontWeight.bold, color: c1),
        //           ),
        //           FlatButton(
        //             onPressed: () async {
        //               await FirebaseAuth.instance.signOut();
        //               //await gsignin.signOut();
        //               Navigator.pushAndRemoveUntil(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => SignInScreen(),
        //                   ),
        //                       (route) => false);
        //             },
        //
        //
        //
        //
        //             child: Text('Logout'),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        //
        //
        // ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    Container(
                      height: 350,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/c1.png"),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      height: 350,
                      color: Color(0x3E000000),
                    ),
                    Container(
                        height: 350,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Not Sure where to go? \n Perfect",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, //Color(0xFF1E4979),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                  textAlign: TextAlign.center),
                              SizedBox(
                                height: 10,
                              ),
                              FlatButton(
                                  onPressed: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 30),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 3,
                                            spreadRadius: 3)
                                      ],
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 0, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: GradientText(
                                      "I'm Flexible",
                                      colors: [c1, c2],
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ))
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "Explore nearby",
                        style: GoogleFonts.montserrat(
                            color: c1, fontWeight: FontWeight.w500, fontSize: 19),
                        textAlign: TextAlign.start,
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(20).copyWith(left: 10),
                    ),
                    // Container(
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       children: [
                    //         Column(
                    //           children: [
                    //             Buildcityitem(
                    //                 name: "New Delhi",
                    //                 image: "assets/images/c2.png"),
                    //             Buildcityitem(
                    //                 name: "New Delhi",
                    //                 image: "assets/images/c2.png"),
                    //           ],
                    //         ),
                    //         Column(
                    //           children: [
                    //             Buildcityitem(
                    //                 name: "New Delhi",
                    //                 image: "assets/images/c2.png"),
                    //             Buildcityitem(
                    //                 name: "New Delhi",
                    //                 image: "assets/images/c2.png"),
                    //           ],
                    //         ),
                    //         Column(
                    //           children: [
                    //             Buildcityitem(
                    //                 name: "New Delhi",
                    //                 image: "assets/images/c2.png"),
                    //             Buildcityitem(
                    //                 name: "New Delhi",
                    //                 image: "assets/images/c2.png"),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Text(
                        "Most Rated",
                        style: GoogleFonts.montserrat(
                            color: c1, fontWeight: FontWeight.w500, fontSize: 19),
                        textAlign: TextAlign.start,
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(20).copyWith(left: 10),
                    ),
                    // Container(
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     padding: EdgeInsets.only(left: 5),
                    //     child: Row(
                    //       children: [
                    //         Mostrated(
                    //             image: "assets/images/c1.png",
                    //             name: "Unique Style"),
                    //         Mostrated(
                    //             image: "assets/images/c1.png",
                    //             name: "Unique Style"),
                    //         Mostrated(
                    //             image: "assets/images/c1.png",
                    //             name: "Unique Style"),
                    //         Mostrated(
                    //             image: "assets/images/c1.png",
                    //             name: "Unique Style"),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      height: 400,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: c1,
                                border: Border.all(
                                    width: 0, color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15).copyWith(
                                    bottomRight: Radius.circular(0),
                                    bottomLeft: Radius.circular(0)),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Try For Free",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 19,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Find Expert photographers for your upcoming occasions and Parties for free.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                    SizedBox(height: 10,),
                                    FlatButton(
                                        onPressed: () {},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 30),
                                          decoration: BoxDecoration(

                                            color: Colors.white,
                                            border: Border.all(
                                                width: 0, color: Colors.transparent),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: GradientText(
                                            "Learn More",
                                            colors: [c1, c2],
                                            style:
                                            TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        )),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/c1.png"),
                                    fit: BoxFit.cover),
                                border: Border.all(
                                    width: 0, color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15).copyWith(
                                    topRight: Radius.circular(0),
                                    topLeft: Radius.circular(0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Text(
                        "Discover More",
                        style: GoogleFonts.montserrat(
                            color: c1, fontWeight: FontWeight.w500, fontSize: 19),
                        textAlign: TextAlign.start,
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(20).copyWith(left: 10),
                    ),
                    // Container(
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       children: [
                    //         DiscoverMore(image: "assets/images/c1.png", name: "Experiences", des: "Find unforgottable activities near you."),
                    //         DiscoverMore(image: "assets/images/c1.png", name: "Experiences", des: "Find unforgottable activities near you."),
                    //         DiscoverMore(image: "assets/images/c1.png", name: "Experiences", des: "Find unforgottable activities near you."),
                    //         DiscoverMore(image: "assets/images/c1.png", name: "Experiences", des: "Find unforgottable activities near you."),
                    //
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 20,),
                    Container(
                      width: double.infinity,
                      color: light,
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              "Stay Informed",
                              style: GoogleFonts.montserrat(
                                  color: c1, fontWeight: FontWeight.w500, fontSize: 19),
                              textAlign: TextAlign.start,
                            ),
                            width: double.infinity,
                            padding: EdgeInsets.all(20).copyWith(left: 10),
                          ),
                        ],
                      ),
                    )


                  ],
                ),
              ),
            ],
          ),
        ),
      );

  }
}
