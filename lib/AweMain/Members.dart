import 'package:africa_women_in_europe/AweMain/dashboard.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main()=>runApp(GroupMember());

class GroupMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AWE",
      debugShowCheckedModeBanner: false,
      home: groupMember(),

    );
  }
}

class groupMember extends StatefulWidget {
  @override
  _groupMemberState createState() => _groupMemberState();
}

class _groupMemberState extends State<groupMember> {

  Future<List<Users>>_getUsers() async {
    var data = await http.get(URL_CONNECTOR+"pullawemembers.php");

    var jsonData = json.decode(data.body);

    List<Users> user = [];

    for(var u in jsonData){
      Users users = Users(u["id"],u[ "image"], u[ "fname"], u[ "lname"], u[ "country"],u[ "place"],u["about"]);

      user.add(users);
    }

    print(user.length);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfaf4f1),
      bottomSheet: Container(
        color: Color(0xFFfaf4f1),
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
          backgroundColor:  Color(0xFFc84333),
          leading:    IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Dashbord()),);
            },
          ),
          title:Center(child: Text ("AWE Members"))),
      body: Container(
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
              padding: EdgeInsets.only(bottom: 50.0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){

                  return ListTile(
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
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,

                      ),
                    ),

                    subtitle: Text(snapshot.data[index].country,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,

                      ),),

                    onTap: (){
                      Navigator.push(context,
                          new MaterialPageRoute(builder:
                              (context)=> UserDetailPage(snapshot.data[index])
                          )
                      );
                    },
                  );



              },
            );
          }
          },
        ),
      ),

    );
  }
}

class Users{

  final int id;
  final String image;
  final String fname;
  final String lname;
  final String country;
  final String place;
  final String about;

  Users(this.id, this.image, this.fname, this.lname, this.country, this.place,this.about);


}


/////////////////////////////// User Detail page

class UserDetailPage extends StatelessWidget {

  final Users users;

  UserDetailPage(  this.users);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
            users.fname+" "+users.lname
        ),

      ),

      body:  SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0,top: 10.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                    width: 100.0,
                    height: 100.0,
                    padding: EdgeInsets.only(top: 10.0,left: 12.0),
                    margin: EdgeInsets.only(bottom: 20.0,top: 20.0),
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                users.image)
                        ))
                ),
              ),
              Text("Name : " + users.fname+" "+users.lname,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,

                ),
              ),

              Text(
                "State : "+ users.country,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,

                ),
              ),
              Text(
                "City : "+ users.place,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,

                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "More Information  " ,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),

                    ),
                  ),


                ],
              ),
              Text(
                users.about,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),

              )
            ],
          ),
        ),
      ),


      floatingActionButton: FloatingActionButton(
        // onPressed: () => setState(() => _count++),
        tooltip: 'Hello',
        child: const Icon(Icons.add),
      ),

    );
  }
}


