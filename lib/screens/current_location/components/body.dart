import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glare_photographer_app/helper/profile_data.dart';
import 'package:glare_photographer_app/screens/user/usermain.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {

  Profile profile;
  Body({Key? key, required this.profile}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(profile: this.profile);
}

class _BodyState extends State<Body> {

  Set<Marker> _marker=Set<Marker>();
  Profile profile;
  _BodyState({required this.profile});

  String Lat = "Latitude";
  String Lon = "Longitude";

  late  GoogleMapController mapcolntroller;

  late Position currentposition;
  var geolocator = Geolocator();
  bool loading=false;

  void locatePosition() async {
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
      _marker.add(
        Marker(markerId: MarkerId("id-1"),
            draggable: true,
            onDrag: (newPosition)=>{
            print(newPosition.latitude),
            print(newPosition.longitude),
              Lat=newPosition.latitude.toString(),
              Lon=newPosition.longitude.toString()
            },
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: const InfoWindow(
              title: 'Usted está aquí',
            ),
            position: LatLng(currentposition.latitude,currentposition.longitude)),


      );
    });
  }

  void _onmapcreated(GoogleMapController _controller){
    mapcolntroller=_controller;
    locatePosition();
  }

  // void _updatePosition(CameraPosition _position) {
  //   Position newMarkerPosition = Position(
  //       latitude: _position.target.latitude,
  //       longitude: _position.target.longitude, accuracy: );
  //   Marker marker = markers["1"];
  //
  //   setState(() {
  //     markers["1"] = marker.copyWith(
  //         positionParam: LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Container(
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
              flex: 5,
              child: Container(
                child: GoogleMap(
                  mapType: MapType.normal,
                  onMapCreated: _onmapcreated,

                  myLocationButtonEnabled: true,
                  //myLocationEnabled: true,
                  markers: _marker,

                  initialCameraPosition: const CameraPosition(

                    target: LatLng(0.0, 0.0),

                  ),

                ),
              )

          ),
          Expanded(
              flex: 4,
              child: Container(
                color: mapgrey,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),

                      boxShadow: [BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 2)],
                      color: Colors.white
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color:Lat != "Latitude"? Colors.green:Colors.black,
                            ),
                            Text(
                                Lat == "Latitude"
                                    ? "Fetching Your Location"
                                    : "Location Found",
                                style:getstyle(16, FontWeight.w500,Lat != "Latitude"? Colors.green:Colors.black)
                            ),
                            SizedBox(
                              width: 10,
                            ),


                          ],
                        ),
                        SizedBox(height: 20,),

                        Container(
                            height:0.5,


                            child:Lat == "Latitude"?
                            LinearProgressIndicator(color: Colors.black45 ,backgroundColor: light,):
                            Container(
                              height:1,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                            )
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: double.infinity,
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: light,
                            border: Border.all(
                              width: 1,
                              color: light,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text("Latitude: "+Lat,style: getstyle(13, FontWeight.w600, Colors.black)),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width: double.infinity,
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: light,
                            border: Border.all(
                              width: 1,
                              color: light,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text("Longitude: "+Lon,style: getstyle(13, FontWeight.w600, Colors.black),),
                        ),
                        SizedBox(height: 30,),


                        Container(
                          width: 200,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: finalgrey,spreadRadius: 2,blurRadius: 1)]
                          ),

                          child: FlatButton(
                            height: 45,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            onPressed: (){
                              if (Lat != "Latitude" && Lon != "Longitude") {
                                setState(() {
                                  loading=true;
                                });
                                GetAddressFromLatLong(currentposition);

                              }
                            },
                            color: Colors.white,
                            child: Text("Finish"),
                          ),
                        )



                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    ),
        loading?Container(
          height: double.infinity,
          width: double.infinity,
          color: glass,
          child: Center(
            child: Container(
              height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white,)),
          ),
        ):Container()
      ],
    );
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    if(kIsWeb==true){
      GeoCode geocode = GeoCode();
      var value =await geocode.reverseGeocoding(latitude:currentposition.latitude, longitude: currentposition.longitude);
      setState(() {
      //address = (add.countryName ?? '')+' - '+(add.region ?? '')+' - '+(add.city ?? '')+' - '+(add.streetAddress ?? '');
      profile.city = value.city;
      profile.state = value.region;
      profile.zipcode = value.postal;
      profile.country = value.countryName;
      profile.longitude = Lon;
      profile.latitude = Lat;
      });



      await StoreData();

      // print(add.streetAddress);
      // print(profile.city);
      // print(profile.state);
      // print(profile.country);

    }else{

    List<Placemark> placemark = await placemarkFromCoordinates(
        currentposition.latitude, currentposition.longitude);

    setState(() {
      profile.city = placemark[0].locality;
      profile.state = placemark[0].administrativeArea;
      profile.zipcode = placemark[0].postalCode;
      profile.country = placemark[0].country;
      profile.longitude = Lon;
      profile.latitude = Lat;
    });

    await StoreData();

      }
    // print("${profile.firstname} ${profile.lastname} ${profile.role} ${profile.email} ${profile.gender} ${profile.zipcode} ${profile.city} ${profile.country} ${profile.state}");
    //await StoreData();
  }

  StoreData() async {
    try{
      print(profile.state);
      print(profile.city);
      print(profile.zipcode);

      CollectionReference firestore =
      FirebaseFirestore.instance.collection("Photographerdata");
      await firestore.doc(profile.uid).set(profile.toMap()).then((value) =>
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => UserMain()),
                  (route) => false),
      );

    }on FirebaseException catch(e){
      print(e.message.toString());
    }

  }
}
