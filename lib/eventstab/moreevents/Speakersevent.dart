import 'dart:convert';

import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:africa_women_in_europe/eventstab/moreevents/ScheduleEvent.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/eventstab/moreevents/userprofile.dart';
import 'package:africa_women_in_europe/eventstab/pastevents.dart';
import 'package:africa_women_in_europe/eventstab/upcomingevent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../eventsExpand.dart';
import 'attendances.dart';



class Speakers extends StatefulWidget {
  final events_id;
  final events_date;
  final events_venue;
  final events_eventname;
  final page_from;

  const Speakers({Key key, this.events_id, this.events_date, this.events_venue, this.events_eventname, this.page_from}) : super(key: key);



  @override
  _SpeakersState createState() => _SpeakersState();
}

class _SpeakersState extends State<Speakers> {
  Future<List<Data>>_getData() async {
    final data = await http.post(URL_CONNECTOR + "pullevents_attendees_speaker.php", body: {
      "eventid":widget.events_id.toString(),
    });
    var jsonData = json.decode(data.body);

    List<Data> data2 = [];

    for (var u in jsonData) {
      Data datas = Data(u["id"], u[ "name"], u["title"], u["imageprof"]);

      data2.add(datas);
    }

    print(data2.length);
    print("IDEVENT pppp "+widget.events_id.toString());
    print("DATA RESPONSE " + data.body);

    return data2;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        height: 30.0,
        child: Center(
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  if(widget.page_from=="upcomingpage"){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UpcomingEvents()),);
                  }else{
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PastEvents2()),);
                  }
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
        elevation: 0.1,
        leading: GestureDetector(
          onTap: (){
            if(widget.page_from=="upcomingpage"){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => UpcomingEvents()),);
            }else{
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => PastEvents2()),);
            }
          },
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(widget.events_eventname,
          style: TextStyle(fontSize: 17.0,color: Colors.white),),
        backgroundColor: Colors.red,
      ),

      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10.0),
            color: Colors.red,
            height: 30.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SizedBox(width: 10.0,),
                GestureDetector(
                    onTap: ()=> Navigator.of(context).push(
                        new MaterialPageRoute(builder: (context)=>new EventsExpands(
                          events_id:widget.events_id,
                          events_date:widget.events_date,
                          events_venue:widget.events_venue,
                          events_eventname:widget.events_eventname,
                          page_from:widget.page_from,
                        ))
                    ),
                    child: Text("INFO",style: TextStyle(color: Colors.white70,fontSize: 17.0),)),
                SizedBox(width: 10.0,),
                SizedBox(width: 2.0,
                  child: Container(
                    width: 2.0,
                    height: 50.0,
                    color: Colors.white70,
                  ),),
                SizedBox(width: 10.0,),
                GestureDetector(
                    onTap: ()=> Navigator.of(context).push(
                        new MaterialPageRoute(builder: (context)=>new Attendance(
                          events_id:widget.events_id,
                          events_date:widget.events_date,
                          events_venue:widget.events_venue,
                          events_eventname:widget.events_eventname,
                          page_from:widget.page_from,
                        ))
                    ),
                    child: Text("ATTENDANCES",style: TextStyle(color: Colors.white70,fontSize: 17.0))),
                SizedBox(width: 10.0,),
                SizedBox(width: 2.0,
                  child: Container(
                    width: 2.0,
                    height: 50.0,
                    color: Colors.white,
                  ),),
                SizedBox(width: 10.0,),
                GestureDetector(
                    onTap: ()=> Navigator.of(context).push(
                        new MaterialPageRoute(builder: (context)=>new ScheduleEvents(
                          events_id:widget.events_id,
                          events_date:widget.events_date,
                          events_venue:widget.events_venue,
                          events_eventname:widget.events_eventname,
                          page_from:widget.page_from,
                        ))
                    ),
                    child: Text("SCHDULE",style: TextStyle(color: Colors.white70,fontSize: 17.0))),
                SizedBox(width: 10.0,),
                SizedBox(width: 2.0,
                  child: Container(
                    width: 2.0,
                    height: 50.0,
                    color: Colors.white,
                  ),),
                SizedBox(width: 10.0,),
                GestureDetector(
                    onTap: ()=> Navigator.of(context).push(
                        new MaterialPageRoute(builder: (context)=>new Speakers(
                          events_id:widget.events_id,
                          events_date:widget.events_date,
                          events_venue:widget.events_venue,
                          events_eventname:widget.events_eventname,
                          page_from:widget.page_from,
                        ))
                    ),
                    child: Text("SPEAKERS",style: TextStyle(color: Colors.white,fontSize: 17.0))),
              ],
            ),
          ),

          SingleChildScrollView(
            child: Container(
              height: 450,
              child: FutureBuilder(
                future: _getData(),
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
                                      leading:  Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                      snapshot.data[index].imageprof)
                                      ))
                                      ),
                                      title: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,

                                        ),
                                      ),
                                      subtitle: Text(
                                        snapshot.data[index].title,
                                        style: TextStyle(
                                            color: Colors.red
                                        ),
                                      ),
                                      trailing: GestureDetector(
                                        onTap: ()=> Navigator.of(context).push(
                                            new MaterialPageRoute(builder: (context)=>new Userprofile(
                                              user_id:snapshot.data[index].id,
                                              user_name:snapshot.data[index].name,
                                              user_image:snapshot.data[index].imageprof,
                                              page_from:"speakers",
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
            ),
          )

        ],

      ),

    );
  }
}


class Data{

  final int id;
  final name;
  final title;
  final imageprof;

  Data(this.id, this.name, this.title, this.imageprof);

}