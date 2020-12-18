import 'package:firebase_database/firebase_database.dart';
import 'package:map_app/blocs/authentication_bloc/authentication_state.dart';
import 'package:map_app/blocs/simple_bloc_observer.dart';
import 'package:map_app/repositories/user_repository.dart';
import 'package:map_app/home_screen.dart';
import 'package:map_app/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/authentication_bloc/authentication_event.dart';
import 'onboard.dart';


void main() {
  runApp(MyApp2());
}

//void main() {
//  Bloc.observer = SimpleBlocObserver();
//  final UserRepository userRepository = UserRepository();
//  runApp(
//    BlocProvider(
//      create: (context) => AuthenticationBloc(
//        userRepository: userRepository,
//      )..add(AuthenticationStarted()),
//      child: MyApp(
//        userRepository: userRepository,
//      ),
//    ),
//  );
//}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({UserRepository userRepository}) : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff6a515e),
        cursorColor: Color(0xff6a515e),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return LoginScreen(userRepository: _userRepository,);
          }

          if (state is AuthenticationSuccess) {
            setPos();
            final databaseReference = FirebaseDatabase.instance.reference();
            databaseReference.once().then((DataSnapshot snapshot) {
              var data=snapshot.value;
              try{
                data=data["Users"][state.firebaseUser.email.toString().replaceAll('.', '+')]["LastIndex"]["value"];
              }catch(_){
                databaseReference.child("Users").child(state.firebaseUser.email.toString().replaceAll('.', '+')).set({
                  'Activate':'TRUE'
                });
                databaseReference.child("Users").child(state.firebaseUser.email.toString().replaceAll('.', '+')).child("LastIndex").set({
                  'value':'0'
                });
              }
            });

            setValue(state.firebaseUser.email.toString().replaceAll('.', '+'));
            return HomeScreen();
          }

          return Scaffold();
        },
      ),
    );
  }
  setValue(val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mail', val);
  }
  setPos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pos', 'oldUser');
  }
}



// OLD
//import 'package:flutter/material.dart';
//import 'package:map_app/home_screen.dart';
//
//
//void main() => runApp(App());
//
//class App extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: HomeScreen(),
//      theme: ThemeData(
//        fontFamily: "poppins",
//        scaffoldBackgroundColor: Colors.white,
//      ),
//    );
//  }
//}
