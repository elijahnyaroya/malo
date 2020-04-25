import 'dart:convert';

import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:africa_women_in_europe/auth/signup2.dart';

import '../main.dart';

void main()=>(runApp(Signup()));

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFB415B),
      ),
      title: "Sign Up",
      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool _isHidden= true;
  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  bool _isHidden2= true;
  void _toggleVisibility2(){
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _fname;
  String _lname;
  String _phone;
  String _email;
  String _pass;
  String _pass2;

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

      performLogin();
    }
  }

  void performLogin() {

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => Register2(
          user_fname:fname.text,
          user_lname:lname.text,
          user_phone:phone.text,
          user_email:email.text,
        )));

  }

  TextEditingController phone = new TextEditingController();
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
  TextEditingController email = new TextEditingController();


  Future<List> _login() async{
    SharedPreferences loggedin_userID = await SharedPreferences.getInstance();
    SharedPreferences myname = await SharedPreferences.getInstance();
    SharedPreferences mypic = await SharedPreferences.getInstance();

    final response = await http.post(URL_CONNECTOR+"register.php", body: {
      "fname":fname.text,
      "lname":lname.text,
      "phone":phone.text,
      "password":email.text,
    });

    print(response.body);

    var datauser = json.decode(response.body);
    String values = datauser[0]['message'] ;

    if(datauser.length == 0){
      final snackbar = new SnackBar(
        content: new Text(values),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);

    }else{
      if(datauser[0]['code']=="Fail"){
        final snackbar = new SnackBar(
          content: new Text(values),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);

      }else if(datauser[0]['code']=="success"){
        final snackbar = new SnackBar(
          content: new Text(values),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);
        //Navigator.pushReplacementNamed(context,  '/App');

        showDialog(context: context,
            builder: (context){
              return new AlertDialog(
                content: new Text(values),
                actions: <Widget>[
                  new MaterialButton(onPressed: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext ctx) => App()));
                  },
                    child: new Text("Ok"),
                  ),
                ],
              );
            });


      }


    }



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        padding: EdgeInsets.only(top:35.0,right: 20.0,left: 20.0,bottom: 1.0),
        child: SingleChildScrollView(
          child: Form(
           key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "SIGN UP ",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Pasifico",
                      color:Color(0xFFc84333)
                  ),
                ),
                SizedBox(height: 10.0,),

                 /////////////////////////////////// First name
                 new TextFormField(
                  style: TextStyle(
                    fontSize: 17.0,
                      color: Colors.white
                  ),

                  maxLines: 1,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.person,color: Colors.white,),
                    //labelText: "Username",
                    hintText: "First Name",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFFc84333).withOpacity(0.9),
                  ),

                  controller: fname,
                  validator: (val) =>
                  val.length < 3 ? 'Required' : null,
                  onSaved: (val) => _fname = val,
                ),
                SizedBox(height:15.0),

               ////////////////////////// Last name
               new TextFormField(
                  style: TextStyle(
                    fontSize: 17.0,
                      color: Colors.white
                  ),

                  maxLines: 1,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.person,color: Colors.white,),
                    hintText: "Last Name",
                    hintStyle: TextStyle(color: Colors.white),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFFc84333).withOpacity(0.9),
                  ),

                  controller: lname,
                 validator: (val) =>
                  val.length < 3 ? 'Required' : null,
                  onSaved: (val) => _lname = val,
                ),
                SizedBox(height:15.0),

                ///////////////////////////////////////////////////////// Phone no
                new TextFormField(
                  style: TextStyle(
                    fontSize: 17.0,
                      color: Colors.white
                  ),
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.email,color: Colors.white,),
                    //labelText: "Username",
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.white),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23.0),

                    ),
                    filled: true,
                    fillColor: Color(0xFFc84333).withOpacity(0.9),
                  ),

                  controller: email,
                  validator: (val) =>
                  val.length < 3 ? 'Required' : null,
                  onSaved: (val) => _email = val,
                ),
                SizedBox(height:15.0),

                /////////////////////////// password 1
                new TextFormField(
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white
                  ),

                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.dialpad,color: Colors.white,),

                    hintText: "Phone (+22270000000)",
                    hintStyle: TextStyle(color: Colors.white),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFFc84333).withOpacity(0.9),
                  ),

                  controller: phone,
                  validator: (val) =>
                  val.length < 3 ? 'Required' : null,
                  onSaved: (val) => _phone = val,
                ),
                SizedBox(height:15.0),

                 ///////////////////////////////////  password 2
                SizedBox(height:25.0),
                ///////////////////////////////////////// button
                GestureDetector(
                  //onTap:_submit,
                  onTap: _submit,
                  child: Container(
                    height: 56.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23.0),
                        gradient: LinearGradient(
                            colors: [
                              Color(0xFFc84333),
                              Color(0xFFc84333),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerLeft
                        )
                    ),
                    child: Center(
                      child: Text(
                        "NEXT",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0
                        ),
                      ),
                    ),

                  ),
                ),
                SizedBox(height:20.0),
                Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account?",style: TextStyle(color:  Color(0xFFc84333),fontWeight: FontWeight.bold),),
                        SizedBox(width:10.0),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LoginPage()),);
                          },
                          child: Text("SIGN IN",
                            style: TextStyle(
                              color:  Color(0xFFc84333),
                                fontWeight: FontWeight.bold
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*Widget buildButtonContainer2(){
  return GestureDetector(
    onTap: _submit,
    child: Container(
      height: 56.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23.0),
          gradient: LinearGradient(
              colors: [
                Color(0xFFFB415B),
                Color(0xFFEE5623),
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft
          )
      ),
      child: Center(
        child: Text(
          "SIGN UP ",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0
          ),
        ),
      ),


    ),
  );

}*/

