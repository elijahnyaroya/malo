import 'package:africa_women_in_europe/AweMain/Myprofilearea.dart';
import 'package:africa_women_in_europe/AweMain/dashboard.dart';
import 'package:africa_women_in_europe/AweMain/groups.dart';
import 'package:africa_women_in_europe/AweMain/newsfeeds.dart';
import 'package:africa_women_in_europe/More/newsfeedmakecomments.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'groupmakecoment.dart';
import 'myothergroups.dart';


void main()=>runApp(Expandedgroup());

class Expandedgroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AWE",
      debugShowCheckedModeBanner: false,
      home: groupexpand2(),

    );
  }
}

class groupexpand2 extends StatefulWidget {

  final mygroup_id;
  final mygroup_groupname;
  final mygroup_about;
  final page_from;

  const groupexpand2({Key key, this.mygroup_id, this.mygroup_groupname, this.mygroup_about, this.page_from}) : super(key: key);

  _groupexpand2State createState() => _groupexpand2State();
}

class _groupexpand2State extends State<groupexpand2> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  // for like the post
  void _performLiking() {
    _like();

  }
  Future<List> _like() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';

    final response = await http.post(URL_CONNECTOR+"likes.php", body: {
      "msgid":newsfedid,
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
    var data = await http.post(URL_CONNECTOR+"pullgroupcomments.php",body: {
      "groupid":widget.mygroup_id.toString(),
    });

    var jsonData = json.decode(data.body);

    List<Groups> user = [];

    for(var u in jsonData){
      Groups users = Groups(u["id"],u[ "image"],u["name"],u["comment"],u["dates"],u["likes"],u["dislikes"]);



      user.add(users);
    }

    print(user.length);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
        appBar: AppBar(
          elevation: 0.1,
          leading: GestureDetector(
            onTap: (){
              if(widget.page_from=="myothergroup"){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => myothergroups()),);
              }else{
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => mygroups()),);
              }
            },
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(widget.mygroup_groupname,
            style: TextStyle(fontSize: 17.0,color: Colors.white),),
          backgroundColor: Color(0xFFc84333),
        ),
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        height: 30.0,
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
                      ),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: new Scaffold(
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
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){

                  return Container(
                    height: 500,
                    color: Color(0xFFfaf4f1),
                    padding: EdgeInsets.all(6),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,

                          child: Column(
                            children: <Widget>[
                              Text("${widget.mygroup_about}",style: TextStyle(color: Colors.black,fontSize: 17),),
                             SizedBox(height: 10,),
                              Container(
                                child:ListTile(
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
                                    snapshot.data[index].name,

                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,

                                    ),
                                  ),

                                  subtitle: Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].comment,
                                        style: TextStyle(
                                            color: Colors.black54
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                              onTap: ()=> Navigator.of(context).push(
                                                  new MaterialPageRoute(builder: (context)=>new groupmakecomment(
                                                    newsfeed_image:snapshot.data[index].image,
                                                    newsfeed_name:snapshot.data[index].name,
                                                    newsfeed_message:snapshot.data[index].comment,
                                                    newsfeed_id:snapshot.data[index].id,
                                                    page_from:widget.page_from,
                                                  ))
                                              ),
                                              child: Icon(Icons.message,color:Colors.amber,)),
                                          SizedBox(width: 10,),
                                          GestureDetector(
                                              onTap:_performLiking,
                                              child: Icon(Icons.thumb_up,color:Colors.amber,)),
                                          SizedBox(width: 8,),
                                          CircleAvatar(
                                            backgroundColor: Colors.amber,
                                            radius: 12,
                                            child: Padding(
                                              padding: const EdgeInsets.all(1.0),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.amber,
                                                //child: new Text(snapshot.data[index].likes,style: TextStyle(color: Colors.red,fontSize: 12),),
                                                child: Text(snapshot.data[index].likes.toString().length>2 ? '99+' : snapshot.data[index].likes,style: TextStyle(color: Colors.red,fontSize: 12)),
                                              ),
                                            ),)
                                        ],
                                      )
                                    ],
                                  ),
                                  isThreeLine: true,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      )
    );
  }
}



class Groups{

  final int id;
  final String image;
  final String name;
  final String comment;
  final String dates;
  final String likes;
  final String dislikes;

  Groups(this.id, this.image, this.name, this.comment, this.dates, this.likes, this.dislikes);




}