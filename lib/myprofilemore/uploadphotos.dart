import 'package:africa_women_in_europe/AweMain/Myprofilearea.dart';
import 'package:africa_women_in_europe/connect/connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/message_codec.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPictures extends StatefulWidget {
  UploadPictures() : super();


  @override
  UploadPicturesState createState() => UploadPicturesState();
}

class UploadPicturesState extends State<UploadPictures> {
  //
  static final String uploadEndPoint =URL_CONNECTOR+'uploadpictures.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }


  upload(String fileName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userlogedinid = prefs.getString('userloggedinid') ?? '';

    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
      "myaidno": userlogedinid,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
      print("Result server "+result.toString());
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
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
        title: Text( "Upload Pictures",
          style: TextStyle(fontSize: 17.0,color: Colors.white),),
        backgroundColor:  Color(0xFFc84333),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                color: Color(0xFFfaf4f1),
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.only(bottom: 20,left: 3,right: 2),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Text("Keep memories with  with us.",style: TextStyle(color:  Color(0xFFc84333),fontWeight: FontWeight.bold,fontSize: 20),),
                      SizedBox(height: 10,),
                      Text("As African Women in Europe we provide you with this awesome platform to keep your best moments and best times you had with us from our our events and any other place that you want to keep for future reference. Save those monents with us by uploading those moments as pictures.",
                        style: TextStyle(color: Color(0xFF39393a),fontWeight: FontWeight.bold,fontSize: 14),)
                    ],
                  ),
                ),
              ),
              OutlineButton(
                onPressed: chooseImage,
                child: Text('Choose Image'),
              ),
              SizedBox(
                height: 20.0,
              ),
              showImage(),
              SizedBox(
                height: 20.0,
              ),
              OutlineButton(
                onPressed: startUpload,
                child: Text('Upload Image'),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }


}



