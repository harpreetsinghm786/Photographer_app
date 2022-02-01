import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Contracts",
          style: GoogleFonts.poppins(color: kTextColor, fontSize: 18),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Contracts")
            .where("photographerid",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return SafeArea(
            //Listview
            child: snapshot.data!.docs.length>0?ListView(
              children: snapshot.data!.docs.map((document) {
                Timestamp from = document["bookfrom"];
                Timestamp to = document["bookto"];

                return Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(color: light, blurRadius: 1, spreadRadius: 2)
                  ]),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getimages(document["photographerid"]),
                                  Text(
                                      "from: ${from.toDate().day.toString()}/${from.toDate().month.toString()}/${from.toDate().year.toString()}"),
                                  Text(
                                      "To: ${to.toDate().day.toString()}/${to.toDate().month.toString()}/${to.toDate().year.toString()}"),
                                  Text("status: ${document["status"]}"),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: document["status"] == "Requested"
                                    ? GestureDetector(
                                        onTap: () {
                                          FirebaseFirestore.instance
                                              .collection("Contracts")
                                              .doc(document["contractid"])
                                              .update({"status": "Accepted"});
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.blue)),
                                          child: Center(
                                            child: Text("Accept",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.blue)),
                                          ),
                                        ))
                                    : Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1, color: Colors.green)),
                                        child: Center(
                                          child: Text("Accepted",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.green)),
                                        ),
                                      ))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ):Center(child: Text("No Contracts Yet"),),
          );
        },
      ),
    );
  }

  getimages(String key) {
    var stream =
        FirebaseFirestore.instance.collection("Photographerdata").doc(key);

    return StreamBuilder(
        stream: stream.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Text(snapshot.data!["firstname"]),
              ],
            );
          }
          return Container();
        });
  }
}
