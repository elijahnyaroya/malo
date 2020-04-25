import 'dart:convert';

import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

void main()=>(runApp(Signup2()));

class Signup2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFB415B),
      ),
      title: "Sign Up",
      home: Register2(),
    );
  }
}

class Register2 extends StatefulWidget {

  final user_fname;
  final user_lname;
  final user_phone;
  final user_email;

  const Register2({Key key, this.user_fname, this.user_lname, this.user_phone, this.user_email}) : super(key: key);


  @override
  _Register2State createState() => _Register2State();
}

class _Register2State extends State<Register2> {

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

  String _country;
  String _place;
  String _user;
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

    if(_pass2!=_pass){
      final snackbar = new SnackBar(
        content: new Text("Your Password are not matching"),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    }else{
      _login();
    }

  }

  TextEditingController country = new TextEditingController();
  TextEditingController place = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController pass2 = new TextEditingController();

  Future<List> _login() async{

    final response = await http.post(URL_CONNECTOR+"register.php", body: {
      "state":country.text,
      "place":place.text,
      "username":username.text,
      "password":pass.text,

      "lname":widget.user_lname,
      "fname":widget.user_fname,
      "phone":widget.user_phone,
      "email":widget.user_email,
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
                    prefixIcon: Icon(Icons.flag,color: Colors.white,),
                    //labelText: "Username",
                    hintText: "Your country",
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

                  controller: country,
                  validator: (val) =>
                  val.length < 2 ? 'Required' : null,
                  onSaved: (val) => _country = val,
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
                    prefixIcon: Icon(Icons.location_on,color: Colors.white,),
                    hintText: "Your place",
                    hintStyle: TextStyle(color: Colors.white),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFFc84333).withOpacity(0.9),
                  ),

                  controller: place,
                  validator: (val) =>
                  val.length < 3 ? 'Required' : null,
                  onSaved: (val) => _place = val,
                ),
                SizedBox(height:15.0),

                ///////////////////////////////////////////////////////// Phone no
                new TextFormField(
                  style: TextStyle(
                    fontSize: 17.0,
                      color: Colors.white
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.person,color: Colors.white,),
                    //labelText: "Username",
                    hintText: "Your username",
                    hintStyle: TextStyle(color: Colors.white),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23.0),

                    ),
                    filled: true,
                    fillColor: Color(0xFFc84333).withOpacity(0.9),
                  ),

                  controller: username,
                  validator: (val) =>
                  val.length < 3 ? 'Required' : null,
                  onSaved: (val) => _user = val,
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
                ///////////////////////////////////  password 2
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
                      icon: _isHidden2 ?Icon(Icons.visibility_off,color: Colors.white,) : Icon(Icons.visibility,color: Colors.white,),
                      onPressed: _toggleVisibility2,
                    ),
                    //labelText: "Username",
                    hintText: "Confirm password",
                    hintStyle: TextStyle(color: Colors.white),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFFc84333).withOpacity(0.9),
                  ),
                  controller: pass2,
                  validator: (val) =>
                  val.length < 6 ? 'Password too short' : null,
                  onSaved: (val) => _pass2 = val,
                  obscureText:  _isHidden2,

                ),
                SizedBox(height:25.0),
                ///////////////////////////////////////// button
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
                        "SIGN UP",
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
                        Text("Already have an account?",style:TextStyle(color:  Color(0xFFc84333),fontWeight: FontWeight.bold)),
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

