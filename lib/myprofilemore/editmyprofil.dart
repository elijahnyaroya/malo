import 'dart:convert';

import 'package:africa_women_in_europe/AweMain/Myprofilearea.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:africa_women_in_europe/eventstab/moreevents/ScheduleEvent.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/eventstab/pastevents.dart';
import 'package:africa_women_in_europe/eventstab/upcomingevent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Profiledata.dart';





class Editmyprofile extends StatefulWidget {
  final my_id;
  final my_fname;
  final my_lname;
  final my_image;
  final my_phone;
  final my_email;
  final my_country;
  final my_place;
  final my_about;

  const Editmyprofile({Key key, this.my_id, this.my_fname, this.my_lname, this.my_image, this.my_phone, this.my_email, this.my_country, this.my_place, this.my_about}) : super(key: key);


  @override
  _EditmyprofileState createState() => _EditmyprofileState();
}

class _EditmyprofileState extends State<Editmyprofile> {

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
            MaterialPageRoute(builder: (BuildContext ctx) => ProfileData()));

      }


    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfaf4f1),
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
                          color:  Color(0xFFc84333),
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
        elevation: 0.1,
        leading: GestureDetector(
          onTap: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => myprofile()),);

          },
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        title: Text( "Edit Profile",
          style: TextStyle(fontSize: 17.0,color: Colors.white),),
        backgroundColor:  Color(0xFFc84333),
      ),

      body: Column(
        children: <Widget>[

          SingleChildScrollView(
            child: Container(
              height: 480,
               child: Column(
            children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 2.0,right: 2.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage("${widget.my_image}")
                                  ))
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Center(
                        child: Row(
                          children: <Widget>[
                            TextFormField(
                              maxLines: 1,
                              scrollPadding: EdgeInsets.all(8),
                              autocorrect: false,

                              decoration:
                              //disable single line border below the text field
                              new InputDecoration.collapsed(
                                  hintText: '${widget.my_fname}"',

                              ),
                              controller: message1,
                              validator: (val) =>
                              val.length <7 ? '' : null,
                              onSaved: (val) => _msg1 = val,
                            ),

                            Text(
                              "${widget.my_fname}"+" "+"${widget.my_lname}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,

                              ),
                            ),
                            SizedBox(width: 10,),
                            GestureDetector(

                                child: Icon(Icons.edit,color:  Color(0xFFc84333),size: 20,))
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),

                  subtitle: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("About ",style: TextStyle(color: Colors.red,fontSize: 20.0),textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Divider(color: Colors.red,),
                        Text(widget.my_about,style: TextStyle(color: Colors.black)),
                        Divider(color: Colors.red,),
                        Row(
                          children: <Widget>[
                            Icon(Icons.dialpad,color: Colors.black),
                            SizedBox(width: 10.0,),
                            Text(widget.my_phone,style: TextStyle(color :Colors.black,fontSize: 18.0),)

                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: <Widget>[
                            Icon(Icons.mail,color: Colors.black,),
                            SizedBox(width: 10.0,),
                            Text(widget.my_email,style: TextStyle(color: Colors.black,fontSize: 18),)

                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: <Widget>[
                            Icon(Icons.flag,color: Colors.black,),
                            SizedBox(width: 10.0,),
                            Text(widget.my_country,style: TextStyle(color: Colors.black,fontSize: 18),)

                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on,color: Colors.black,),
                            SizedBox(width: 10.0,),
                            Text(widget.my_place,style: TextStyle(color: Colors.black,fontSize: 18),)

                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: <Widget>[
                            Icon(Icons.calendar_today,color: Colors.black,),
                            SizedBox(width: 10.0,),
                            Text(widget.my_country,style: TextStyle(color: Colors.black,fontSize: 18),)

                          ],
                        )

                      ],
                    ),
                  ),


                ),
              ],

            ),
          ),

        ],

              ),
            ),
          )

        ],

      ),

    );
  }
}

