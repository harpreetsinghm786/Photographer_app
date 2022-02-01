import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glare_photographer_app/helper/Newpost.dart';
import 'package:glare_photographer_app/screens/sign_in/sign_in_screen.dart';
import 'package:glare_photographer_app/screens/user/Equipments/Equipments.dart';
import 'package:glare_photographer_app/screens/user/Specification/Specifications.dart';
import 'package:glare_photographer_app/screens/user/post_uploader/post_uploader.dart';
import 'package:glare_photographer_app/screens/user/profile_editor/profileEditorScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';

class Body extends StatefulWidget {
  Body({Key? key, this.uid}) : super(key: key);
  String? uid;


  @override
  _BodyState createState() => _BodyState(uid: uid);
}

class _BodyState extends State<Body> {
  PageController controller = new PageController();
  int currentpage = 0;
  String? uid;
  var stream,stream2;
  String? firstname;
  String? lastname;
  String? bio;
  ScrollController? scroll_controller;
  String? website;
  String? image;
  bool showmore=false;
  List<dynamic> datalist=[];
  bool progress=false;

  _BodyState({this.uid});

  String? city;
  List<Newpost>? posts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      stream=FirebaseFirestore.instance
          .collection("Masters")
          .doc("Equipments")
          .collection("Contents")
          .snapshots();

      stream2=FirebaseFirestore.instance
          .collection("Specifications")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
      
    });
    scroll_controller=new ScrollController();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark));

    return progress?Center(
      child: CircularProgressIndicator(color: Colors.black,),
    ):StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Photographerdata")
          .doc(uid!)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.exists) {
            firstname=snapshot.data!["firstname"];
            lastname=snapshot.data!["lastname"];

            bio=snapshot.data!["bio"];
            website=snapshot.data!["website"];
            image=snapshot.data!["profilepic"];
            uid=snapshot.data!["uid"];
            return Scaffold(
                body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 270,
                        child: getimages(uid!),
                      ),
                    ],
                  ),
                  //sliding images

                  Column(
                    children: [
                      //name ,address and Reviews
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Photographer \n${snapshot.data!["firstname"] + " " + snapshot.data!["lastname"]} ",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.start,
                                ),
                                IconButton(onPressed: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfileEditorScreen(firstname: firstname!, lastname: lastname!, bio: bio!, website: website!, image: image!)));

                                }, icon: Icon(Icons.edit))

                                // Expanded(
                                //     flex: 4,
                                //     child: GestureDetector(
                                //       onTap: () {
                                //         //    Navigator.push(context, MaterialPageRoute(builder: (context)=>ContractMaker(photographerId: uid!,price: 1500.0,)));
                                //       },
                                //       child: Container(
                                //         margin: EdgeInsets.only(left: 10),
                                //         padding:
                                //             EdgeInsets.symmetric(vertical: 7),
                                //         decoration: BoxDecoration(
                                //           borderRadius:
                                //               BorderRadius.circular(5),
                                //           border: Border.all(
                                //               width: 1, color: Colors.black),
                                //         ),
                                //         child: Center(
                                //           child: Text(
                                //             "Edit Profile",
                                //             style: GoogleFonts.poppins(
                                //               color: Colors.black,
                                //               fontWeight: FontWeight.w500,
                                //               fontSize: 13,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ))
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Text(
                                  "35 Reviews",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey, fontSize: 13),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.star,
                                  size: 13,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Serving in ${snapshot.data!["city"]}",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: finalgrey,
                            ),
                          ],
                        ),
                      ),

                      // //Equipments Available
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Equipments Available",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  IconButton(onPressed: (){
                                   // Navigator.push(context,MaterialPageRoute(builder: (context)=>Equipments()));
                                  }, icon: Icon(Icons.edit))

                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder(
                                stream: stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container(
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  }
                                  return Container(
                                    height: 160,
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      childAspectRatio: 0.3,
                                      children: snapshot.data!.docs.map((document) {
                                          return Container(
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  margin: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    image: DecorationImage(
                                                        image: NetworkImage(document["image"].toString()),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Text(document["name"],
                                                          style:
                                                          GoogleFonts.poppins(
                                                              color: Colors
                                                                  .black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600)),
                                                      Text(
                                                        document["description"],
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          color: Colors.grey,
                                                          fontSize: 13,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                      }).toList(),

                                    ),
                                  );
                                }),

                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              margin: EdgeInsets.symmetric(horizontal:10),
                              color: finalgrey,
                            ),
                          ],
                        ),
                      ),

                      //specifications
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Specifications",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  IconButton(onPressed: (){
                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Specifications()));
                                  }, icon: Icon(Icons.add))


                                ],
                              ),
                            ),


                            Container(
                              height: 50,
                              child: StreamBuilder(
                                stream: stream2,
                                  builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
                                if(snapshot.connectionState==ConnectionState.waiting){
                                  return Container(
                                    child: Center(
                                      child: Container(
                                        height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(color: Colors.black,)),
                                    ),
                                  );
                                }

                                if(snapshot.hasData){
                                  if(snapshot.data!.exists){
                                    datalist.clear();
                                    datalist.addAll(snapshot.data!["list"]);
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,

                                      controller: scroll_controller,
                                      padding: EdgeInsets.only(top: 0),
                                      itemCount: datalist.length,
                                        itemBuilder: (context,index){
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          child: Chip(
                                            avatar: CircleAvatar(
                                              backgroundColor: Colors.green,
                                              child: Icon(Icons.check)),
                                            label: Text(datalist[index],style: getstyle(13,FontWeight.normal,Colors.black)),
                                          ),
                                        );
                                     // return ListTile(title: Text(datalist[index],style: TextStyle(color: Colors.black),));
                                    });
                                  }
                                }

                                return Container(
                                  child: Center(
                                    child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(color: Colors.black,)),
                                  ),
                                );
                              }),
                            ),

                            SizedBox(height: 10,),
                            Container(
                              width: double.infinity,
                              height: 1,
                              margin: EdgeInsets.symmetric(horizontal:10),
                              color: finalgrey,
                            ),
                          ],
                        ),
                      ),

                      //  About Me
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("About Me",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              snapshot.data!["bio"],
                              maxLines: showmore?null:2,
                              style: getstyle(13, FontWeight.normal, Colors.black),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  showmore=!showmore;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(showmore?"Show less":"Show more",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                  Icon(
                                    showmore?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: finalgrey,
                            ),
                          ],
                        ),
                      ),

                      // //  what You will get
                      // Container(
                      //   margin: EdgeInsets.only(top: 20),
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //       Padding(
                      //         padding: EdgeInsets.only(left: 10),
                      //         child: Text("What you'll get ?",
                      //             style: GoogleFonts.montserrat(
                      //                 color: Colors.black,
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.w500)),
                      //       ),
                      //       Container(
                      //         height: 150,
                      //         margin: EdgeInsets.only(top: 20),
                      //         padding: EdgeInsets.only(left: 10),
                      //         child: GridView.count(
                      //           crossAxisCount: 1,
                      //           childAspectRatio: 1,
                      //           physics: ScrollPhysics(),
                      //           crossAxisSpacing: 5,
                      //           mainAxisSpacing: 5,
                      //           scrollDirection: Axis.horizontal,
                      //           shrinkWrap: true,
                      //           children: List.generate(
                      //               5,
                      //               (index) => Container(
                      //                     height: 120,
                      //                     width: 120,
                      //                     margin: EdgeInsets.all(5),
                      //                     padding: EdgeInsets.all(10),
                      //                     decoration: BoxDecoration(
                      //                       borderRadius:
                      //                           BorderRadius.circular(10),
                      //                       border: Border.all(
                      //                           color: Colors.black, width: 1),
                      //                     ),
                      //                     child: Column(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.end,
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Icon(
                      //                           Icons.save,
                      //                           size: 30,
                      //                         ),
                      //                         SizedBox(
                      //                           height: 5,
                      //                         ),
                      //                         Text(
                      //                           "Professional",
                      //                           style: GoogleFonts.montserrat(
                      //                               color: Colors.black,
                      //                               fontSize: 16,
                      //                               fontWeight:
                      //                                   FontWeight.w500),
                      //                         ),
                      //                         Text(
                      //                           "Professional",
                      //                           style: GoogleFonts.montserrat(
                      //                             color: Colors.black,
                      //                             fontSize: 13,
                      //                           ),
                      //                         ),
                      //                         SizedBox(
                      //                           height: 5,
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   )),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: 30,
                      //       ),
                      //       Container(
                      //         width: double.infinity,
                      //         height: 1,
                      //         color: finalgrey,
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      //  Best Clicks till date
                      Container(

                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: EdgeInsets.only(left: 10,top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Best Clicks till Date",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),

                                  IconButton(onPressed: (){
                                    pickImage(ImageSource.gallery);
                                  }, icon: Icon(Icons.add))


                                ],

                              ),
                            ),
                            getgridimages(uid!),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: finalgrey,
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  //Reviews
                  // Container(
                  //   margin: EdgeInsets.only(top: 20),
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       SizedBox(
                  //         height: 10,
                  //       ),
                  //       Padding(
                  //         padding: EdgeInsets.only(left: 10),
                  //         child: Text("Reviews",
                  //             style: GoogleFonts.montserrat(
                  //                 color: Colors.black,
                  //                 fontSize: 18,
                  //                 fontWeight: FontWeight.w500)),
                  //       ),
                  //       Container(
                  //         height: 200,
                  //         margin: EdgeInsets.only(top: 20),
                  //         padding: EdgeInsets.only(left: 10),
                  //         child: GridView.count(
                  //           crossAxisCount: 1,
                  //           childAspectRatio: 0.6,
                  //           physics: ScrollPhysics(),
                  //           crossAxisSpacing: 5,
                  //           mainAxisSpacing: 5,
                  //           scrollDirection: Axis.horizontal,
                  //           shrinkWrap: true,
                  //           children: List.generate(
                  //               5,
                  //               (index) => Container(
                  //                     width: 180,
                  //                     height: 120,
                  //                     margin: EdgeInsets.all(5),
                  //                     padding: EdgeInsets.all(10),
                  //                     decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(10),
                  //                       border: Border.all(
                  //                           color: Colors.black, width: 1),
                  //                     ),
                  //                     child: Column(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.start,
                  //                       children: [
                  //                         Row(
                  //                           children: [
                  //                             Container(
                  //                               margin: EdgeInsets.all(5),
                  //                               height: 45,
                  //                               width: 45,
                  //                               decoration: BoxDecoration(
                  //                                   shape: BoxShape.circle,
                  //                                   image: DecorationImage(
                  //                                       image: AssetImage(
                  //                                           "assets/images/c1.png"),
                  //                                       fit: BoxFit.cover)),
                  //                             ),
                  //                             SizedBox(
                  //                               width: 5,
                  //                             ),
                  //                             Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: [
                  //                                 Text(
                  //                                   "Salman Khan",
                  //                                   style:
                  //                                       GoogleFonts.montserrat(
                  //                                           color: Colors.black,
                  //                                           fontSize: 15,
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .w500),
                  //                                 ),
                  //                                 Text(
                  //                                   "1 week Ago",
                  //                                   style:
                  //                                       GoogleFonts.montserrat(
                  //                                     color: Colors.grey,
                  //                                     fontSize: 13,
                  //                                   ),
                  //                                 )
                  //                               ],
                  //                             ),
                  //                           ],
                  //                         ),
                  //                         SizedBox(
                  //                           height: 5,
                  //                         ),
                  //                         Padding(
                  //                           padding: EdgeInsets.only(
                  //                               left: 7, right: 10),
                  //                           child: Text(
                  //                             "Lorem ipsum dolor sit amet, consectetuer adipiscing elit,sed"
                  //                             "diam nonummy nibh euismod tincidunt ut laoreet dolore"
                  //                             "magna aliquam erat kefksdjfsdjfsdjfosjf oef iwepoif powe volutpat. Ut wisi enim ad minim veniam,"
                  //                             "quis nostrud exerci  iwufioweuf ewf weu foeuw tation",
                  //                             style: GoogleFonts.montserrat(
                  //                               color: Colors.black,
                  //                               fontSize: 13,
                  //                             ),
                  //                             maxLines: 4,
                  //                             textAlign: TextAlign.justify,
                  //                             overflow: TextOverflow.ellipsis,
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           height: 5,
                  //                         ),
                  //                         SizedBox(
                  //                           height: 5,
                  //                         ),
                  //                         GestureDetector(
                  //                           child: Row(
                  //                             children: [
                  //                               SizedBox(
                  //                                 width: 7,
                  //                               ),
                  //                               Text("Read more",
                  //                                   style:
                  //                                       GoogleFonts.montserrat(
                  //                                           color: Colors.black,
                  //                                           fontSize: 13,
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .w600)),
                  //                               Icon(
                  //                                 Icons.keyboard_arrow_down,
                  //                                 size: 16,
                  //                               )
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   )),
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {},
                  //         child: Container(
                  //           width: double.infinity,
                  //           height: 45,
                  //           margin:
                  //               EdgeInsets.only(left: 20, right: 20, top: 20),
                  //           decoration: BoxDecoration(
                  //             border: Border.all(width: 1, color: Colors.black),
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           child: Center(
                  //               child: Text("See All 35 Reviews",
                  //                   style: GoogleFonts.montserrat(
                  //                       color: Colors.black,
                  //                       fontSize: 14,
                  //                       fontWeight: FontWeight.w500))),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 30,
                  //       ),
                  //       Container(
                  //         width: double.infinity,
                  //         height: 1,
                  //         margin: EdgeInsets.symmetric(horizontal: 10),
                  //         color: finalgrey,
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Availability
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Availabilty",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
                                    Text("Sub Heading")
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: Icon(
                                  Icons.navigate_next,
                                  size: 20,
                                ),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          color: finalgrey,
                        ),
                      ],
                    ),
                  ),

                  //  Rules
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Rules",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
                                    Text("Sub Heading")
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: Icon(
                                  Icons.navigate_next,
                                  size: 20,
                                ),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          color: finalgrey,
                        ),
                      ],
                    ),
                  ),

                  //  Healthcare
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Health & Care",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
                                    Text("Sub Heading")
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: Icon(
                                  Icons.navigate_next,
                                  size: 20,
                                ),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          color: finalgrey,
                        ),
                      ],
                    ),
                  ),

                  //  Cancellation Policies
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Cancellation Policy",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
                                    Text("Sub Heading")
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: Icon(
                                  Icons.navigate_next,
                                  size: 20,
                                ),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          color: finalgrey,
                        ),
                      ],
                    ),
                  ),

                  //logout
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                      progress=true;
                      });
                      await FirebaseAuth.instance.signOut();
                      // await gsignin.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ),
                              (route) => false);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Logout",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
                                    Text("Will let you to get logout")
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                    child: Icon(
                                      Icons.navigate_next,
                                      size: 20,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          color: finalgrey,
                        ),
                      ],
                    ),
                  ),
                ],
              ), //appbar
            ));
          }
        }

        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  //Images In Carousel
  getimages(String key) {
    var stream = FirebaseFirestore.instance
        .collection("Posts")
        .where("uid", isEqualTo: key);

    return StreamBuilder(
        stream: stream.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 290,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Column(
            children: [
              Container(
                height: 270,
                width: MediaQuery.of(context).size.width,
                child: snapshot.data!.docs.length > 0
                    ? Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CarouselSlider.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index, realIndex) {
                              final image = snapshot.data!.docs[index]["url"];

                              return buildImage(
                                  image, index, snapshot.data!.docs.length);
                            },
                            options: CarouselOptions(
                              height: 400,
                              viewportFraction: 1,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentpage = index;
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${currentpage + 1}/${snapshot.data!.docs.length}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                            Text(
                              "No Post Yet",
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 14),
                            )
                          ],
                        ),
                      ),
              ),
            ],
          );
        });
  }

  //Carousel item
  Widget buildImage(String image, int index, int length) {
    return Column(
      children: [
        Container(
          height: 270,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: NetworkImage(image), fit: BoxFit.cover)),
        ),
      ],
    );
  }

  getgridimages(String key) {
    var stream = FirebaseFirestore.instance
        .collection("Posts")
        .where("uid", isEqualTo: key);

    return StreamBuilder(
        stream: stream.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(child: Center(child: CircularProgressIndicator()));
          }
          return Column(
            children: [
              Container(

                width: MediaQuery.of(context).size.width,
                child: snapshot.data!.docs.length > 0
                    ? Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: GridView.count(
                          padding: EdgeInsets.only(top: 10),
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          semanticChildCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: List.generate(
                              snapshot.data!.docs.length,
                              (index) => Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(snapshot
                                              .data!.docs[index]["url"]),
                                          fit: BoxFit.cover),
                                    ),
                                  )),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                            Text(
                              "No Post Yet",
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 14),
                            )
                          ],
                        ),
                      ),
              ),
            ],
          );
        });
  }

  Future pickImage(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img == null) return;

      final imageTemporary = await ImageCropper.cropImage(
          sourcePath: img.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [CropAspectRatioPreset.square],
          compressQuality: 70);

      Navigator.push(context, MaterialPageRoute(builder: (context)=> Post_uploader(image: imageTemporary!,)));


    } on PlatformException catch (e) {
      print("Failed to pick image: #$e");
    }
  }
}
