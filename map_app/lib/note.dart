import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_app/notes_open.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with SingleTickerProviderStateMixin {
  final DateFormat _dateFormatter = DateFormat('dd MMM');
  final DateFormat _timeFormatter = DateFormat('h:mm');
  String _mail='';
  List<Note> notes = [];
  @override
  void initState() {
    super.initState();
    getMail();
    getNotes();
  }

  getMail()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var v=prefs.getString('mail');
    setState(() {
      _mail=v;
    });
  }

  getNotes()async{
    final databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.once().then((DataSnapshot snapshot) {
      var data=snapshot.value;
      data=data["Users"][_mail];
      List<Note> newP=[];
      for(int i = 0; i < data.length-2; i++){
        var t=data[i.toString()]['title'];
        var d=data[i.toString()]['desc'];
        newP.add(Note(title: t,content: d));
      }
      setState(() {
        notes=newP;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20,),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back,color: Color(0xFF404A5C),),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                IconButton(icon: Icon(Icons.add_box,color: Colors.pinkAccent,),onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotesScreenOpen(update: false,)),
                  );
                },)
              ],)
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Container(
              child: Text('Travel Stories',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 30,color: Colors.pinkAccent),)
            ),
          ),
          notes.length!=0?Expanded(
            child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom:8.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotesScreenOpen(title: notes[i].title,body: notes[i].content,update:true,index: i.toString())),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30.0),
                        padding: EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F7FB),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  notes[i].title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    final databaseReference = FirebaseDatabase.instance.reference();
                                    if(i==0 && notes.length==1){
                                      databaseReference.child("Users").child(_mail).child("LastIndex").set({
                                        'value':'0'
                                      });
                                    }
                                    databaseReference.child("Users").child(_mail).child(i.toString()).remove().then((_) {
                                      print("Delete ${i.toString()} successful");
                                      setState(() {
                                        notes.removeAt(i);
                                      });
                                    });
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.pinkAccent,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              notes[i].content,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          ):Column(crossAxisAlignment:CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height/6,),
            Center(child: Text('No Memories',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25,color: Colors.grey[700]),),)
          ],)
        ],
      ),
    );
  }
}


class Note {
  String title;
  String content;
  DateTime date;

  Note({this.title, this.content, this.date});
}
