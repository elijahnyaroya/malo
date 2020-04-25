import 'package:africa_women_in_europe/AweMain/dashboard.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:africa_women_in_europe/eventstab/pastevents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:africa_women_in_europe/eventstab/eventsExpand.dart';

class UpcomingEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AWE",
      home: upcomingevents(),

    );
  }
}

class upcomingevents extends StatefulWidget {
  @override
  _upcomingeventsState createState() => _upcomingeventsState();
}

class _upcomingeventsState extends State<upcomingevents> {


  Future<List<Groups>>_getUsers() async {
    var data = await http.get(URL_CONNECTOR+"pullevents.php");

    var jsonData = json.decode(data.body);

    List<Groups> user = [];

    for(var u in jsonData){
      Groups users = Groups(u["id"],u[ "eventname"],u["date"],u["venue"]);

      user.add(users);
    }

    print(user.length);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      bottomSheet: Container(
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
          backgroundColor: Colors.red,
          title:Center(
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UpcomingEvents()),);
                    },
                    child: Text ("Upcoming Events",
                      textAlign: TextAlign.center,
                      style: TextStyle(),),
                  ),
                  SizedBox(width: 10.0,),
                  SizedBox(width: 2.0,
                    child: Container(
                      width: 2.0,
                      height: 50.0,
                      color: Colors.white,
                    ),),
                  SizedBox(width: 10.0,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PastEvents2()),);
                    },
                    child: Text ("Past Events",
                      style: TextStyle(color: Colors.white70,),
                      textAlign: TextAlign.end,),
                  )

                ],
              )
          )),
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

                return Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 2.0,right: 2.0),
                      child: Column(
                        children: <Widget>[
                          Card(
                            color: Colors.white,
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                snapshot.data[index].eventname,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,

                                ),
                              ),
                              subtitle: Text(
                                snapshot.data[index].date,
                                style: TextStyle(
                                    color: Colors.red
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: ()=> Navigator.of(context).push(
                                    new MaterialPageRoute(builder: (context)=>new EventsExpands(
                                      events_id:snapshot.data[index].id,
                                      events_date:snapshot.data[index].date,
                                      events_venue:snapshot.data[index].venue,
                                      events_eventname:snapshot.data[index].eventname,
                                      page_from:"upcomingpage",
                                    ))
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: new Icon(Icons.arrow_forward_ios,color: Colors.black,)),
                                  ),
                                ),
                              ),


                            ),
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

    );
  }
}


class Groups{

  final int id;
  final eventname;
  final date;
  final venue;

  Groups(this.id, this.eventname, this.date, this.venue);

}