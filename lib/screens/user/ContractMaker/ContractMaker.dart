import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glare_photographer_app/helper/Contract.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../constants.dart';

class ContractMaker extends StatefulWidget {
  ContractMaker({Key? key, this.photographerId, this.price}) : super(key: key);
  String? photographerId;
  double? price;

  @override
  _ContractMakerState createState() =>
      _ContractMakerState(photographerId: photographerId, price: price);
}

class _ContractMakerState extends State<ContractMaker> {
  String? photographerId;
  double? price;
  bool progress = false;
  final _formKey = GlobalKey<FormState>();

  _ContractMakerState({this.photographerId, this.price});

  String? ContractId, massage="";
  DateTime? startdate, enddate;
  double TotalPrice = 0.0;
  DateRangePickerController datecontroller = new DateRangePickerController();
  TextEditingController messagecontroller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getkey();
  }
  @override
  void dispose() {
    messagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: kTextColor),
        title: Text(
          "Contract",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
        ),
      ),
      body: progress == false
          ? SafeArea(
              child: Body(context),
            )
          : Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              )),
    );
  }

  Future getkey() async {
    this.ContractId =
        await FirebaseFirestore.instance.collection("temp").doc().id;
  }

  Widget Body(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Total price",
              style: GoogleFonts.poppins(color: kTextColor, fontSize: 12),
            ),
            Text(
              "Rs. ${TotalPrice.toString()}",
              style: GoogleFonts.poppins(
                  color: Colors.blue, fontSize: 25, fontWeight: FontWeight.w500),
            ),
            Text(
              "Price ${price} /Day",
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            SizedBox(
              height: 20,
            ),
            SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: _onSelectedChanged,
              controller: datecontroller,
              selectionShape: DateRangePickerSelectionShape.circle,
            ),
            Form(
              key: _formKey,
                child: buildmessageFormField()),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {

                   _formKey.currentState!.save();

                   if (startdate!.isAfter(DateTime.now()) &&
                       enddate!.isAfter(DateTime.now())) {

                     if (massage == "") {
                       Contract contract = new Contract(
                           this.ContractId,
                           FirebaseAuth.instance.currentUser!.uid,
                           photographerId,
                           "null",
                           startdate,
                           enddate,
                           TotalPrice,
                           "Requested");

                       Stordata(contract);
                     } else {
                       Contract contract = new Contract(
                           this.ContractId,
                           FirebaseAuth.instance.currentUser!.uid,
                           photographerId,
                           massage,
                           startdate,
                           enddate,
                           TotalPrice,
                           "Requested");
                       print("here");
                       Stordata(contract);
                     }
                   } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                         new SnackBar(content: Text("Invalide Dates")));
                   }



              },
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    "Initiate Contract",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void Stordata(Contract? contract) async {
    setState(() {
      progress = true;
    });

    try {
      FirebaseFirestore.instance
          .collection("Contracts")
          .doc(contract!.contractid)
          .set(contract.toMap())
          .whenComplete(() => {
                progress = false,
                Navigator.pop(context),
                ScaffoldMessenger.of(context).showSnackBar(
                    new SnackBar(content: Text("Contract Created"))),
              });
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  TextFormField buildmessageFormField() {
    return TextFormField(
      maxLines: null,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => this.massage = newValue,
      controller: messagecontroller,
      style: TextStyle(color: kTextColor),
      decoration: InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: new BorderSide(color: c1),
        ),
        enabledBorder: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: new BorderSide(color: c1),
        ),
        labelText: "Massage",
        labelStyle: TextStyle(color: c1),
        hintText: "Massage (Optional)",

        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  void _onSelectedChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      startdate = args.value.startDate;
      enddate = args.value.endDate;
    });
    double a = enddate!.difference(startdate!).inHours + 24;
    double b = (a / 24) * price!;
    setState(() {
      TotalPrice = b;
    });
  }
}
