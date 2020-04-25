import 'package:africa_women_in_europe/AweMain/BlogPost.dart';
import 'package:africa_women_in_europe/AweMain/dashboard.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/eventstab/pastevents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:africa_women_in_europe/eventstab/eventsExpand.dart';

class blogopostexpands extends StatefulWidget {

  final blog_id;
  final blog_category;
  final blog_image;

  const blogopostexpands({Key key, this.blog_id, this.blog_category, this.blog_image}) : super(key: key);
  @override
  _blogopostexpandsState createState() => _blogopostexpandsState();
}

class _blogopostexpandsState extends State<blogopostexpands> {

  Future<List<Groups>>_getUsers() async {
    final data = await http.post(URL_CONNECTOR + "pullblogdetails.php", body: {
      "blogid":widget.blog_id.toString(),
    });

    var jsonData = json.decode(data.body);

    List<Groups> user = [];

    for(var u in jsonData){
      Groups users = Groups(u["id"],u[ "image"],u["heading"],u["blog1"],u["blog2"],u["days"]);

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
                        color: Colors.black,
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
          title:   GestureDetector(
            onTap: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => BlogPostPage()),);
            },
            child: Text ("Blog Post Detail",
              style: TextStyle(color: Colors.white,),
              textAlign: TextAlign.end,),
          )),
      body:  FutureBuilder(
        future: _getUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot){

          if(snapshot.data == null){
            return Container(
              child: Center(
                //child: Loader(),
                child: Text("loading..."),
              ),
            );
          }else{
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 30.0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){

                return Column(
                  children: <Widget>[
                    Container(
                        height: 200,
                        width: double.infinity,
                        decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    widget.blog_image)
                            ))
                    ),
                    new Container(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text(snapshot.data[index].heading,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(bottom:10.0,left: 10.0,right: 10.0),
                      child: new Text(snapshot.data[index].blog1),
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
  final image;
  final heading;
  final blog1;
  final blog2;
  final days;

  Groups(this.id, this.image, this.heading, this.blog1, this.blog2, this.days);


}