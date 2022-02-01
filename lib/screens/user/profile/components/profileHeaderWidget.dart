import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glare_photographer_app/screens/user/profile_editor/profileEditorScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';


import '../../../../constants.dart';
import 'data.dart';

Widget profileHeader(BuildContext context,String firstname,String lastname,String bio,String website,String image){
   return Container(
     width: double.infinity,

     child: Padding(
       padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           SizedBox(
             height: 10,
           ),
           Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               SizedBox(
                 height: 10,
               ),
               ClipOval(
                 child: image == "null"
                     ? Image(
                   image: AssetImage(
                     "assets/images/profile.jpeg",
                   ),
                   height: 100,
                   width: 100,
                   fit: BoxFit.cover,
                 )
                     : Image.network(image, height: 100, width: 100, fit: BoxFit.cover,
                 ),
               ),
               SizedBox(
                 height: 8,
               ),
               Text(firstname,
                   style: getstyle(18,FontWeight.w500,Colors.black)),
               SizedBox(
                 height: 2,
               ),
               Text(
                // "Lorem Ipsum uiwdiwuid jjasdhja ayduwy duhasd wud wud iw de wf fieu fiweu fiuweiof uweifiow ufiowe duhasd wud wud iw de wf   fieu fiweu fiuweiof uweifiow ufioweu",
                 bio,
                 style: getstyle(13,FontWeight.w500,Colors.black),
                 textAlign: TextAlign.center,
               ),
               SizedBox(
                 height: 20,
               ),


               actions(context,firstname,lastname,bio,website,image),
               SizedBox(
                 height: 20,
               ),
             ],
           ),
         ],
       ),
     ),
   );
}

  Widget actions(BuildContext context,String firstname,String lastname, String bio,String website,String image) {

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            style: TextButton.styleFrom(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              primary: Colors.white,
              backgroundColor: Colors.black ,
            ),
            onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileEditorScreen(firstname: firstname,lastname: lastname,bio: bio,website: website,image: image,)));

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit),
                SizedBox(width: 5,),
                Text("Edit Profile",style: getstyle(13,FontWeight.w500,Colors.white),)
              ],
            ),
          ),
        ),
      ),
    ]);
  }






