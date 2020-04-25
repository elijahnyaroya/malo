import 'dart:convert';

import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:africa_women_in_europe/eventstab/upcomingevent.dart';
import 'package:africa_women_in_europe/myprofilemore/Profiledata.dart';
import 'package:africa_women_in_europe/myprofilemore/addfriends.dart';
import 'package:africa_women_in_europe/myprofilemore/addgroupsindividual.dart';
import 'package:africa_women_in_europe/myprofilemore/myfriends.dart';
import 'package:africa_women_in_europe/myprofilemore/uploadphotos.dart';
import 'package:africa_women_in_europe/myprofilemore/uploadprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:africa_women_in_europe/AweMain/newsfeeds.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';
import 'package:africa_women_in_europe/myprofilemore/myothergroups.dart';

void main()=>runApp(Myprofile());

class Myprofile extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Dashboard",
      theme: new ThemeData(),
      home: new myprofile(),

    );
  }
}

class myprofile extends StatefulWidget {
  @override
  _myprofileState createState() => _myprofileState();
}

String myname;
String myplace;
String mystate;
int pic ;
int comment ;
int blog ;
int like ;
int news ;
class _myprofileState extends State<myprofile> {

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
            MaterialPageRoute(builder: (BuildContext ctx) => myprofile()));

      }


    }



  }

  Future<List<Groups>>_getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';
    var data = await http.post(URL_CONNECTOR+"pullmyactivitiesdata.php", body: {
      "myaidno":userlogedinid,
    });
    var jsonData = json.decode(data.body);

    List<Groups> user = [];

    for(var u in jsonData){
      Groups users = Groups(u["count_newscoment"],u[ "like2"],u["dislike"],u["groupcomment"],u["picture"],u[ "blogcount"],u["name"],u["place"],u["state"]);


      user.add(users);
    }

    print(user.length);
    print("DDDDDD ELIJAH"+data.body);

    return user;
  }

  //// styling Border


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFfaf4f1),
      resizeToAvoidBottomPadding: false,

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
                    MaterialPageRoute(builder: (context) => Dashbord()),);
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 50),
          child: Column(

            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 2),
                // color: Colors.blue, ADD COLOR FO AWE
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 90,
                      margin: EdgeInsets.only(top: 30.0,bottom: 8),
                      padding: EdgeInsets.only(bottom:2 ),
                      child:  Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  width: 80.0,
                                  height: 80.0,
                                  margin: EdgeInsets.only(top: 6),
                                  padding: EdgeInsets.only(top: 10.0,left: 12.0),
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new ExactAssetImage("images/profile.jpg"),
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
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                height: 200,
                color: Color(0xFFfaf4f1),
                child: Scaffold(
                  backgroundColor: Color(0xFFfaf4f1),
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
                            myname=snapshot.data[index].name;
                            myplace=snapshot.data[index].place;
                            mystate=snapshot.data[index].state;
                             pic=snapshot.data[index].picture;
                             comment=snapshot.data[index].groupcomment;
                             blog=snapshot.data[index].blogcount;
                             like=snapshot.data[index].like2;
                             news=snapshot.data[index].count_newscoment;


                            return Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 2.0,right: 2.0),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 10.0,),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                                padding: EdgeInsets.only(left: 10.0),

                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text("Name ",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17),),
                                                        SizedBox(width: 10,),
                                                        Text("${myname}",style: TextStyle(fontSize: 17,color: Color(0xFF272727)),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: <Widget>[
                                                        Text("Place ",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17)),
                                                        SizedBox(width: 10,),
                                                        Text("${myplace}",style: TextStyle(fontSize: 17,color: Color(0xFF272727))),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),

                                                    Row(
                                                      children: <Widget>[
                                                        Text("State ",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17)),
                                                        SizedBox(width: 10,),
                                                        Text("${mystate}",style: TextStyle(fontSize: 17,color: Color(0xFF272727))),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: <Widget>[
                                                        Text("  "),

                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: <Widget>[
                                                        Text("  "),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                  ],
                                                )
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                                padding: EdgeInsets.only(left: 10.0),
                                                color:  Color(0xFFfaf4f1),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 20,
                                                      color:  Color(0xFFc84333),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(width: 10,),
                                                          Text("Profile Information",style: TextStyle(color:Colors.white),),
                                                        ],
                                                      )
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: <Widget>[
                                                        Text("Blogs : ",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17),),
                                                        SizedBox(width: 10,),
                                                        Text(blog.toString(),style: TextStyle(fontSize: 17,color: Color(0xFF272727)),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: <Widget>[
                                                        Text("Likes : ",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17)),
                                                        SizedBox(width: 10,),
                                                        Text( like.toString() ,style: TextStyle(fontSize: 17,color: Color(0xFF272727))),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),

                                                    Row(
                                                      children: <Widget>[
                                                        Text("Comments : ",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17)),
                                                        SizedBox(width: 10,),
                                                        Text("${comment.toString()}",style: TextStyle(fontSize: 17,color: Color(0xFF272727))),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: <Widget>[
                                                        Text("News Feed : ",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17)),
                                                        SizedBox(width: 10,),
                                                        Text("${news.toString()}",style: TextStyle(fontSize: 17,color: Color(0xFF272727))),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: <Widget>[
                                                        Text("Pictures Posted : ",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17)),
                                                        SizedBox(width: 10,),
                                                        Text("${pic.toString()}",style: TextStyle(fontSize: 17,color: Color(0xFF272727))),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                  ],
                                                )
                                            ),
                                          ),
                                        ],
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
                ),

              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(left: 2.0,right: 2.0),
                      color: Color(0xFFfaf4f1),
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => myfriends()),);

                              },
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 10,),
                                  Text("My Friends",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17),),
                                  Text("  ")
                                ],
                              )
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => addfriends()),);

                            },
                            child:Row(
                              children: <Widget>[
                                SizedBox(width: 10,),
                                Text("Add  Friends",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17),),
                                SizedBox(width: 10,),
                                Icon(Icons.add_circle_outline,color: Color(0xFFc84333)),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => myothergroups()),);

                              },
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 10,),
                                  Text("My Photos",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17),),
                                  Text("  ")
                                ],
                              )
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: (){

                            },
                            child:Row(
                              //addgroupindividual
                              children: <Widget>[
                                SizedBox(width: 10,),
                                GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => addgroupindividual()),);

                                    },
                                    child: Text("Add a Group",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17),)),
                                SizedBox(width: 10,),
                                Icon(Icons.add_circle_outline,color: Color(0xFFc84333)),
                              ],
                            ) ,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(left: 2.0,right: 0.0),
                      color: Color(0xFFfaf4f1),
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[

                              GestureDetector(
                                onTap: ()=> Navigator.of(context).push(
                                    new MaterialPageRoute(builder: (context)=>new ProfileData(
                                      user_id:"0",
                                      user_name:myname,
                                      user_image:pic,
                                      page_from:"Myprofle",

                                    ))
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text("Profile Information",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17),),
                                    SizedBox(width: 1,),
                                    Icon(Icons.add_circle_outline,color: Color(0xFFc84333)),
                                  ],
                                ),
                              ) ,
                              SizedBox(height: 14,),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 28,),
                                  GestureDetector(
                                   /* onTap: (){
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => UploadPictures()),);

                                    },
*/
                                      child: Text("My Photos",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17),)),
                                  SizedBox(width: 35,),
                                  Icon(Icons.add_circle_outline,color: Color(0xFFc84333)),
                                ],
                              ) ,
                              SizedBox(height: 14,),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 38,),
                                  GestureDetector(
                                   /*  onTap: (){
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => UploadImageDemo()),);

                                      },*/
                                      child: Text("My Blog",style: TextStyle(color: Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 17),)),
                                  SizedBox(width: 43,),
                                  Icon(Icons.add_circle_outline,color: Color(0xFFc84333)),
                                ],
                              ) ,
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



}

class Groups{

  final count_newscoment;
  final like2;
  final dislike;
  final groupcomment;
  final picture;
  final blogcount;
  final name;
  final place;
  final state;

  Groups(this.count_newscoment, this.like2, this.dislike, this.groupcomment, this.picture, this.blogcount, this.name, this.place, this.state);


}