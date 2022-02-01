import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glare_photographer_app/screens/user/Map/maptab.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../theme.dart';
import 'Components/body.dart';



class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final _formKey = GlobalKey<FormState>();
  String? SearchString;
  final searchController=new TextEditingController();
  final List<String?> errors = [];
  late final FocusNode focusNode;

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
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark));
    focusNode.requestFocus();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: kTextColor,
        ),

       actions: [
         IconButton(onPressed: (){
           showSearch(context: context, delegate:DataSearch());
         }, icon:  Icon(Icons.search))
       ],
      ),

      body: Body(),
    );;
  }



}


class DataSearch extends SearchDelegate<String>{


  final data=[];

  final recents=[];


  @override
  List<Widget>? buildActions(BuildContext context) {


    return [IconButton(onPressed: (){
      query="";

    }, icon: Icon(Icons.clear))];
  }



  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    assert(theme != null);
    return theme.copyWith(

      appBarTheme: AppBarTheme(
        brightness: colorScheme.brightness,
        backgroundColor: colorScheme.brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),

      ),


      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,

          ),
    );
  }


  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
     close(context, "");

    }, icon: AnimatedIcon(icon:AnimatedIcons.menu_arrow, progress: transitionAnimation,));

  }

  @override
  Widget buildResults(BuildContext context) {

    if (query != "") {
      if (!recents.contains(query.toString())) {
        if (recents.length > 9) {
          recents.removeAt(0);
          recents.add(query.toString());
        } else {
          recents.add(query.toString());
        }
      }
    }

    FirebaseFirestore.instance.collection("Search History").doc(
        FirebaseAuth.instance.currentUser!.uid).set({"list": recents.toList()});


    return Maptab(type: 1,keyword: query.toString().toLowerCase(),);


  }


    @override
    Widget buildSuggestions(BuildContext context) {

      return query==""? StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Search History")
            .doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (!snapshot.hasData) {
            return Container();
          }

          if (snapshot.hasData) {
            if(snapshot.data!.exists) {
              recents.clear();
              recents.addAll(snapshot.data!["list"]);
              print(recents.length);

              return ListView.builder(
                  itemCount: recents.length,
                  itemBuilder: (context, index) {
                    return ListTile(leading: Icon(Icons.history),
                      title: RichText(
                        text: TextSpan(
                            text: recents[recents.length-index-1].substring(0, query.length),
                            style: getstyle(14, FontWeight.bold, Colors.black),
                            children: [
                              TextSpan(
                                  text: recents[recents.length-index-1].substring(query.length),
                                  style: getstyle(
                                      14, FontWeight.normal, Colors.black)
                              )
                            ]),
                      ),
                      onTap: (){
                      query=recents[recents.length-index-1];

                      },
                    );
                  });
            }
          }

          return Container();
        },
      ):StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("Photographerdata")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (!snapshot.hasData) {
            return Center(child: Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.black,),
            ) );
          }

          if (snapshot.hasData) {
            data.clear();
            data.addAll(snapshot.data!.docs.where((element) => element["firstname"].toString().toLowerCase().startsWith(query.toLowerCase())));

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context,index){
                  return ListTile(leading: Icon(Icons.location_city),
                    title: RichText(
                      text: TextSpan(text: data[index]["firstname"].substring(0,query.length),
                          style: getstyle(14, FontWeight.bold, Colors.black),children: [
                            TextSpan(
                                text: data[index]["firstname"].substring(query.length),
                                style: getstyle(14, FontWeight.normal, Colors.black)
                            )
                          ]),
                    ),
                    onTap: (){
                      query=data[index]["firstname"];

                    },
                  );
                });

          }

          return Container(
              color: Colors.white,
              child: Center(child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.black,),
              ) )
          );
        },
      );


    }


  }







