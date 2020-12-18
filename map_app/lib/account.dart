import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:map_app/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as Path;
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/authentication_bloc/authentication_event.dart';
import 'dart:io';
class UserProfilePage extends StatefulWidget {
  final img;

  const UserProfilePage({Key key, this.img}) : super(key: key);
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _fullName = "";
  String _bio = "\"The World Is A Book And Those Who Do Not Travel Read Only A Page.\n~Saint Augustine\"";
  String tempImage;
  var _lat;
  var _long;
  File _image;
  String _uploadedFileURL='None';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tempImage=widget.img==null?'https://media.istockphoto.com/vectors/user-icon-human-person-sign-vector-id587957104?k=6&m=587957104&s=170667a&w=0&h=umaeFHgEnWFB-A45hQYZXvrcqKh-2fnsx68pwcWCR1c=':widget.img;
    setName();
  }
  setName()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var v=prefs.getString('mail');
    setState(() {
      _fullName=v.split('@')[0];
    });
  }
  setImg(v)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('image',v);
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.pinkAccent),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedOut());
              Navigator.pop(context);
            },
            child: Row(children: <Widget>[
              Text('Logout',style: TextStyle(color: Colors.pinkAccent),),
              SizedBox(width: 2,),
              Icon(Icons.call_missed_outgoing),
              SizedBox(width: 2,),
            ],),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: screenSize.height / 2.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1498307833015-e7b400441eb8?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1100&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 6.4),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        upload();
                      },
                      child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(tempImage),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(80.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 5.0,
                        ),
                      ),
                  ),
                    ),
                ),
                  SizedBox(height: screenSize.height/20,),
                  Text(
                    _fullName,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _bio,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Spectral',
                          fontWeight: FontWeight.w400,//try changing weight to w500 if not thin
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF799497),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () => getIp(),
                            child: Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: Colors.pinkAccent,
                              ),
                              child: Center(
                                child: Text(
                                  "CURRENT",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              getIp2();
                            },
                            child: Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.pinkAccent),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "CHOOSE",
                                    style: TextStyle(fontWeight: FontWeight.w600,color: Colors.pinkAccent),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  upload() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) async {
      _image=image;
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('$_fullName/${Path.basename(_image.path)}}');
      showDialog(context: context, child:
      new AlertDialog(
        title: Center(child: CircularProgressIndicator()),
      )
      );
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          tempImage = fileURL;
          setImg(fileURL);
        });
      });
    });
    Navigator.pop(context);

  }

  getLocation(ip)async{
    try {
      var url = 'http://ipinfo.io/$ip/geo';
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // The response body is the IP in plain text, so just
        // return it as-is.
        var data=jsonDecode(response.body);
        data=data["loc"].toString().split(',');
        var lat=data[0];
        var long=data[1];
        setState(() {
          _lat=lat;
          _long=long;
        });
        Navigator.pop(context);
        showDialog(context: context, child:
        new AlertDialog(
          title: Text("Latitude: "+lat+" Longitude: "+long),
        ));
      } else {
        // The request failed with a non-200 code
        // The ipify.org API has a lot of guaranteed uptime
        // promises, so this shouldn't ever actually happen.
        return null;
      }
    } catch (e) {
      // Request failed due to an error, most likely because
      // the phone isn't connected to the internet.
      print(e);
      return null;
    }
  }

  getIp()async{
    showDialog(context: context, child:
      new AlertDialog(
        title: Center(child: CircularProgressIndicator()),
      )
    );
    try {
      var url = 'https://api.ipify.org';
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // The response body is the IP in plain text, so just
        // return it as-is.
        getLocation(response.body);
      } else {
        // The request failed with a non-200 code
        // The ipify.org API has a lot of guaranteed uptime
        // promises, so this shouldn't ever actually happen.
      }
    } catch (e) {
      // Request failed due to an error, most likely because
      // the phone isn't connected to the internet.
      print(e);
      return null;
    }
  }

  getLocation2(ip)async{
    try {
      var url = 'http://ipinfo.io/$ip/geo';
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // The response body is the IP in plain text, so just
        // return it as-is.
        var data=jsonDecode(response.body);
        data=data["loc"].toString().split(',');
        var lat=double.parse(data[0]);
        var long=double.parse(data[1]);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Location(lat: lat,long: long,)
        ));
      } else {
        // The request failed with a non-200 code
        // The ipify.org API has a lot of guaranteed uptime
        // promises, so this shouldn't ever actually happen.
        return null;
      }
    } catch (e) {
      // Request failed due to an error, most likely because
      // the phone isn't connected to the internet.
      print(e);
      return null;
    }
  }

  getIp2()async{
    showDialog(context: context, child:
    new AlertDialog(
      title: Center(child: CircularProgressIndicator()),
    )
    );
    try {
      var url = 'https://api.ipify.org';
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // The response body is the IP in plain text, so just
        // return it as-is.
        getLocation2(response.body);
      } else {
        // The request failed with a non-200 code
        // The ipify.org API has a lot of guaranteed uptime
        // promises, so this shouldn't ever actually happen.
      }
    } catch (e) {
      // Request failed due to an error, most likely because
      // the phone isn't connected to the internet.
      print(e);
      return null;
    }
  }
}