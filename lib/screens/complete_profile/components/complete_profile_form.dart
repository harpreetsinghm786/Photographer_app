import 'package:flutter/material.dart';
import 'package:glare_photographer_app/components/DefaultButton.dart';
import 'package:glare_photographer_app/helper/profile_data.dart';
import 'package:glare_photographer_app/screens/current_location/current_location.dart';

import '../../../constants.dart';


class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState(profile: profile);
  Profile profile;
  CompleteProfileForm({required this.profile});

}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  Profile profile;
  _CompleteProfileFormState({required this.profile});

  final _formKey = GlobalKey<FormState>();
  String dropdownValuegender='Male';
  final List<String?> errors = [];
  String? firstname;
  String? lastname;
  String? role;
  final firstnameController=new TextEditingController();
  final lastnameController=new TextEditingController();

  bool progress = false;


  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    firstnameController.dispose();
    lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(

          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              SizedBox(height: 40),
              Text(
                "Complete Profile",
                style: getstyle(24, FontWeight.w600, Colors.white),
              ),
              SizedBox(height:20),
              buildFirstNameFormField(),
              SizedBox(height:20),
              buildLastNameFormField(),
              SizedBox(height: 20,),
              buildGenderDropdown(),
              SizedBox(height: 30),
              Container(
                width: 200,
                child:DefaultButton(
                  text: "continue",
                  press: () {

                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        progress=true;
                        profile.firstname = firstname;
                        profile.lastname = lastname;
                        profile.gender = dropdownValuegender;
                      });

                      if(dropdownValuegender=="Select your Gender") {
                        progress=false;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.black,
                            content: Text(
                              "Select Your Gender",
                              style: TextStyle(fontSize: 13.0, color: Colors.white),
                            ),
                          ),
                        );
                      }else{
                        removeFocus();
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                                CurrentLocation(profile: this.profile,)));
                        setState(() {
                          progress=false;
                        });

                      }
                    }


                  },
                ),
              ),

              SizedBox(height: 50),
            ],
          ),

        ),
        progress
            ? Container(
          child: Center(
            child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white)),
          ),
        )
            : Container(),
      ],
    );
  }

  Container buildGenderDropdown(){

    return Container(



        alignment: Alignment.center,
         width: double.infinity,

        child: DropdownButton<String>(
          onTap: removeFocus,
          menuMaxHeight: 200,
          hint:Text("Select Your Gender",style:TextStyle(color:Colors.white)),
          value: dropdownValuegender,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down,color: Colors.white,),
          iconSize: 24,
          dropdownColor: Colors.black,
          iconEnabledColor:Colors.white,

          borderRadius: BorderRadius.circular(10),
          elevation: 16,


          underline: Container(width: double.infinity,height: 1,color: Colors.grey,),
          style: const TextStyle(color: Colors.green),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValuegender = newValue!;
            });
          },

          items: <String>['Male', 'Female', 'Other']
              .map<DropdownMenuItem<String>>((String value) {

            return DropdownMenuItem<String>(
              
              value: value,
              child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(value,style: getstyle(13, FontWeight.normal, Colors.white),),),


            );
          }).toList(),
        ),
      );

  }

  Container buildLastNameFormField() {
    return Container(

      child: TextFormField(
        onSaved: (newValue) => lastname = newValue,
        style: TextStyle(color:kTextColor),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter Last Name';
            }
            return null;
          },
        controller: lastnameController,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kTextColor),
          ),
          focusColor: c1,
          hintStyle: getstyle(13, FontWeight.normal, Colors.grey),
          alignLabelWithHint: true,
          hintText: "Last Name",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: ImageIcon(AssetImage("assets/icons/Profileoutlines.png"),color: Colors.white,)
        ),
      ),
      )
    );
  }

  Container buildFirstNameFormField() {
    return Container(

      child: TextFormField(
        onSaved: (newValue) => firstname = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kNamelNullError);
          }
          return null;
        },
        controller: firstnameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter First Name';
          }
          return null;
        },
        style: TextStyle(color:kTextColor),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kTextColor),
          ),
          focusColor: c1,
          hintStyle: getstyle(13, FontWeight.normal, Colors.grey),
          alignLabelWithHint: true,
          hintText: "First Name",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: ImageIcon(AssetImage("assets/icons/Profileoutlines.png"),color: Colors.white,)
          ),
        ),
      ),
    );
  }

  removeFocus(){
    FocusScope.of(context).unfocus();
  }


}