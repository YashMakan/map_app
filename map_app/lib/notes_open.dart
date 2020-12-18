import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_app/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'note.dart';

class NotesScreenOpen extends StatefulWidget {
  final String title;
  final String body;
  final bool update;
  final String index;

  const NotesScreenOpen({Key key, this.title, this.body, this.update, this.index}) : super(key: key);
  @override
  _NotesScreenOpenState createState() => _NotesScreenOpenState();
}

class _NotesScreenOpenState extends State<NotesScreenOpen>
    with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  TabController _tabController;
  final DateFormat _dateFormatter = DateFormat('dd MMM');
  final DateFormat _timeFormatter = DateFormat('h:mm');

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  String _mail='';

  @override
  void initState() {
    super.initState();
    setState(() {
      getMail();
      t1.text=widget.title!=null?widget.title:'';
      t2.text=widget.body!=null?widget.body:'';
    });
  }

  getMail()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var v=prefs.getString('mail');
    setState(() {
      _mail=v;
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
              GestureDetector(child: Text('SAVE',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Color(0xFF404A5C),),),onTap: (){
                if(widget.update==false){
                  final databaseReference = FirebaseDatabase.instance.reference();
                  databaseReference.once().then((DataSnapshot snapshot) {
                    var data=snapshot.value;
                    var ind;
                    ind=data["Users"][_mail]["LastIndex"]["value"];
                    databaseReference.child("Users").child(_mail).child(ind.toString()).set({
                      'title':t1.text,
                      'desc':t2.text
                    });
                    databaseReference.child("Users").child(_mail).child("LastIndex").set({
                      'value': (int.parse(ind)+1).toString(),
                    });
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
                else{
                  final databaseReference = FirebaseDatabase.instance.reference();
                    databaseReference.child("Users").child(_mail).child(widget.index).set({
                      'title':t1.text,
                      'desc':t2.text
                    });
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },)
            ],)
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Container(
                child: TextField(
                  controller: t1,
                  decoration: InputDecoration(
                    hintText: 'Title'
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700,fontSize: 30,color: Color(0xFF404A5C)),
                )
            ),
          ),
          Expanded(
            child: Padding(
                    padding: const EdgeInsets.only(bottom:8.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
                      padding: EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F7FB),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextField(
                        maxLines: 200,
                        controller: t2,
                        decoration: InputDecoration(
                          hintText: 'body',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      )
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
