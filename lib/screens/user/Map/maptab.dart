import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glare_photographer_app/screens/Search/search_screen.dart';
import 'package:glare_photographer_app/screens/user/Photographer%20highering/photographer_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../constants.dart';
import '../usermain.dart';


class Maptab extends StatefulWidget {

  int type;
  String keyword;
  Maptab({Key? key,required this.type,required this.keyword}) : super(key: key);
  @override
  _MaptabState createState() => _MaptabState(type: this.type,keyword: this.keyword);
}

class _MaptabState extends State<Maptab> {

  List<dynamic> wishlist = [];
  bool _maploading=true;
  late  GoogleMapController mapcolntroller;
  Map<String,int> dot_indexs=new Map<String,int>();
  ScrollController controller=new ScrollController();
  late Position currentposition;
  var geolocator = Geolocator();
  String Lat = "Latitude";
  String Lon = "Longitude";
  List photographerdata=[];
  List<Marker> _marker=[];

  static CameraPosition _kgoogleplex = CameraPosition(
      target: LatLng(0.0, 0.0), zoom: 15);

  void locatePosition() async {
    _marker.clear();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentposition = position;
    LatLng latLngposition =
    LatLng(currentposition.latitude, currentposition.longitude);
    CameraPosition cameraPosition =
    new CameraPosition(target: latLngposition, zoom: 15);
    mapcolntroller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    setState(() {
      Lat = cameraPosition.target.latitude.toString();
      Lon = cameraPosition.target.longitude.toString();

      for(int i=0;i<photographerdata.length;i++){

        String result=(photographerdata[i]["firstname"].toString()+photographerdata[i]["lastname"].toString()+photographerdata[i]["bio"].toString()+photographerdata[i]["city"].toString()+photographerdata[i]["state"].toString()+photographerdata[i]["country"].toString()+photographerdata[i]["zipcode"].toString()+photographerdata[i]["gender"].toString()+photographerdata[i]["website"]).toString();
        if((result.toLowerCase()).contains(keyword.toLowerCase()) || (keyword.toLowerCase()).contains(result.toLowerCase())) {
          _marker.add(
            Marker(markerId: MarkerId(i.toString()),
                icon: BitmapDescriptor.defaultMarkerWithHue(29.0),
                infoWindow: InfoWindow(
                    title: "You are Here"
                ),
                position: LatLng(double.parse(photographerdata[i]["latitude"]),
                    double.parse(photographerdata[i]["longitude"]))),


          );
        }

      }


      _marker.add(
        Marker(markerId: MarkerId("id-1"),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: const InfoWindow(
              snippet: "Current location",
              title: 'Your Location',
            ),
            position: LatLng(currentposition.latitude,currentposition.longitude)),

      );


    });
  }
  int type;
  String keyword;

  _MaptabState({required this.type,required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:type==0 || type==2? AppBar(
        elevation: 7,
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Icon(Icons.camera,color: Colors.black,),
              // Image.asset("assets/icons/Bookfillicon.png",width: 30,fit: BoxFit.cover,color: Colors.black,),

              SizedBox(width: 5,),

              Text(
                "Glare",
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ):null,


      body:Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child:Stack(

          children: [
            RefreshIndicator(
              color: Colors.black,
              onRefresh: ()=>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>UserMain()), (route) => false),
              triggerMode: RefreshIndicatorTriggerMode.onEdge,

              child: ListView(

                controller: controller,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,

                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        height: 400,
                        child:StreamBuilder(

                          stream: FirebaseFirestore.instance
                              .collection("Photographerdata")
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                            if (!snapshot.hasData) {
                              return Center(child: Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.black,),
                              ) );
                            }

                            if (snapshot.hasData) {
                              photographerdata.clear();

                              photographerdata.addAll(snapshot.data!.docs);

                              return GoogleMap(
                                mapType: MapType.normal,
                                onMapCreated: (GoogleMapController controller) {
                                  mapcolntroller = controller;
                                  locatePosition();
                                  setState(() {
                                    _maploading=false;
                                  });
                                },

                                markers: Set<Marker>.of(_marker),

                                initialCameraPosition: _kgoogleplex,

                              );

                            }

                            return Container(
                                color: Colors.white,
                                child: Center(child: Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.black,),
                                ) )
                            );
                          },
                        ),


                      ),
                      type==0?Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              SizedBox(height: 10,),
                              FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {

                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 1,
                                            spreadRadius: 1)
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
                                        Icon(Icons.search),
                                        Text("Search here",style: getstyle(13, FontWeight.w500, Colors.black),),
                                        Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ))
                            ],
                          )
                      ):Container(),

                      type==2?Container():Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              SizedBox(height: 10,),
                              FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {

                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 1,
                                            spreadRadius: 1)
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
                                        Icon(Icons.search),
                                        Text("Search here",style: getstyle(13, FontWeight.w500, Colors.black),),
                                        Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ))
                            ],
                          )
                      ),
                      (_maploading)==true
                          ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Center(
                          child:Container(
                            height: 20,
                            width: 20,
                            child:CircularProgressIndicator(color: Colors.black,),)
                        ),
                      )
                          : Container(),

                    ],
                  ),

                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Photographerdata")
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.black,),
                        ) );
                      }

                      if (snapshot.hasData) {

                        return  Container(
                            //Listview
                          color: mapgrey,
                            child: Container(

                                child: Column(
                                  children: [
                                    Container(

                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),

                                            boxShadow: [BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 2)],
                                            color: Colors.white
                                        ),
                                        padding: EdgeInsets.all(10),
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 1.2,
                                              color: Colors.grey,
                                              width: 50,
                                            ),
                                            SizedBox(height: 10,),
                                            Text("${snapshot.data!.docs.length}+  Photographers",style: getstyle(14, FontWeight.w600, Colors.black),),
                                            SizedBox(height: 10,),
                                          ],
                                        )//
                                    ),
                                    Container(
                                      color:Colors.white,
                                      child: ListView(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        //controller: controller,
                                        children: snapshot.data!.docs.map((document) {

                                          dot_indexs.putIfAbsent(document["uid"], () => 0);

                                          String result=(document["firstname"].toString()+document["lastname"].toString()+document["bio"].toString()+document["city"].toString()+document["state"].toString()+document["country"].toString()+document["zipcode"].toString()+document["gender"].toString()+document["website"]).toString();
                                          if((result.toLowerCase()).contains(keyword.toLowerCase()) || (keyword.toLowerCase()).contains(result.toLowerCase())){
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>Photographerhighering(
                                                          uid: document["uid"],
                                                        )));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                margin: EdgeInsets.only(top: 10),
                                                child: Column(
                                                  children: [

                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 15,
                                                          child: Container(

                                                            margin: EdgeInsets.symmetric(horizontal: 15),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  document["firstname"] +
                                                                      " " +
                                                                      document["lastname"],
                                                                  style: GoogleFonts.poppins(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 18,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Container(
                                                                  width: 1,
                                                                  height: 15,
                                                                  color: Colors.black,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  document["city"],
                                                                  style: getstyle(13,
                                                                      FontWeight.normal, Colors.grey),
                                                                ),
                                                              ],
                                                            ),
                                                          ),),
                                                        Expanded(
                                                          flex: 5,
                                                          child: Container(
                                                            margin: EdgeInsets.only(right: 15),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Icon(
                                                                  Icons.star,
                                                                  color: kTextColor,
                                                                  size: 14,
                                                                ),
                                                                Text(
                                                                  "4.55 |",
                                                                  style: GoogleFonts.montserrat(
                                                                    color: Colors.grey,
                                                                    fontSize: 12,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " 56",
                                                                  style: GoogleFonts.montserrat(
                                                                    color: Colors.grey,
                                                                    fontSize: 12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),),
                                                      ],
                                                    ),


                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 7),
                                                      child: getimages(document["uid"]),
                                                    ),
                                                    SizedBox(
                                                      height: 14,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [

                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(20),
                                                              border: Border.all(
                                                                  width: 0.5, color: bodytextcolor),
                                                            ),
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: 15, vertical: 5),
                                                            child: Text(
                                                              "Rs. 1500/ day",
                                                              style: GoogleFonts.poppins(
                                                                color: bodytextcolor,
                                                                fontWeight: FontWeight.normal,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),

                                                          GestureDetector(
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: 15, vertical: 5),
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(20),
                                                                border: Border.all(
                                                                    width: 0.5, color: bodytextcolor),
                                                              ),
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Icon(Icons.share,size: 20,color: bodytextcolor,),
                                                                  SizedBox(width: 5,),
                                                                  Text("Share",style: getstyle(13, FontWeight.normal, bodytextcolor))
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: (){
                                                              Share.share("Shared String data");
                                                            },
                                                          ),
                                                          getbookmarks(document["uid"])


                                                        ],
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Container(width: double.infinity,height: 0.2,color: Colors.grey,margin: EdgeInsets.symmetric(horizontal: 50),),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          return Container();
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          );

                      }

                      return Container(
                        color: Colors.white,
                        child: Center(child: Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.black,),
                        ) )
                      );
                    },
                  ),
                  SizedBox(height: 60,)

                ],

              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(

                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),

                            onPressed: () {

                             // locatePosition();
                           controller.animateTo(0, duration: const Duration(milliseconds: 500), curve:Curves.easeOut);
                            },
                            child: Container(
                              width: 150,

                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 1,
                                      spreadRadius: 1)
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center ,
                                children: [
                                  Icon(Icons.map),
                                  SizedBox(width: 5,),
                                  Text("Map",style: getstyle(13,FontWeight.normal,Colors.black),)
                                ],
                              ),
                            )),
                        SizedBox(height: 10,),
                      ],
                    )
                ),
              ],
            )

          ],
        )
      ),

    );
  }

  Widget Dismiss({required Widget child}){
   return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: ()=>Navigator.of(context).pop(),
      child: GestureDetector(onTap: (){},child: child,),
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
              child: Center(child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.black,),
              ) ),
            );
          }

          return Column(
            children: [
              Container(
                height: 270,
                width: MediaQuery.of(context).size.width,
                child: snapshot.data!.docs.length > 0
                    ? CarouselSlider.builder(
                  carouselController: new CarouselController(),
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
                        dot_indexs[key] = index;
                      });
                    },
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(image: AssetImage("assets/images/dummy.jpeg"),fit: BoxFit.cover)
                  ),
                ),
              ),
              snapshot.data!.docs.length > 1
                  ? Column(
                children: [
                  SizedBox(
                    height: 7,
                  ),
                  AnimatedSmoothIndicator(
                    activeIndex: dot_indexs[key]!,
                    count: snapshot.data!.docs.length,
                    effect: JumpingDotEffect(
                      dotWidth: 6,
                      dotHeight: 6,
                      spacing: 4,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.black,
                    ),
                  )
                ],
              )
                  : Container(),
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

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: NetworkImage(image), fit: BoxFit.cover)),
        ),
      ],
    );
  }

  // getheart
  Widget getbookmarks(String key) {
    var stream = FirebaseFirestore.instance
        .collection("Wishlist")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    return StreamBuilder(
        stream: stream.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          wishlist.clear();
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }else if(snapshot.data!.exists){


            wishlist.addAll(snapshot.data!["list"]);

            return Stack(
              children: [
                wishlist.contains(key)?GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(20),
                      border: Border.all(
                          width: 0.5, color: bodytextcolor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark,size: 20,color: bodytextcolor,),
                        SizedBox(width: 5,),
                        Text("Save",style: getstyle(13, FontWeight.normal, bodytextcolor),)
                      ],
                    ),
                  ),
                  onTap: (){
                    removewishlist(key);
                  },
                ):
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(20),
                      border: Border.all(
                          width: 0.5, color: bodytextcolor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border,size: 20,color: bodytextcolor,),
                        SizedBox(width: 5,),
                        Text("Save",style: getstyle(13, FontWeight.normal, bodytextcolor),)
                      ],
                    ),
                  ),
                  onTap: (){
                    Addtowishlist(key);
                  },
                )

              ],
            );



          }

          return GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(20),
                border: Border.all(
                    width: 0.5, color: bodytextcolor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border,size: 20,color: bodytextcolor,),
                  SizedBox(width: 5,),
                  Text("Save",style: getstyle(13, FontWeight.normal, bodytextcolor),)
                ],
              ),
            ),
            onTap: (){
              Addtowishlist(key);
            },
          );



        });
  }

  //add to wishlist
  Addtowishlist(String key) async {
    wishlist.add(key);
    await FirebaseFirestore.instance
        .collection("Wishlist")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"list":wishlist});

    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Added to Wishlist",style: getstyle(14, FontWeight.normal, Colors.green),),backgroundColor: light,elevation: 10,));

  }

  //removewishlist
  removewishlist(String key) async {
    wishlist.remove(key);
    await FirebaseFirestore.instance
        .collection("Wishlist")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"list":wishlist});
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Removed from Wishlist",style: getstyle(14, FontWeight.normal, Colors.red),),backgroundColor: light));

  }


  


}






