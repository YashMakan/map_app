import 'package:map_app/blocs/login_bloc/login_bloc.dart';
import 'package:map_app/repositories/user_repository.dart';
import 'package:map_app/screens/login/login_form.dart';
import 'package:map_app/widgets/curved_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const LoginScreen({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                CurvedWidget(
                  child: Container(
                    padding: const EdgeInsets.only(top: 100, left: 50),
                    width: double.infinity,
                    height: 300,
                    color: Colors.pinkAccent,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 230),
                  child: LoginForm(userRepository: _userRepository,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
