import 'package:africa_women_in_europe/AweMain/dashboard.dart';
import 'package:africa_women_in_europe/AweMain/newsfeeds.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


void main()=>runApp(NewsfeedMakecomends());

class NewsfeedMakecomends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AWE",
      debugShowCheckedModeBanner: false,
      home: nesfeedmakecomment(),

    );
  }
}

class nesfeedmakecomment extends StatefulWidget {

  final newsfeed_image;
  final newsfeed_name;
  final newsfeed_message;
  final newsfeed_like;
  final newsfeed_id;

  const nesfeedmakecomment({Key key, this.newsfeed_image, this.newsfeed_name, this.newsfeed_message, this.newsfeed_like, this.newsfeed_id}) : super(key: key);


  _nesfeedmakecommentState createState() => _nesfeedmakecommentState();
}

class _nesfeedmakecommentState extends State<nesfeedmakecomment> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _msg1;

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

    _sendcomment();

  }

  TextEditingController message = new TextEditingController();

  Future<List> _sendcomment() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';

    final response = await http.post(URL_CONNECTOR+"sentcomentmessage.php", body: {
      "message":message.text,
      "myaidno":userlogedinid,
      "msgid":widget.newsfeed_id.toString(),
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
            MaterialPageRoute(builder: (BuildContext ctx) => Newsfeed()));

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
        title: Text("Make Comment",
          style: TextStyle(fontSize: 17.0,color: Colors.white),),
        backgroundColor: Colors.red,
      ),
      body: new Container(
        padding: EdgeInsets.all(2.0),
        child: Column(
          children: <Widget>[
            Container(

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

                  title: Text("You are commenting on "+widget.newsfeed_name+" post",style: TextStyle(color: Colors.black54,fontSize: 17,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Form(
              key: formKey,
              child: Container(
                height: 150,
                padding: EdgeInsets.only(left: 10,right: 10.0),
                child: TextFormField(
                  cursorColor: Colors.red,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 1000,
                  decoration: new InputDecoration(
                    labelText: "Message",
                    hintText: "Message",
                    hintStyle: TextStyle(color: Colors.white),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),

                    ),

                  ),
                  controller: message,
                  validator: (val) =>
                  val.length <7 ? '' : null,
                  onSaved: (val) => _msg1 = val,
                ),
              ),
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
                          Color(0xFFEE5623),
                          Color(0xFFEE5623),
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft
                    )
                ),
                child: Center(
                  child: Text(
                    "SEND",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0
                    ),
                  ),
                ),

              ),
            ),
            SizedBox(height:20.0),
          ],

        ),
      ),
    );
  }
}


