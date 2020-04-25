import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';



void main()=>runApp(setPassword2());

class setPassword2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFB415B),
      ),
      home: SecondPageResetpass(),
      title: "Login",
    );
  }
}

class SecondPageResetpass extends StatefulWidget {
  @override
  _SecondPageResetpassState createState() => _SecondPageResetpassState();
}

class _SecondPageResetpassState extends State<SecondPageResetpass> {

  final String logo = 'images/logo.png';


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

  String _pass;
  String _pass2;
  String _phone;

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

    _login();

  }

  TextEditingController phone = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController pass2 = new TextEditingController();

  Future<List> _login() async{

    SharedPreferences loggedin_userID = await SharedPreferences.getInstance();
    SharedPreferences myname = await SharedPreferences.getInstance();
    SharedPreferences mypic = await SharedPreferences.getInstance();

    final response = await http.post(URL_CONNECTOR+"login.php", body: {
      "phone":phone.text,
    });

    print(response.body);

    var datauser = json.decode(response.body);
    String userloginId = datauser[0]['idno'] ;
    String values = datauser[0]['message'] ;
    String myname2 = datauser[0]['name'] ;
    String mypic2 = datauser[0]['image'] ;

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


        loggedin_userID.setString("userloggedinid", userloginId);  //// Get the user id logged in
        myname.setString("image", mypic2);
        mypic.setString("name", myname2);


        Navigator.pushReplacementNamed(context,  '/Dashboard');
        final snackbar = new SnackBar(
          content: new Text(values),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);
      }


    }



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        padding: EdgeInsets.only(top:1.0,right: 20.0,left: 20.0,bottom: 1.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: 200.0,
                    width: 200.0,
                    child: Image.asset(logo)
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              "Password",
                              style:TextStyle(
                                  fontFamily: "Pasifico",
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor
                              )
                          ),
                          SizedBox(width: 10.0,),
                          Text(
                              "Reset",
                              style:TextStyle(
                                fontFamily: "Pasifico",
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF24421f),
                              )
                          ),
                        ],
                      ),

                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Please reset your password.",
                              style: TextStyle(
                                  color: Color(0xFF24421f),
                                  fontSize: 13.0
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                //////////////////////////////////////////////////////// phone no
                new TextFormField(
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.dialpad,color: Colors.grey,),
                    //labelText: "Username",
                    hintText: "OTP",
                    hintStyle: TextStyle(color: Colors.grey),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23.0),

                    ),

                  ),

                  controller: phone,
                  validator: (val) =>
                  val.length <3 ? '' : null,
                  onSaved: (val) => _phone = val,
                ),

                SizedBox(height:15.0),
                new TextFormField(
                  style: TextStyle(
                    fontSize: 17.0,
                  ),

                  maxLines: 1,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.lock,color: Colors.grey,),
                    suffixIcon: IconButton(
                      icon: _isHidden ?Icon(Icons.visibility_off) : Icon(Icons.visibility),
                      onPressed: _toggleVisibility,
                    ),
                    //labelText: "Username",
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23.0),
                    ),

                  ),
                  controller: pass,
                  validator: (val) =>
                  val.length < 6 ? 'Password too short' : null,
                  onSaved: (val) => _pass = val,
                  obscureText: _isHidden,
                ),
                SizedBox(height:15.0),

                ///////////////////////////////////  password 2
                new TextFormField(
                  style: TextStyle(
                    fontSize: 17.0,
                  ),

                  maxLines: 1,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.lock,color: Colors.grey,),
                    suffixIcon: IconButton(
                      icon: _isHidden2 ?Icon(Icons.visibility_off) : Icon(Icons.visibility),
                      onPressed: _toggleVisibility2,
                    ),
                    //labelText: "Username",
                    hintText: "Password Again",
                    hintStyle: TextStyle(color: Colors.grey),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23.0),
                    ),
                  ),

                  controller: pass2,
                  validator: (val) =>
                  val.length < 6 ? 'Password too short' : null,
                  onSaved: (val) => _pass2 = val,
                  obscureText: _isHidden2,
                ),
                SizedBox(height:15.0),
                ///////////////////////////// button
                GestureDetector(
                  onTap:_submit,
                  child: Container(
                    height: 56.0,
                    width: MediaQuery.of(context).size.width,
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
                        "RESET PASSWORD",
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
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()),);
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Go back to Sign In",
                            style: TextStyle(
                              color: Color(0xFF24421f),
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,

                            ),),
                        ],
                      ),
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


