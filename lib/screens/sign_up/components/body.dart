import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glare_photographer_app/screens/sign_up/components/sign_up_form.dart';



import '../../../constants.dart';


class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bgcoversignin.jpg"),
                fit: BoxFit.cover)),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              children: [
                Expanded(
                    flex: 8,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        child: Center(
                          child:kIsWeb==true? Container(
                            width: 500,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: darkglass,
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 100),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                SignUpForm()
                              ],
                            ),
                          ):Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: darkglass,
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 100),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                SignUpForm()
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: ImageIcon(
                                      AssetImage("assets/icons/whatsapp.png"),
                                      size: 20,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: ImageIcon(AssetImage(
                                        "assets/icons/youtube.png"))),
                                IconButton(
                                    onPressed: () {},
                                    icon: ImageIcon(
                                      AssetImage("assets/icons/twitter.png"),
                                      size: 20,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: ImageIcon(
                                      AssetImage("assets/icons/insta.png"),
                                      size: 20,
                                    )),
                              ],
                            ),
                            Text(
                              "www.glare.social",
                              style: getstyle(
                                  14, FontWeight.normal, Colors.black),
                            )
                          ],
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
