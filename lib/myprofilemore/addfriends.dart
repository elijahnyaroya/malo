import 'package:africa_women_in_europe/AweMain/Myprofilearea.dart';
import 'package:africa_women_in_europe/AweMain/dashboard.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'myfriends.dart';

void main()=>runApp(Addfriends());

class Addfriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AWE",
      debugShowCheckedModeBanner: false,
      home: addfriends(),

    );
  }
}

class addfriends extends StatefulWidget {
  @override
  _addfriendsState createState() => _addfriendsState();
}
String friendsid;
class _addfriendsState extends State<addfriends> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  void _acceptingfriends() {
    _accepting();

  }
  Future<List> _accepting() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';

    final response = await http.post(URL_CONNECTOR+"addfriend.php", body: {
      "friendid":friendsid,
      "myaidno":userlogedinid,
    });

    print("RESPONSE 5 "+response.body);
    print("RESPONSE 22 "+userlogedinid);


    var datauser = json.decode(response.body);
    String values = datauser[0]['message'] ;

    if(datauser.length == 0){
      final snackbar = new SnackBar(
        behavior: SnackBarBehavior.floating,
        content: new Text(values),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);

    }else{
      if(datauser[0]['code']=="Fail"){
        final snackbar = new SnackBar(
          behavior: SnackBarBehavior.floating,
          content: new Text(values),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);

      }else if(datauser[0]['code']=="success"){
        final snackbar = new SnackBar(
          behavior: SnackBarBehavior.floating,
          content: new Text(values),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);

      }


    }



  }

  Future<List<Users>>_getUsers() async {
    var data = await http.get(URL_CONNECTOR+"pullawemembers.php");

    var jsonData = json.decode(data.body);

    List<Users> user = [];

    for(var u in jsonData){
      Users users = Users(u["id"],u[ "image"], u[ "fname"], u[ "lname"], u[ "country"],u[ "place"],u["about"]);

      user.add(users);
    }

    print(user.length);

    return user;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor:  Color(0xFFfaf4f1),
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        height: 30.0,
        color: Color(0xFFfaf4f1),
        child: Center(
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => myprofile()),);
                },
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                            backgroundColor: Color(0xFFfaf4f1),
                            child: new Icon(Icons.arrow_back_ios,color: Colors.black,)),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text("Back",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xFFc84333),
                          fontWeight: FontWeight.bold
                      ),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
          backgroundColor:  Color(0xFFc84333),
          leading:    IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => myprofile()),);
            },
          ),
          title:Center(child: Text ("Add Friends "))),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Loading(),
                ),
              );
            }else{
              return ListView.builder(
                padding: EdgeInsets.only(bottom: 50.0),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  friendsid =snapshot.data[index].id.toString();
                  return ListTile(
                    leading: Container(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(

                          snapshot.data[index].image,
                        ),
                      ),
                    ),
                    title: Text(
                      snapshot.data[index].fname+" "+snapshot.data[index].lname ,

                      style: TextStyle(
                        color: Color(0xFF393939),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,

                      ),
                    ),

                    subtitle: Text(snapshot.data[index].country+", "+snapshot.data[index].place,
                      style: TextStyle(
                        color: Color(0xFF393939),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,

                      ),),
                    trailing:   GestureDetector(
                      onTap:_acceptingfriends,
                      child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: new Icon(Icons.add_circle_outline,color: Color(0xFFc84333),)),
                    ),
                    isThreeLine: true,
                  );



                },
              );
            }
          },
        ),
      ),

    );
  }
}

class Users{

  final int id;
  final String image;
  final String fname;
  final String lname;
  final String country;
  final String place;
  final String about;

  Users(this.id, this.image, this.fname, this.lname, this.country, this.place,this.about);


}


