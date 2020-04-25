import 'package:africa_women_in_europe/AweMain/dashboard.dart';
import 'package:africa_women_in_europe/AweMain/newsfeeds.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main()=>runApp(NewsfeedExpand());

class NewsfeedExpand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AWE",
      debugShowCheckedModeBanner: false,
      home: newsfeedexpand(),

    );
  }
}

class newsfeedexpand extends StatefulWidget {

  final newsfeed_image;
  final newsfeed_name;
  final newsfeed_message;
  final newsfeed_like;
  final newsfeed_id;

  const newsfeedexpand({Key key, this.newsfeed_image, this.newsfeed_name, this.newsfeed_message, this.newsfeed_like, this.newsfeed_id}) : super(key: key);


  _newsfeedexpandState createState() => _newsfeedexpandState();
}

class _newsfeedexpandState extends State<newsfeedexpand> {

  Future<List<Groups>>_getUsers() async {
    var data = await http.post(URL_CONNECTOR+"pullnewsfeedcomments.php",body: {
      "messageid":widget.newsfeed_id.toString()
    });

    var jsonData = json.decode(data.body);

    List<Groups> user = [];

    for(var u in jsonData){
      Groups users = Groups(u["id"],u[ "name"],u["image"],u["likes"],u["dislikes"],u["comments"],u["dates"]);


      user.add(users);
    }

    print(user.length);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        height: 30.0,
        child: Center(
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Newsfeed()),);
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
      body: new Container(
        padding: EdgeInsets.all(2.0),
        child: Column(
          children: <Widget>[
            Container(
              height:300,
              margin: EdgeInsets.only(top: 20.0,bottom: 20),
               child: Expanded(
                 flex: 1,
                 child: ListTile(
                  leading: Expanded(
                    flex:1,
                    child: Container(
                        width: 60.0,
                        height: 60.0,
                        margin: EdgeInsets.only(top: 6),
                        padding: EdgeInsets.only(top: 10.0,left: 12.0),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    widget.newsfeed_image)
                            ))
                    ),
                  ),

                  title: Text(widget.newsfeed_name,style: TextStyle(color: Colors.black54,fontSize: 17,fontWeight: FontWeight.bold),),
                  subtitle: Column(
                    children: <Widget>[
                      Expanded(
                        flex:2,
                        child: Text(
                          widget.newsfeed_message,
                          style: TextStyle(
                              color: Colors.black54
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.thumb_up,color:Colors.amber,),
                            SizedBox(width: 8,),
                            CircleAvatar(
                              backgroundColor: Colors.amber,
                              radius: 12,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text(widget.newsfeed_like.toString().length>2 ? '99+' : widget.newsfeed_like,style: TextStyle(color: Colors.red,fontSize: 12)),
                                ),
                              ),)
                          ],
                        ),
                      ),

                    ],
                  ),

              ),
               ),
            ),
            Text("Comments Made",style: TextStyle(color: Colors.black54,fontSize: 17,fontWeight: FontWeight.bold),),
            FutureBuilder(
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

                      return Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 2.0,right: 2.0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    snapshot.data[index].name,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,

                                    ),
                                  ),
                                  subtitle: Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].comments,
                                        style: TextStyle(
                                            color: Colors.black54
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.message,color:Colors.amber,),
                                          SizedBox(width: 20,),
                                          Icon(Icons.thumb_up,color:Colors.amber,),
                                          SizedBox(width: 8,),
                                          CircleAvatar(
                                            backgroundColor: Colors.amber,
                                            radius: 12,
                                            child: Padding(
                                              padding: const EdgeInsets.all(1.0),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                //child: new Text(snapshot.data[index].likes,style: TextStyle(color: Colors.red,fontSize: 12),),
                                                child: Text(snapshot.data[index].likes.toString().length>2 ? '99+' : snapshot.data[index].likes,style: TextStyle(color: Colors.red,fontSize: 12)),
                                              ),
                                            ),)
                                        ],
                                      )
                                    ],
                                  ),
                                  trailing: Container(
                                    height: 20,
                                    width: 20,
                                    child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                        snapshot.data[index].image,
                                      ),
                                    ),
                                  ),
                                  isThreeLine: true,


                                ),
                              ],

                            ),
                          ),

                        ],
                      );



                    },
                  );
                }
              },
            )
          ],

        ),
      ),
    );
  }
}


class Groups{

  final int id;
  final name;
  final image;
  final likes;
  final dislikes;
  final comments;
  final dates;

  Groups(this.id, this.name, this.image, this.likes, this.dislikes, this.comments, this.dates);


}

