import 'package:africa_women_in_europe/AweMain/dashboard.dart';
import 'package:africa_women_in_europe/More/BlogpostExpand.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main()=>runApp(BlogPostPage());

class BlogPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AWE",
      debugShowCheckedModeBanner: false,
      home: BlogPost(),

    );
  }
}

class BlogPost extends StatefulWidget {
  @override
  _BlogPostState createState() => _BlogPostState();
}

class _BlogPostState extends State<BlogPost> {

  Future<List<Users>>_getUsers() async {
    var data = await http.get(URL_CONNECTOR+"pullblogdata.php");

    var jsonData = json.decode(data.body);

    List<Users> user = [];

    for(var u in jsonData){
      Users users = Users(u["id"],u[ "image"], u[ "heading"], u[ "blog"], u[ "days"],u[ "category"]);

      user.add(users);
    }

    print(user.length);
    print("DATA RESPONSE33 " + data.body);
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
          leading:    IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Dashbord()),);
            },
          ),
          title:Center(child: Text ("AWE Blog Post"))),
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
              padding: EdgeInsets.only(bottom: 50),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){

                return Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: ()=> Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context)=>new blogopostexpands(
                              blog_id:snapshot.data[index].id,
                               blog_category:snapshot.data[index].category,
                              blog_image: snapshot.data[index].image,
                          ))
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 2.0,right: 2.0,),
                        child: Column(
                          children: <Widget>[
                            Card(
                              color: Colors.white,
                              elevation: 2,
                              child: Container(
                                height: 112.0,
                                child: ListTile(
                                  title: Text(
                                    snapshot.data[index].heading,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,

                                    ),
                                  ),
                                  subtitle: Text(snapshot.data[index].blog, style: TextStyle(color: Colors.black,fontSize: 15) ,textAlign: TextAlign.left,),

                                  leading:     Container(
                                      height: 170,
                                      width: 90,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              image: new NetworkImage(
                                                  snapshot.data[index].image)
                                          ))
                                  ),

                                ),
                              ),
                            ),
                          ],

                        ),
                      ),
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

class Users{

  final int id;
  final String image;
  final String heading;
  final String blog;
  final String days;
  final String category;

  Users(this.id, this.image, this.heading, this.blog, this.days, this.category);

}

