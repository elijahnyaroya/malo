import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:africa_women_in_europe/myprofilemore/expandmygroup.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dashboard.dart';

class MyGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: mygroups(),

    );
  }
}

class mygroups extends StatefulWidget {
  @override
  _mygroupsState createState() => _mygroupsState();
}

class _mygroupsState extends State<mygroups> {


  Future<List<Groups>>_getUsers() async {
    var data = await http.get(URL_CONNECTOR+"mygroups.php");

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
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        height: 30.0,
        child: Center(
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashbord()),);

                },
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: new Icon(Icons.arrow_back_ios,color: Colors.black,)),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text("Back",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
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
          backgroundColor: Colors.red,
          title:Center(child: Text ("AWE Groups"))),
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
                      color: Colors.red,

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
                                    page_from:"groups",
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


                            /* onTap: (){
                              Navigator.push(context,
                                  new MaterialPageRoute(builder:
                                      (context)=> UserDetailPage(snapshot.data[index])
                                  )
                              );
                            },*/
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