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

void main()=>runApp(Invitation());

class Invitation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AWE",
      debugShowCheckedModeBanner: false,
      home: invitations(),

    );
  }
}

class invitations extends StatefulWidget {
  @override
  _invitationsState createState() => _invitationsState();
}
String friendsid;
class _invitationsState extends State<invitations> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  void _acceptingfriends() {
    _accepting();

  }
  Future<List> _accepting() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';

    final response = await http.post(URL_CONNECTOR+"acceptinvites.php", body: {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';
    var data = await http.post(URL_CONNECTOR+"pullmyinvites.php",body: {
      "myaidno":userlogedinid,
    });

    var jsonData = json.decode(data.body);

    List<Users> user = [];

    for(var u in jsonData){
      Users users = Users(u["id"],u[ "image"], u[ "fname"], u[ "lname"], u[ "country"], u[ "place"]  );


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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Color(0xFF24421f),
        backgroundColor: Color(0xFFfaf4f1),

        items: [
          new BottomNavigationBarItem(
              title: new Text('My Friends'),
              icon: GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => myfriends()),);
                  },
                  child: new Icon(Icons.people,color: Color(0xFFc84333),)
              )
          ),
          new BottomNavigationBarItem(
              title: new Text('Invitation'),
              icon: GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => invitations()),);
                  },
                  child: new Icon(Icons.email,color: Color(0xFFc84333))
              )
          ),
        ],
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
          title:Center(child: Text ("Friends Invites"))),
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
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,

                      ),),
                      trailing:   GestureDetector(
                        onTap:_acceptingfriends,
                        child: CircleAvatar(
                            radius: 15,
                         backgroundColor: Colors.white,
                         child: new Icon(Icons.add_circle_outline,color: Colors.black,)),
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

  Users(this.id, this.image, this.fname, this.lname, this.country, this.place);





}


