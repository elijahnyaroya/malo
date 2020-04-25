import 'dart:convert';

import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:africa_women_in_europe/eventstab/upcomingevent.dart';
import 'package:flutter/material.dart';
import 'package:africa_women_in_europe/AweMain/newsfeeds.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:http/http.dart' as http;

import 'BlogPost.dart';
import 'Members.dart';
import 'Myprofilearea.dart';
import 'groups.dart';

void main()=>runApp(Dashbord());

class Dashbord extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Dashboard",
      theme: new ThemeData(),
      home: new dashboard(),

      routes: <String,WidgetBuilder>{
        '/Dashboard':(BuildContext context)=> new Dashbord(),
        '/Group':(BuildContext context)=> new GroupMember(),
      },
    );
  }
}

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {

  SharedPreferences sharedPreferences;
  String  _myid="";
  String  _myname="";
  String  _mypic="";

  @override
  void initState() {
    //checkLoginStatus().then(updateUser) ;
    super.initState();

  }



  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _myid = sharedPreferences.getString("userloggedinid");
    _myname = sharedPreferences.getString("name");
    _mypic = sharedPreferences.getString("image");
    if(sharedPreferences.getString("userloggedinid") == null) {
      print("MYID2 "+_myid);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }else{
      print("MYID "+_myid);
      print("Name "+_myname);
      print("Pic "+_mypic);

    }
    return _myname;
  }
  // for getting data for news feed
  Future<List<mydata>>_getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';

    final data = await http.post(URL_CONNECTOR+"getmydata.php",body: {
      "myaidno":userlogedinid
    });

    var jsonData = json.decode(data.body);

    List<mydata> mydatas = [];

    for(var u in jsonData){
      mydata users = mydata(u["id"],u[ "name"],u["image"]);

      mydatas.add(users);
    }

    print("BBBBBB "+userlogedinid);
    print(mydatas.length);

    return mydatas;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,

      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        height:40.0,
        child: Center(
          child: Row(
            children: <Widget>[

              Expanded(
                flex: 2,
                child: Container(

                ),
              ),
              /////
              Expanded(
                flex: 3,
                child: GestureDetector(
                  child: Center(
                    child: Container(
                      height: 55.0,
                      child: Expanded(
                        flex: 1,
                        child: Row(
                          textDirection: TextDirection.ltr,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.power_settings_new,
                              color: Colors.black,
                              size: 40,
                            ),
                            SizedBox(width: 6,),
                            Center(
                              child: Text(
                                "Logout",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 34.0,
                                  color: Color(0xFFc84333),
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            )
                          ],
                        ),
                      ),


                    ),
                  ),
                  onTap: (){

                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()),);
                   /* Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
                    sharedPreferences.clear();
                    sharedPreferences.commit();
*/
                    //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => FormPage()), (Route<dynamic> route) => false);

                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(

                ),
              ),
              ///////

            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 25),
              // color: Colors.blue, ADD COLOR FO AWE
              child: Column(
                children: <Widget>[
              /* FutureBuilder(
                    future: _getUsers(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){

                     if(snapshot.data == null){
                        return*/
                     Container(
                          child: Center(
                              child: Container(
                                height:86.0,
                                margin: EdgeInsets.only(top: 40.0,left: 10.0),
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 80.0,
                                        height: 80.0,
                                        padding: EdgeInsets.only(top: 10.0,left: 12.0),
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new  ExactAssetImage("images/profile.jpg"),
                                            ))
                                    ),
                                    Container(
                                      color: Color(0xFFc84333),
                                      height: 50.0,
                                      width: 250.0,
                                      padding: EdgeInsets.only(left: 25.0),
                                      margin: EdgeInsets.only(left: 10.0,top: 15.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            " ",// will work on it
                                            textDirection: TextDirection.ltr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              )
                          ),
                        )
                      /*  }else{
                       return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index){

                            return   Container(
                              height: 92.0,
                              margin: EdgeInsets.only(top: 40.0,left: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 80.0,
                                      height: 80.0,
                                      padding: EdgeInsets.only(top: 10.0,left: 12.0),
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new  NetworkImage(snapshot.data[index].image),
                                          ))
                                  ),
                                  Container(
                                    color: Color(0xFFc84333),
                                    height: 50.0,
                                    width: 250.0,
                                    padding: EdgeInsets.only(left: 25.0),
                                    margin: EdgeInsets.only(left: 10.0,top: 15.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].name,
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            );



                          },
                        );
                      }
                    },
                  ),*/,

                  Container(
                    color: Color(0xFFc84333),
                    height: 4.0,
                    width: double.infinity,
                    child: Row(),
                  ),

                  ///////////////////////////// SEPARETE TO AND BOTTOM

                  Container(
                    height: 92.0,
                    margin: EdgeInsets.only(top: 4.0,left: 2.0),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          padding: EdgeInsets.only(top: 4.0,left: 5.0),
                          child: Image.asset('images/house.png'),
                        ),
                        Container(
                          width: 170.0,
                          height: 70.0,
                          padding: EdgeInsets.only(top: 8.0,left: 3.0),
                          margin: EdgeInsets.only(top: 2.0),
                          child: RaisedButton(
                            color: Color(0xFFc84333),
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(10.0),
                            child: Text("News feed".toUpperCase(),
                              textScaleFactor: 1.5,
                            ),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Newsfeed()),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),


                  Container(
                    height: 92.0,
                    margin: EdgeInsets.only(top: 4.0,left: 2.0),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          padding: EdgeInsets.only(top: 2.0,left: 5.0),
                          child: Image.asset('images/girl.png'),
                        ),
                        Container(
                          width: 170.0,
                          height: 70.0,
                          padding: EdgeInsets.only(top: 8.0,left: 3.0),
                          margin: EdgeInsets.only(top: 2.0),
                          child: RaisedButton(
                            color: Color(0xFFc84333),
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(10.0),
                            child: Text("My Profile".toUpperCase(),
                              textScaleFactor: 1.5,
                            ),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => myprofile()),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  Container(
                    height: 92.0,
                    margin: EdgeInsets.only(top: 2.0,left: 2.0),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          padding: EdgeInsets.only(top: 10.0,left: 5.0),
                          child: Image.asset('images/calendar.png'),
                        ),
                        Container(
                          width: 170.0,
                          height: 70.0,
                          padding: EdgeInsets.only(top: 8.0,left: 3.0),
                          margin: EdgeInsets.only(top: 2.0),
                          child: RaisedButton(
                            color: Color(0xFFc84333),
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Events".toUpperCase(),
                              textScaleFactor: 1.5,
                            ),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UpcomingEvents()),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                          ),
                        ),
                        Container(
                          width: 100.0,
                          height: 150.0,
                          padding: EdgeInsets.only(top: 10.0,left: 5.0),
                          child: GestureDetector(

                              child: Image.asset('images/chat.png')),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 92.0,
                    margin: EdgeInsets.only(top: 2.0,left: 2.0),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          padding: EdgeInsets.only(top: 10.0,left: 5.0),
                          child: Image.asset('images/teamwork.png'),
                        ),
                        Container(
                          width: 170.0,
                          height: 70.0,
                          padding: EdgeInsets.only(top: 8.0,left: 3.0),
                          margin: EdgeInsets.only(top: 2.0),
                          child: RaisedButton(
                            color:Color(0xFFc84333),
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Groups".toUpperCase(),
                              textScaleFactor: 1.5,
                            ),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => mygroups()),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),


                  Container(
                    height: 92.0,
                    margin: EdgeInsets.only(top: 2.0,left: 2.0),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          padding: EdgeInsets.only(top: 4.0,left: 5.0),
                          child: Image.asset('images/members22.png'),
                        ),
                        Container(
                          width: 170.0,
                          height: 70.0,
                          padding: EdgeInsets.only(top: 8.0,left: 3.0),
                          margin: EdgeInsets.only(top: 2.0),
                          child: RaisedButton(
                            color:Color(0xFFc84333),
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Members".toUpperCase(),
                              textScaleFactor: 1.5,
                            ),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GroupMember()),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  Container(
                    height: 92.0,
                    margin: EdgeInsets.only(top: 2.0,left: 2.0),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          padding: EdgeInsets.only(top: 4.0,left: 5.0),
                          child: Image.asset('images/blogging.png'),
                        ),
                        Container(
                          width: 170.0,
                          height: 70.0,
                          padding: EdgeInsets.only(top: 8.0,left: 3.0),
                          margin: EdgeInsets.only(top: 2.0),
                          child: RaisedButton(
                            color: Color(0xFFc84333),
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Blog Post".toUpperCase(),
                              textScaleFactor: 1.5,
                            ),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BlogPostPage()),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateUser(String userid,String myname1,String mypic1){
    setState(() {
      this._myid = userid;
      this._myname = myname1;
      this._mypic = mypic1;
    });
  }




}

class mydata{

  final int id;
  final name;
  final image;

  mydata(this.id, this.name, this.image);





}