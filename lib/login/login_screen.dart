import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quartermaster/login/login.dart';

class LoginScreen extends StatefulWidget {
  final LoginBloc loginBloc;

  LoginScreen({@required this.loginBloc});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: BlocProvider(
          bloc: widget.loginBloc,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              TextField(
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                decoration: new InputDecoration(
                  hintText: 'Email',
                  icon: new Icon(
                    Icons.mail,
                  ),
                ),
                onChanged: (value) => _email = value,
              ),
              TextField(
                maxLines: 1,
                obscureText: true,
                autofocus: false,
                decoration: new InputDecoration(
                  hintText: 'Password',
                  icon: new Icon(
                    Icons.lock,
                  ),
                ),
                onChanged: (value) => _password = value,
              ),
              RaisedButton(
                child: Text('Sign In'),
                onPressed: () {
                  widget.loginBloc.dispatch(LoginPressed(email: _email, password: _password));
                },
              )
            ],
          )
        )
      ),
    );
  }
}