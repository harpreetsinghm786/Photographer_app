import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glare_photographer_app/screens/user/PhotographerDetails/photographer_details.dart';
import 'package:glare_photographer_app/screens/user/profile/profile.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'Home/home.dart';
import 'Map/maptab.dart';
import 'Notifications/Notifications.dart';

class UserMain extends StatefulWidget {

  UserMain({Key? key}) : super(key: key);
  @override
  _UserMainState createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {

  _UserMainState();

  int _selectedIndex = 0;
 // final gsignin=GoogleSignIn();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    IndexedStack data= IndexedStack(
      index: _selectedIndex,
      children: <Widget> [
        Dashboard(),
        Maptab(type: 0,keyword: "",),
        Notifications(),
        PhotgrapherDetails(uid: FirebaseAuth.instance.currentUser!.uid,),
        //ProfileScreen(),


        // Dashboard(),


      ],
    );


    return Scaffold(

      body: data,
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(
            color: Colors.black,size: 25
        ),
        showUnselectedLabels: true,
        elevation: 10,
        selectedLabelStyle: TextStyle(color: c1,fontWeight: FontWeight.w500,fontSize: 11),
        unselectedIconTheme: IconThemeData(
            color: Colors.black,size: 25
        ),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: ImageIcon(AssetImage("assets/icons/homeoutlines.png")),
        activeIcon: ImageIcon(AssetImage("assets/icons/Homefillicon.png")),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: ImageIcon(AssetImage("assets/icons/mapoutlines.png")),
        activeIcon: ImageIcon(AssetImage("assets/icons/Mapfillicon.png")),
        label: 'Map',
      ),

      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: ImageIcon(AssetImage("assets/icons/Notificationsoutlines.png")),
        activeIcon: ImageIcon(AssetImage("assets/icons/Notificationfillicon.png")),
        label: 'Contracts',
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: ImageIcon(AssetImage("assets/icons/Profileoutlines.png")),
        activeIcon: ImageIcon(AssetImage("assets/icons/Profilefillicon.png")),
        label: 'Profile',
      )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: kTextColor,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}