import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'AweMain/Members.dart';
import 'AweMain/dashboard.dart';
import 'auth/resetpassword.dart';
import 'auth/signup.dart';



ProgressDialog pr;
void main()=> runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFB415B),
      ),
      home: LoginPage(),
      title: "AWE",
    /*  routes: <String,WidgetBuilder>{
        '/Dashboard':(BuildContext context)=> new Dashbord(),
        '/Group':(BuildContext context)=> new GroupMember(),
      },*/
    );
  }

}

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String logo = 'images/logo.png';

  /////////////////////////////////////

  SharedPreferences sharedPreferences;
  String  myid;
  String  myname;
  String  mypic;

/*   @override
  void initState() {
    super.initState();
    //checkLoginStatus().then(updateUser);
  }*/



  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    myid = sharedPreferences.getString("userloggedinid");
    myname = sharedPreferences.getString("name");
    mypic = sharedPreferences.getString("image");
    if(sharedPreferences.getString("userloggedinid") == null) {
      print("MYID2 "+myid);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }else{
      print("MYID "+myid);
      print("Name "+myname);
      print("Pic "+mypic);

    }

  }

  //////////////////////////////////

  bool _isHidden= true;
  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _pass;
  String _phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
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



  Future<List> _login() async{


    final response = await http.post(URL_CONNECTOR+"login.php", body: {
      "username":phone.text,
      "password":pass.text,
    });

    print("RESPONSE 5 "+response.body);


    var datauser = json.decode(response.body);
    String userloginId = datauser[0]['idno'] ;
    String values = datauser[0]['message'] ;
    String myname2 = datauser[0]['name'] ;
    String mypic2 = datauser[0]['image'] ;
    String codes = datauser[0]['Fail'] ;


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
        SharedPreferences loggedin_userID = await SharedPreferences.getInstance();
        SharedPreferences myname = await SharedPreferences.getInstance();
        SharedPreferences mypic = await SharedPreferences.getInstance();
        SharedPreferences phone33 = await SharedPreferences.getInstance();

        loggedin_userID.setString("userloggedinid", userloginId);  //// Get the user id logged in
        myname.setString("image", mypic2);
        mypic.setString("name", myname2);


        final snackbar = new SnackBar(
          behavior: SnackBarBehavior.floating,
          content: new Text(values),
        );
        scaffoldKey.currentState.showSnackBar(snackbar);
        //Navigator.pushReplacementNamed(context,  '../HomePage');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext ctx) => Dashbord()));

      }


    }



  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      bottomSheet: Container(

        height: 50.0,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => setPassword()),);
                },
                child: Text("Forgot your password?",
                textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFFc84333),
                  ),),
              ),
              SizedBox(width:30.0),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Signup()),);
                },
                child: Text("Sign Up here",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFFc84333),
                  ),

                ),
              ),
            ],
          ),
        ),
      ),

      body: Container(
        padding: EdgeInsets.only(top:1.0,right: 20.0,left: 20.0,bottom: 40.0),
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
                Text(
                    "LOGIN",
                    style:TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color:Color(0xFFc84333),

                    )

                ),
                SizedBox(height: 20.0,),
                //////////////////////////////////////////////////////// phone no
                new TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(
                    fontSize: 17.0,
                      color: Colors.white,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.person,color: Colors.white,),
                    //labelText: "Username",
                    hintText: "Username",
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
                  val.length <3 ? 'Username no too short' : null,
                  onSaved: (val) => _phone = val,
                ),

                SizedBox(height:15.0),

                /////////////////////////// password 1
                new TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white
                  ),

                  maxLines: 1,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.lock,color: Colors.white,),
                    suffixIcon: IconButton(
                      icon: _isHidden ?Icon(Icons.visibility_off,color: Colors.white,) : Icon(Icons.visibility,color: Colors.white,),
                      onPressed: _toggleVisibility,
                    ),
                    //labelText: "Username",
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.white),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFFc84333).withOpacity(0.9),
                  ),
                  controller: pass,
                  validator: (val) =>
                  val.length < 6 ? 'Password too short' : null,
                  onSaved: (val) => _pass = val,
                  obscureText:  _isHidden,

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
                              Color(0xFFc84333),
                              Color(0xFFc84333),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerLeft
                        )
                    ),
                    child: Center(
                      child: Text(
                        "LOGIN",
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
        ),
      ),

    );

  }

  void updateUser(String userid,String myname1,String mypic1){
    setState(() {
      this.myid = userid;
      this.myname = myname1;
      this.mypic = mypic1;

    });
  }
}




