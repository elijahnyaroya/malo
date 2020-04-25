import 'dart:convert';

import 'package:africa_women_in_europe/AweMain/Myprofilearea.dart';
import 'package:africa_women_in_europe/connect/loader2.dart';
import 'package:africa_women_in_europe/eventstab/moreevents/ScheduleEvent.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:africa_women_in_europe/eventstab/pastevents.dart';
import 'package:africa_women_in_europe/eventstab/upcomingevent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'editmyprofil.dart';





class ProfileData extends StatefulWidget {
  final user_id;
  final user_name;
  final user_image;
  final page_from;

  const ProfileData({Key key, this.user_id,this.user_name,this.user_image, this.page_from}) : super(key: key);



  @override
  _ProfileDataState createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  Future<List<Data>>_getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';
    final data = await http.post(URL_CONNECTOR + "pulluserinformation.php", body: {
      "userid":userlogedinid,
    });
    var jsonData = json.decode(data.body);

    List<Data> data2 = [];

    for (var u in jsonData) {
      Data datas = Data(u["id"], u[ "fname"], u["lname"], u["image"],u["phone"],u["email"],u["country"],u["place"],u["about"],u["dates"]);

      data2.add(datas);
    }

    print(data2.length);
    print("IDEVENT pppp "+widget.user_id.toString());
    print("DATA RESPONSE " + data.body);

    return data2;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfaf4f1),
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
                          color:  Color(0xFFc84333),
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
        title: Text( "My Profile",
          style: TextStyle(fontSize: 17.0,color: Colors.white),),
        backgroundColor:  Color(0xFFc84333),
      ),

      body: Column(
        children: <Widget>[

          SingleChildScrollView(
            child: Container(
              height: 480,
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
                                  ListTile(
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: new NetworkImage(snapshot.data[index].image)
                                                  ))
                                          ),
                                        ],
                                      ),
                                        SizedBox(height: 10.0,),
                                       Center(
                                         child: Row(
                                           children: <Widget>[
                                             Text(
                                               snapshot.data[index].fname+" "+snapshot.data[index].fname,
                                               style: TextStyle(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 18.0,

                                               ),
                                             ),
                                             SizedBox(width: 10,),
                                             GestureDetector(
                                                 onTap: ()=> Navigator.of(context).push(
                                                     new MaterialPageRoute(builder: (context)=>new Editmyprofile(
                                                         my_id:snapshot.data[index].id,
                                                         my_fname:snapshot.data[index].fname,
                                                         my_lname:snapshot.data[index].lname,
                                                         my_image:snapshot.data[index].image,
                                                         my_phone:snapshot.data[index].phone,
                                                         my_email:snapshot.data[index].mail,
                                                         my_country:snapshot.data[index].country,
                                                         my_place:snapshot.data[index].place,
                                                         my_about:snapshot.data[index].about,

                                                     ))
                                                 ),
                                                 child: Icon(Icons.edit,color:  Color(0xFFc84333),size: 20,))
                                           ],
                                         ),
                                       ),
                                        SizedBox(height: 10.0,),
                                      ],
                                    ),

                                    subtitle: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text("About ",style: TextStyle(color: Colors.red,fontSize: 20.0),textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        Divider(color: Colors.red,),
                                        Text(snapshot.data[index].about,style: TextStyle(color: Colors.black)),
                                        Divider(color: Colors.red,),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.dialpad,color: Colors.black),
                                            SizedBox(width: 10.0,),
                                            Text(snapshot.data[index].phone,style: TextStyle(color :Colors.black,fontSize: 18.0),)

                                          ],
                                        ),
                                        SizedBox(height: 10.0,),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.mail,color: Colors.black,),
                                            SizedBox(width: 10.0,),
                                            Text(snapshot.data[index].email,style: TextStyle(color: Colors.black,fontSize: 18),)

                                          ],
                                        ),
                                        SizedBox(height: 10.0,),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.flag,color: Colors.black,),
                                            SizedBox(width: 10.0,),
                                            Text(snapshot.data[index].country,style: TextStyle(color: Colors.black,fontSize: 18),)

                                          ],
                                        ),
                                        SizedBox(height: 10.0,),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.location_on,color: Colors.black,),
                                            SizedBox(width: 10.0,),
                                            Text(snapshot.data[index].place,style: TextStyle(color: Colors.black,fontSize: 18),)

                                          ],
                                        ),
                                        SizedBox(height: 10.0,),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.calendar_today,color: Colors.black,),
                                            SizedBox(width: 10.0,),
                                            Text("Date Joined : "+snapshot.data[index].dates,style: TextStyle(color: Colors.black,fontSize: 18),)

                                          ],
                                        )

                                      ],
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
  final fname;
  final lname;
  final image;
  final phone;
  final email;
  final country;
  final place;
  final about;
  final dates;

  Data(this.id, this.fname, this.lname, this.image, this.phone, this.email, this.country, this.place, this.about, this.dates);


}