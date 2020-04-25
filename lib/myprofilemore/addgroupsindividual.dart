import 'package:africa_women_in_europe/AweMain/Myprofilearea.dart';
import 'package:africa_women_in_europe/AweMain/dashboard.dart';
import 'package:africa_women_in_europe/AweMain/groups.dart';
import 'package:africa_women_in_europe/AweMain/newsfeeds.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:africa_women_in_europe/myprofilemore/expandmygroup.dart';

import 'expandmygroup.dart';
import 'myothergroups.dart';


void main()=>runApp(Addgroupindividual());

class Addgroupindividual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AWE",
      debugShowCheckedModeBanner: false,
      home: addgroupindividual(),

    );
  }
}

class addgroupindividual extends StatefulWidget {

  _addgroupindividualState createState() => _addgroupindividualState();
}

class _addgroupindividualState extends State<addgroupindividual> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _grp1;
  String _abt;

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

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      performOperation();
    }
  }

  void performOperation() {

    if(about.toString().length<10)
      {

        final snackbar = new SnackBar(
          behavior: SnackBarBehavior.floating,
          content: new Text("About group must be more than ten characters"),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);

      }else{
      _sendcomment();
    }


  }

  TextEditingController about = new TextEditingController();
  TextEditingController groupname = new TextEditingController();

  Future<List> _sendcomment() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';

    final response = await http.post(URL_CONNECTOR+"creategroup.php", body: {
      "about":about.text,
      "groupname":groupname.text,
      "myaidno":userlogedinid,

    });

    print("RESPONSE 5 "+response.body);


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
                        color: Color(0xFFc84333),
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
        title: Text("Create Group",
          style: TextStyle(fontSize: 17.0,color: Colors.white),),
        backgroundColor:  Color(0xFFc84333),
      ),
      body: new Container(
        margin: EdgeInsets.only(bottom: 40,left: 10,right: 10),
        padding: EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("Create your group",style: TextStyle(color:Color(0xFFc84333),fontWeight: FontWeight.bold ),),

                      ],
                    ),
                     SizedBox(height: 20,),
                      TextFormField(
                      cursorColor:  Color(0xFFc84333),
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: new InputDecoration(
                        hintText: "Group Name",
                        hintStyle: TextStyle(color: Colors.black),
                        hintMaxLines: 1,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),

                        ),

                      ),
                      controller: groupname,
                      validator: (val) =>
                      val.length <3 ? 'This field is reguired' : null,
                      onSaved: (val) => _grp1 = val,
                    ),

                   SizedBox(height: 10,),
                   Row(
                     children: <Widget>[
                       Text("About the group",style: TextStyle(color:Color(0xFFc84333),fontWeight: FontWeight.bold ),),
                       SizedBox(height: 10,)
                     ],
                   ),
                    SizedBox(height: 10,),
                   TextFormField(
                      cursorColor:  Color(0xFFEE5623),
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      decoration: new InputDecoration(

                        hintStyle: TextStyle(color: Colors.white),
                        hintMaxLines: 1,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),

                        ),

                      ),
                      controller: about,
                      validator: (val) =>
                      val.length <7 ? 'This field is reguired' : null,
                      onSaved: (val) => _abt = val,
                    ),

                    SizedBox(height:20.0),
                    GestureDetector(
                      onTap:_submit,
                      child: Container(
                        height: 56.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17.0),
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xFFc84333),
                                  Color(0xFFc84333)
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft
                            )
                        ),
                        child: Center(
                          child: Text(
                            "CTREATE",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0
                            ),
                          ),
                        ),

                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height:20.0),
            ],

          ),
        ),
      ),
    );
  }
}


