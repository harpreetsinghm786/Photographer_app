import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glare_photographer_app/helper/Equipments.dart';

import '../../../constants.dart';

class Equipments extends StatefulWidget {
  const Equipments({Key? key}) : super(key: key);

  @override
  _EquipmentsState createState() => _EquipmentsState();
}

class _EquipmentsState extends State<Equipments> {
  var stream,stream2;
  List<dynamic> datalist=[];
  List<dynamic> selectedlist=[];
  List<bool> selectedbools=[];
  bool progress=false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    selectedbools.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getbools();
    setState(() {
      stream=FirebaseFirestore.instance.collection("Masters").doc("Specifications").snapshots();
      stream2=FirebaseFirestore.instance.collection("Specifications").doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Add Specifications",style: getstyle(16, FontWeight.w500,Colors.black),),
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 5,
        actions: [
          TextButton(onPressed: () async {
            setState(() {
              progress=true;
            });
            selectedlist.clear();
            for(int i=0;i<datalist.length;i++){
              if(selectedbools[i]==true){
                selectedlist.add(datalist[i]);
              }
            }
            selectedbools.clear();
            await FirebaseFirestore.instance.collection("Specifications").doc(FirebaseAuth.instance.currentUser!.uid).set({"list":selectedlist});
            setState(() {
              progress=false;
            });



            Navigator.pop(context);

          }, child:Text("Save",style: getstyle(13, FontWeight.normal, Colors.black),))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder(
                stream: stream,
                builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){


                  if(snapshot.connectionState==ConnectionState.waiting) {
                    return Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.black,)),
                    );
                  }

                  if(snapshot.hasData){
                    if(snapshot.data!.exists){
                      print(selectedbools);
                      datalist.clear();
                      datalist.addAll(snapshot.data!["list"]);


                      for(int i=0;i<datalist.length;i++){
                        if(selectedlist.contains(datalist[i])){
                          selectedbools.add(true);
                        }else{
                          selectedbools.add(false);
                        }
                      }


                      return ListView.builder(
                          itemCount: datalist.length,
                          itemBuilder: (context,index){
                            return Column(
                              children: [
                                CheckboxListTile(
                                  activeColor: Colors.green,
                                  value: selectedbools[index],
                                  title: Text(datalist[index]),
                                  onChanged: (value){
                                    print(selectedbools);
                                    setState(() {
                                      selectedbools[index]=!selectedbools[index];
                                    });
                                  },),

                                Container(width: double.infinity,
                                  height: 1,
                                  color: light,)

                              ],

                            );
                          });
                    }
                  }

                  return Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.black,));
                }
            ),
            progress?Container(
              color: Colors.white,
              child: Center(
                child: Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.black,)),
              ),
            ):Container()
          ],

        ),
      ),
    );
  }



  getbools() async {
    await FirebaseFirestore.instance.collection("Specifications").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => {
      selectedlist.addAll(value["list"]),
    });

    print(selectedbools);
  }

}
