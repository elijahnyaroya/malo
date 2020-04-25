import 'package:africa_women_in_europe/AweMain/Myprofilearea.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:africa_women_in_europe/myprofilemore/myothergroups.dart';



class GroupAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: groupsavailable(),

    );
  }
}

class groupsavailable extends StatefulWidget {
  @override
  _groupsavailableState createState() => _groupsavailableState();
}
String newsfedid;
String groupid;
String creatorid;
class _groupsavailableState extends State<groupsavailable> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
// for like the post
  void _performJoining() {
    _joingroup();

  }
  Future<List> _joingroup() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';

    final response = await http.post(URL_CONNECTOR+"addmemberstogroup.php", body: {
      "creatorid":groupid,/////////////////////////check it later
      "groupid":groupid,
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


  Future<List<Groups>>_getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';
    var data = await http.post(URL_CONNECTOR+"pullgroupinvites_2.php",body: {
      "myaidno":userlogedinid,
    });

    var jsonData = json.decode(data.body);

    List<Groups> user = [];

    for(var u in jsonData){
      Groups users = Groups(u["id"],u[ "groupname"],u["about"],u["dates"]);

      user.add(users);
    }

    print(user.length);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          backgroundColor:  Color(0xFFc84333),
          title:Center(
              child: Row(
                children: <Widget>[

                  Text ("Groups Available",
                    textAlign: TextAlign.center,
                    style: TextStyle(),),
                ],
              )
          )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Color(0xFF24421f),
        backgroundColor: Color(0xFFfaf4f1),

        items: [
          new BottomNavigationBarItem(
              title: new Text('My Groups'),
              icon: GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => myothergroups()),);
                  },
                  child: new Icon(Icons.people,color: Color(0xFFc84333),)
              )
          ),
          new BottomNavigationBarItem(
              title: new Text('Groups Available'),
              icon: GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => groupsavailable()),);
                  },
                  child: new Icon(Icons.group_work,color: Color(0xFFc84333))
              )
          ),
        ],
      ),

      body: FutureBuilder(
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
                newsfedid=snapshot.data[index].id.toString();
                creatorid=snapshot.data[index].id.toString();
                groupid=snapshot.data[index].id.toString();
                return Column(
                  children: <Widget>[
                    Container(
                      color:  Color(0xFFc84333),

                      margin: EdgeInsets.only(left: 2.0,right: 2.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(

                            title: Text(
                              snapshot.data[index].groupname,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,

                              ),
                            ),
                            trailing:   CircleAvatar(
                              backgroundColor: Color(0xFFc84333),
                                child: GestureDetector(
                                  onTap:_performJoining,
                                    child: new Icon(Icons.add_circle,color: Colors.white,))),

                          ),
                        ],

                      ),
                    ),
                    ListTile(

                      subtitle: Container(
                        child: Text(snapshot.data[index].about,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,

                          ),),
                      ),

                      /* onTap: (){
                        Navigator.push(context,
                            new MaterialPageRoute(builder:
                                (context)=> UserDetailPage(snapshot.data[index])
                            )
                        );
                      },*/
                    ),
                  ],
                );



              },
            );
          }
        },
      ),

    );
  }
}

class Groups{

  final int id;
  final String groupname;
  final String about;
  final String dates;

  Groups(this.id, this.groupname,this.about,this.dates);


}