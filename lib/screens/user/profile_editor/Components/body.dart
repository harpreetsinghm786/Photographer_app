import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants.dart';

class Body extends StatefulWidget {
  String firstname, lastname, bio, website,image;

  Body(
      {Key? key,
      required this.firstname,
      required this.lastname,
      required this.bio,
      required this.website,
      required this.image})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState(
      firstname: this.firstname,
      lastname: this.lastname,
      Website: this.website,
      Bio: this.bio,
      image: this.image);
}

class _BodyState extends State<Body> {

  List<dynamic>? strings=[];
  List<dynamic>? fullstrings=[];
  List<bool>? bools=[];
  String? set="one";
  final _formKey = GlobalKey<FormState>();
  String? firstname, lastname, Website, Bio;
  UploadTask? task;
  bool? progress = false;
  String image;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final websiteController = TextEditingController();
  final bioController = TextEditingController();

  _BodyState({required this.firstname, required this.lastname, required this.Website, required this.Bio,required this.image});

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    firstnameController.dispose();
    lastnameController.dispose();
    websiteController.dispose();
    bioController.dispose();
    setState(() {
      progress = false;
    });
    super.dispose();
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getspecifications();
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      if (Bio == "null") {
        Bio = "";
      }
      if (Website == "null") {
        Website = "";
      }
    });


    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(

          child: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: kTextColor,
            ),
            actions: [
              TextButton(onPressed: (){


                setState(() {
                  progress = true;
                });
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (Bio!.isEmpty) {
                    Bio = "null";
                  }
                  if (Website!.isEmpty) {
                    Website = "null";
                  }
                  FirebaseFirestore.instance
                      .collection("Photographerdata")
                      .doc(
                      FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    "firstname": firstname,
                    "bio": Bio,
                    "lastname": lastname,
                    "website": Website,
                    "profilepic":image,
                  }).whenComplete(() =>
                  {
                    setState(() {
                      progress = false;
                    }),

                  Navigator.pop(context)

                  });
                }
               // savedata();


              }, child: Text("Save",style: getstyle(13, FontWeight.normal, Colors.black),)) ],

            title: Text(
              "Edit Profile",
              style:getstyle(16, FontWeight.w500,Colors.black)
            ),
            centerTitle: false,
            elevation: 5,
          ),
        ),
      ),
      body: progress == false
          ? Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // GestureDetector(
              //   onTap: () {
              //     removeFocus();
              //     ShowBottomslider();
              //   },
              //   child: Container(
              //     width: double.infinity,
              //     color: Colors.white,
              //     child: Column(
              //       children: [
              //         SizedBox(
              //           height: 20,
              //         ),
              //         ClipOval(
              //           child: image == "null"
              //               ? Image(
              //             image: AssetImage(
              //               "assets/images/coin.png",
              //             ),
              //             height: 100,
              //             width: 100,
              //             fit: BoxFit.cover,
              //           )
              //               : Image.network(image, height: 100, width: 100, fit: BoxFit.cover,
              //           ),
              //         ),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Text(
              //           "Change profile photo",
              //           style: GoogleFonts.poppins(
              //               color: c1,
              //               fontWeight: FontWeight.w500,
              //               fontSize: 14),
              //         ),
              //         SizedBox(
              //           height: 20,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              //getspecifications(),
              //Text(strings.toString()),


              // DefaultButton(
              //   text: "Add Specifications",
              //   press: (){
              //    //  getspecifications();
              //    // Navigator.push(context, MaterialPageRoute(builder: (context)=>specifications(strings: fullstrings!,bools: bools!))).then((value) => {
              //    //    getspecifications(),
              //    //  });
              //
              //
              //      },
              // ),
              SizedBox(
                height: 20,
              ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildFirstnameFormField(),
                    SizedBox(
                      height: 30,
                    ),
                    buildlastnameFormField(),
                    SizedBox(
                      height: 30,
                    ),
                    buildBioField(),
                    SizedBox(
                      height: 30,
                    ),
                    buildWebsiteField(),
                    SizedBox(
                      height: 30,
                    ),

                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
          : Center(
        child: Container(
          margin: EdgeInsets.all(10),
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: c1,
          ),
        ),
      ),
    );
  }

  TextFormField buildFirstnameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstname = newValue!,
      controller: firstnameController..text=firstname!,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter firstname';
        }
        return null;
      },
      style: TextStyle(color:Colors.grey,fontSize: 15),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kTextColor),
        ),
        focusColor: c1,
        hintStyle: getstyle(15, FontWeight.normal, Colors.grey),
        labelText: "First Name",
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: c1,fontWeight: FontWeight.w600),
        hintText: "Enter your First Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,

      ),
    );
  }

  TextFormField buildlastnameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastname = newValue!,
      controller: lastnameController..text=lastname!,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter lastname';
        }
        return null;
      },
      style: TextStyle(color:Colors.grey,fontSize: 15),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusColor: c1,
        hintStyle: getstyle(15, FontWeight.normal, Colors.grey),
        labelText: "Last Name",
        labelStyle: TextStyle(color: c1,fontWeight: FontWeight.w600),
        hintText: "Enter your Last Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,

      ),
    );
  }

  TextFormField buildWebsiteField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => Website = newValue,
      controller: websiteController..text = Website!,
      style: TextStyle(color:Colors.grey,fontSize: 15),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusColor: c1,
        hintStyle: getstyle(15, FontWeight.normal, Colors.grey),
        labelText: "Website",
        labelStyle: TextStyle(color: c1,fontWeight: FontWeight.w600),
        hintText: "Enter your Website",
        floatingLabelBehavior: FloatingLabelBehavior.always,

      ),
    );
  }

  TextFormField buildBioField() {
    return TextFormField(
      maxLines: null,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => Bio = newValue,
      controller: bioController..text = Bio!,
      style: TextStyle(color:Colors.grey,fontSize: 15),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusColor: c1,
        hintStyle: getstyle(15, FontWeight.normal, Colors.grey),
        labelText: "Bio",
        labelStyle: TextStyle(color: c1,fontWeight: FontWeight.w600),
        hintText: "Enter your Bio",
        floatingLabelBehavior: FloatingLabelBehavior.always,

      ),
    );
  }

  void ShowBottomslider() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xff737373),
            child: Container(
              height: 210,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        margin:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        width: 50,
                        color: kTextColor,
                        height: 2,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.image),
                    title: Text("Gallery",
                        style: GoogleFonts.poppins(color: c1, fontSize: 14)),
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);

                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Camera",
                        style: GoogleFonts.poppins(color: c1, fontSize: 14)),
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: c2,
                    ),
                    title: Text("Remove Profile photo",
                        style: GoogleFonts.poppins(color: c2, fontSize: 14)),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        progress = true;
                      });
                      _removeProfilePic();
                    },
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
            ),
          );
        });
  }

  removeFocus() {
    FocusScope.of(context).unfocus();
  }

  Future pickImage(ImageSource source) async {
    try {
      final img = await ImagePicker().getImage(source: source);
      if (img == null) return;

      final imageTemporary = await ImageCropper.cropImage(
          sourcePath: img.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [CropAspectRatioPreset.square],
          compressQuality: 70);

      setState(() {
        progress=true;
        task=uploadImage("display_pic/", imageTemporary!);
      });

      if(task==null) return ;

      final snapshot= await task!.whenComplete(() => {});
      final url=await snapshot.ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection("Photographerdata")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"profilepic": url}).whenComplete(() => {
      progress=false,
      Navigator.pop(context)  
      });

    } on PlatformException catch (e) {
      print("Failed to pick image: #$e");
    }
  }

  void _removeProfilePic() {
    FirebaseFirestore.instance
        .collection("Photographerdata")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"profilepic": "null"}).whenComplete(() =>
    {
      setState(() {
        progress = false;
        this.image="null";
      }),
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "Profile Saved",
            style: TextStyle(fontSize: 13.0, color: Colors.white),
          ),
        ),
      )
    });
  }

  static UploadTask? uploadImage(String destination,File image){
    try {
      final ref= FirebaseStorage.instance.ref().child("profile_pics/").child(FirebaseAuth.instance.currentUser!.uid).child(destination);
      return ref.putFile(image);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  // Future getdata() async{
  //   // list.clear();
  //    strings.clear();
  //   // for(int i=0;i<7;i++){
  //   //   list.add(false);
  //   //   strings.add("");
  //   // }
  //
  //   StreamBuilder(
  //     stream: FirebaseFirestore.instance.collection("specifications").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
  //     builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
  //       if (snapshot.hasData) {
  //         if (snapshot.data!.exists) {
  //           print(snapshot.data!.get("list"));
  //         }}
  //
  //       return Container(
  //         child: Center(
  //           child: CircularProgressIndicator(),
  //         ),
  //       );
  //     },
  //   );
  //
  // }

  Future getspecifications() async{

    var data= await FirebaseFirestore.instance.collection("specifications").doc(FirebaseAuth.instance.currentUser!.uid).get();

    if(data.exists){
      setState(() {
        strings=data["list"] as List;
      });

      }

    var data2= await FirebaseFirestore.instance.collection("Masters").doc("specifications").get();

    if(data2.exists){
      setState(() {
        fullstrings=data2["list"] as List;
      });

    }


    bools!.clear();

    for(int i=0;i<fullstrings!.length;i++){
     var isbool=false;
    for(int j=0;j<strings!.length;j++){
      if(fullstrings![i].toString()==strings![j].toString()){
        isbool=true;
      }
    }
     bools!.add(isbool);
    }

    //print(bools.toString()+fullstrings.toString()+strings.toString());

  }


}

