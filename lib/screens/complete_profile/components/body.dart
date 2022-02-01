import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glare_photographer_app/helper/profile_data.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../constants.dart';
import '../../../size_config.dart';
import 'complete_profile_form.dart';

class Body extends StatelessWidget {
  Profile profile;
  Body({required this.profile});
  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //   child: SizedBox(
    //     width: double.infinity,
    //       child: SingleChildScrollView(
    //         child: Padding(
    //           padding:EdgeInsets.symmetric(horizontal:20) ,
    //           child: Column(
    //             children: [
    //               // SizedBox(height: SizeConfig.screenHeight * 0.03),
    //               // Text("Complete Profile",style: GoogleFonts.poppins(color: c1,fontSize: 28,fontWeight: FontWeight.w600),
    //               // ),
    //               // SizedBox(height: 10,),
    //               // Text(
    //               //   "Complete your details or continue  \nwith social media",
    //               //   textAlign: TextAlign.center,
    //               //   style:GoogleFonts.poppins(color: kTextColor,fontSize: 13),
    //               // ),
    //               // SizedBox(height: SizeConfig.screenHeight * 0.06),
    //               // CompleteProfileForm(profile: profile,),
    //               // SizedBox(height: getProportionateScreenHeight(30)),
    //               // Text(
    //               //   "By continuing your confirm that you agree \nwith our Term and Condition",
    //               //   textAlign: TextAlign.center,
    //               //   style: Theme.of(context).textTheme.caption,
    //               // ),
    //               // SizedBox(height: 40),
    //               CompleteProfileForm(profile: profile,),
    //             ],
    //           ),
    //         ),
    //       ),
    //
    //   ),
    // );

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/bgcoversignin.jpg"),fit: BoxFit.cover)
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        child: Center(
          child:  Column(
            children: [

              Expanded(
                  flex: 8,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                  child:kIsWeb==true? Container(
                    child: Center(
                      child: Container(
                        width: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color:  darkglass,

                        ),

                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 100),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [


                            CompleteProfileForm(profile: profile,),

                          ],
                        ),
                      ),
                    ),
                  ):Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color:  darkglass,

                        ),

                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 100),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [


                            CompleteProfileForm(profile: profile,),

                          ],
                        ),
                      ),
                    ),
                  ))),
              Expanded(
                  flex: 1,
                  child:  Container(

                      decoration: BoxDecoration(color: Colors.white),
                      child:Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/icons/whatsapp.png"),size: 20,)),
                              IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/icons/youtube.png"))),
                              IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/icons/twitter.png"),size: 20,)),
                              IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/icons/insta.png"),size: 20,)),


                            ],),


                          Text("www.glare.social",style: getstyle(14, FontWeight.normal, Colors.black),)
                        ],
                      )
                  )),

            ],
          ),

        ),
      ),
    );
  }
}