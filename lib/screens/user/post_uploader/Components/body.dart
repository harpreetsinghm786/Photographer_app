import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:glare_photographer_app/helper/Newpost.dart';

import '../../../../constants.dart';

class Body extends StatefulWidget {
  Body({Key? key,required this.image}) : super(key: key);
  File image;
  @override
  _BodyState createState() => _BodyState(image: this.image);
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  bool? progress =false;
  Newpost? newpost;
  File? image;
  UploadTask? task;
  String? key;
  final caption_Controller=TextEditingController();
  String? caption;
  String? url;


  _BodyState({required this.image});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getkey();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("New Post",style: getstyle(16, FontWeight.w500, Colors.black),),
        backgroundColor: Colors.white,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: kTextColor,
        ),
        actions: [
          IconButton(onPressed: (){

            try{

              setState(() {
                if(key!=null) {
                    task = uploadImage(key!, image!);
                }

              });

              if(task==null){
                return;
              }else{
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();
                  if(caption==""){
                    setState(() {
                      this.caption="null";
                    });
                  }
                  Stordata(task!);
                }

              }



            }catch(e){
               print(e.toString());
            }


          }, icon: Icon(Icons.done)),
        ],
      ),

      body: progress==false? Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex:2,
                        child:  Image.file(image!,width: 60,height: 60,)),

                      Expanded(
                        flex: 8,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child:  TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (newValue) => caption = newValue,
                          controller: caption_Controller,
                          style: TextStyle(color: kTextColor,),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write a caption...",
                          ),
                        ),),
                      )

                    ],
                  )
                ],
              ),
            ),

          ),
        ),
      ):Container(
        color: Colors.white,
        child: Center(
            child: CircularProgressIndicator(
              color: c1,
            )),
      ),
    );
  }

  static UploadTask? uploadImage(String destination,File image){
    try {
      final ref= FirebaseStorage.instance.ref().child("post_pics/").child(FirebaseAuth.instance.currentUser!.uid).child(destination);
      return ref.putFile(image);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  void Stordata(UploadTask task) async {
    setState(() {
      progress=true;
    });


    final snapshot= await task.whenComplete(() => {});
    final url=await snapshot.ref.getDownloadURL();
    newpost=new Newpost(url, caption!, FirebaseAuth.instance.currentUser!.uid, key!, DateTime.now());

    try{

      FirebaseFirestore.instance
          .collection("Posts")
          .doc(key)
          .set(newpost!.toMap()).whenComplete(() => {
        progress=false,
        Navigator.pop(context)
      });
    }on FirebaseException catch(e){
      print(e.toString());
    }

  }

  Future getkey() async {
      this.key= await FirebaseFirestore.instance
          .collection("temp")
          .doc()
          .id;
  }





}
