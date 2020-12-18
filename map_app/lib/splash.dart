import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:map_app/onboard.dart';
import 'package:map_app/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/authentication_bloc/authentication_event.dart';
import 'blocs/simple_bloc_observer.dart';
import 'main.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    wait();
    _controller = AnimationController(vsync: this);
  }
  getPos()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var v=prefs.getString('pos');
    if(v==null){
      runApp(MyApp3());
    }else{
      Bloc.observer = SimpleBlocObserver();
      final UserRepository userRepository = UserRepository();
      runApp(
        BlocProvider(
          create: (context) => AuthenticationBloc(
            userRepository: userRepository,
          )..add(AuthenticationStarted()),
          child: MyApp(
            userRepository: userRepository,
          ),
        ),
      );
    }
  }
  wait()async{
    await new Future.delayed(const Duration(seconds : 5));
    getPos();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/spl.json',
            controller: _controller,
            onLoaded: (composition) {
              // Configure the AnimationController with the duration of the
              // Lottie file and start the animation.
              _controller
                ..duration = composition.duration
                ..forward();
            },
          ),
        ),
      ),
    );
  }
}


class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Onboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}