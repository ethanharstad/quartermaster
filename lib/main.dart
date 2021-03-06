import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quartermaster/authentication/authentication.dart';
import 'package:quartermaster/login/login.dart';
import 'package:quartermaster/screens/dashboard_screen.dart';
import 'package:quartermaster/screens/organization_detail.dart';
import 'package:quartermaster/screens/splash_screen.dart';
import 'package:quartermaster/simple_bloc_delegate.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatefulWidget {
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: _authenticationBloc,
    );
    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: _authenticationBloc,
        child: MaterialApp(
          title: 'Quartermaster',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) => _buildHomeScreen(),
            '/organization': (BuildContext context) =>
                OrganizationDetailScreen(),
          },
        ));
  }

  Widget _buildHomeScreen() {
    return BlocBuilder(
      bloc: _authenticationBloc,
      builder: (BuildContext context, AuthenticationState state) {
        if (state is Uninitialized) {
          return SplashScreen();
        }
        if (state is Unauthenticated) {
          return LoginScreen(loginBloc: _loginBloc);
        }
        if (state is Authenticated) {
          return DashboardScreen();
        }
      },
    );
  }
}
