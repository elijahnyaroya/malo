import 'package:africa_women_in_europe/AweMain/Myprofilearea.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:africa_women_in_europe/myprofilemore/groupsavalable.dart';

import 'expandmygroup.dart';


class MyotherGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: myothergroups(),

    );
  }
}

class myothergroups extends StatefulWidget {
  @override
  _myothergroupsState createState() => _myothergroupsState();
}

class _myothergroupsState extends State<myothergroups> {


  Future<List<Groups>>_getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';
    var data = await http.post(URL_CONNECTOR+"pullmygroups.php",body: {
      "myaidno":userlogedinid,
    });

    var jsonData = json.decode(data.body);

    List<Groups> user = [];

    for(var u in jsonData){
      Groups users = Groups(u["id"],u[ "groupname"],u["about"]);

      user.add(users);
    }

    print(user.length);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
          backgroundColor:  Color(0xFFc84333),
          title:Center(
            child: Row(
              children: <Widget>[

                Text ("My Groups",
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
                            trailing:   GestureDetector(

                              onTap: ()=> Navigator.of(context).push(
                                  new MaterialPageRoute(builder: (context)=>new groupexpand2(
                                    mygroup_id:snapshot.data[index].id,
                                    mygroup_groupname:snapshot.data[index].groupname,
                                    mygroup_about:snapshot.data[index].about,
                                    page_from:"myothergroup",
                                  ))
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: new Icon(Icons.arrow_forward_ios,color: Colors.black,)),
                                ),
                              ),
                            ),

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

  Groups(this.id, this.groupname,this.about);


}