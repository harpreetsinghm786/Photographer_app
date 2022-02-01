import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glare_photographer_app/screens/user/post_uploader/post_uploader.dart';
import 'package:glare_photographer_app/screens/user/profile/components/profileHeaderWidget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants.dart';
import 'Gallery.dart';
import 'Igtv.dart';
import 'Reels.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool progress=false;
  String? firstname;
  String? lastname;
  String? bio;
  String? website;
  String? image;
  String? uid;
  FirebaseAuth auth=FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    var stream=FirebaseFirestore.instance.collection("Photographerdata").doc(auth.currentUser!.uid).snapshots();

    return Scaffold(
       body: new StreamBuilder(
        stream: stream, //changed
        builder: (BuildContext context,  AsyncSnapshot<DocumentSnapshot> snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){
              Container(
                color: Colors.white,
                child: Center(
                    child: CircularProgressIndicator(
                      color: c1,
                    )),
              );
          }
          if(snapshot.hasData){
              firstname=snapshot.data!["firstname"];
              lastname=snapshot.data!["lastname"];

              bio=snapshot.data!["bio"];
              website=snapshot.data!["website"];
              image=snapshot.data!["profilepic"];
              uid=snapshot.data!["uid"];


            return progress==false?Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: AppBar(
                    backgroundColor: Colors.white,
                    title: Text(
                      firstname!+" "+lastname!,
                      style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    centerTitle: false,
                    elevation: 0,
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.add_box_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          pickImage(ImageSource.gallery);
                        },
                      ),

                    ],
                  ),
                ),
              ),
              body: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [

                              profileHeader(context,firstname!,lastname!,bio!,website!,image!),


                          ],
                        ),
                      ),
                    ];
                  },
                  body: Column(
                    children: <Widget>[
                      Material(
                        color: Colors.white,
                        child: TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey[400],
                          indicatorWeight: 1,
                          indicatorColor: Colors.black,
                          tabs: [
                            Tab(
                              icon: Icon(
                                Icons.grid_on_sharp,
                                color: Colors.black,
                              ),
                            ),
                            Tab(
                              icon: Image.asset(
                                'assets/icons/igtv.png',
                                height: 30,
                                width: 30,
                              ),
                            ),
                            Tab(
                              icon: Image.asset(
                                'assets/icons/reels.png',
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Gallery(uid: uid!,),
                            Igtv(),
                            Reels(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ): Container(
              color: Colors.white,
              child: Center(
                  child: CircularProgressIndicator(
                    color: c1,
                  )),
            );
          }
          if(snapshot.hasError){
            return SafeArea(
              child: Container(
                child: Text("has error"),
              ),
            );
          }

          return Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator(
                  color: c1,
                )),
          );

        },
      ),

    );
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
