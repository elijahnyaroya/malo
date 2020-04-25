import 'package:africa_women_in_europe/AweMain/dashboard.dart';
import 'package:africa_women_in_europe/More/newsfeedExpand.dart';
import 'package:africa_women_in_europe/More/newsfeedmakecomments.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Members.dart';
import 'groups.dart';

void main()=>runApp(Newsfeed());

class Newsfeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AWE",
      debugShowCheckedModeBanner: false,
      home: newsfeeds(),

    );
  }
}

class newsfeeds extends StatefulWidget {
  @override
  _newsfeedsState createState() => _newsfeedsState();
}

String newsfedid;
class _newsfeedsState extends State<newsfeeds> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _msg1;
  String _msg2;

  ///////////////// for adding  post
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _submit1() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      performCommenting();
    }
  }

  void performCommenting() {

    if(message1==null){
      final snackbar = new SnackBar(
        behavior: SnackBarBehavior.floating,
        content: new Text("You have not typed anything"),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    }else{
      _comment1();
    }


  }

  TextEditingController message1 = new TextEditingController();
  TextEditingController message2 = new TextEditingController();

  Future<List> _comment1() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';

    final response = await http.post(URL_CONNECTOR+"sendnewsfeedmessage.php", body: {
      "message":message1.text,
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
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext ctx) => Newsfeed()));

      }


    }



  }

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

  // for getting data for news feed
  Future<List<Groups>>_getUsers() async {
    var data = await http.get(URL_CONNECTOR+"pullnewsfeed.php");

    var jsonData = json.decode(data.body);

    List<Groups> user = [];

    for(var u in jsonData){
      Groups users = Groups(u["id"],u[ "fname"],u["lname"],u["image"],u["likes"],u["dislikes"],u["message"],u["dates"]);

      user.add(users);
    }

    print(user.length);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                      ),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0.1,
        leading: GestureDetector(
          onTap: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Dashbord()),);
          },
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        title: Text("News Feeds",
          style: TextStyle(fontSize: 17.0,color: Colors.white),),
        backgroundColor: Colors.red,
      ),
      body: new Container(
         padding: EdgeInsets.all(2.0),
         child: Column(
           children: <Widget>[
            Container(
              height: 90,
              child:  Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          width: 60.0,
                          height: 60.0,
                          margin: EdgeInsets.only(top: 6),
                          padding: EdgeInsets.only(top: 10.0,left: 12.0),
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      'http://crypsol.co.ke/FRESHFARMAPP/sliderimages/vege2.jpg')
                              ))
                      ),

                      SizedBox(width: 20,),

                      Form(
                        key: formKey,
                        child: Expanded(
                          flex: 4,
                          child:   new Container(
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/messageimage.png"), fit: BoxFit.fill)),
                            child: new Stack(alignment: Alignment.center, children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: TextFormField(
                                    maxLines: 40,
                                    scrollPadding: EdgeInsets.all(8),
                                    autocorrect: false,
                                    decoration:
                                    //disable single line border below the text field
                                    new InputDecoration.collapsed(hintText: ''),
                                  controller: message1,
                                  validator: (val) =>
                                  val.length <7 ? '' : null,
                                  onSaved: (val) => _msg1 = val,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:   new Container(
                          child: GestureDetector(
                              onTap:_submit1,
                              child: Icon(Icons.send,color: Colors.black,size: 50,)),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 3,child: Container(color: Colors.red,),),
                ],
              ),
            ),

            Expanded(
              flex: 4,
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
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                      newsfedid=snapshot.data[index].id.toString();
                        return Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 2.0,right: 2.0),
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: ()=> Navigator.of(context).push(
                                        new MaterialPageRoute(builder: (context)=>new newsfeedexpand(
                                            newsfeed_image:snapshot.data[index].image,
                                            newsfeed_name:snapshot.data[index].fname+" "+snapshot.data[index].lname,
                                            newsfeed_message:snapshot.data[index].message,
                                            newsfeed_id:snapshot.data[index].id,
                                        ))
                                    ),
                                    child: ListTile(
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
                                        snapshot.data[index].fname+" "+snapshot.data[index].lname,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,

                                        ),
                                      ),
                                      subtitle: Column(
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index].message,
                                            style: TextStyle(
                                                color: Colors.black54
                                            ),
                                          ),
                                         Row(
                                           children: <Widget>[
                                             GestureDetector(
                                                 onTap: ()=> Navigator.of(context).push(
                                                     new MaterialPageRoute(builder: (context)=>new nesfeedmakecomment(
                                                       newsfeed_image:snapshot.data[index].image,
                                                       newsfeed_name:snapshot.data[index].fname+" "+snapshot.data[index].lname,
                                                       newsfeed_message:snapshot.data[index].message,
                                                       newsfeed_id:snapshot.data[index].id,
                                                     ))
                                                 ),
                                                 child: Icon(Icons.message,color:Colors.amber,)),
                                             SizedBox(width: 20,),
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
              ),
            )
           ],

         ),
      ),
    );
  }
}


class Groups{

  final int id;
  final fname;
  final lname;
  final image;
  final likes;
  final dislikes;
  final message;
  final dates;

  Groups(this.id, this.fname, this.lname, this.image, this.likes, this.dislikes, this.message, this.dates);

}

