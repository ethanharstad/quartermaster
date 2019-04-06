import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quartermaster/simple_bloc_delegate.dart';
import 'package:quartermaster/authentication/authentication.dart';
import 'package:quartermaster/login/login.dart';

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
        home: BlocBuilder(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Unauthenticated) {
              return LoginScreen(loginBloc: _loginBloc);
            }
            if (state is Authenticated) {
              return HomePage();
            }
          },
        ),
      )
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...')
      )
    );
  }
}

class HomePage extends StatefulWidget {
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _buildActionsTiles() {
    return List.generate(9, (index) {
      return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.event),
            Text('Action $index'),
          ],
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocBuilder(
      bloc: authBloc,
      builder: (BuildContext context, AuthenticationState state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: <Widget>[
                Icon(Icons.whatshot),
                SizedBox(width: 5),
                Text('Dashboard'),
              ],
            ),
          ),
          body: Column(
            children: <Widget>[
              Text('Welcome, ${(state as Authenticated).name}'),
              GridView.extent(
                shrinkWrap: true,
                maxCrossAxisExtent: 150,
                padding: const EdgeInsets.all(4),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: _buildActionsTiles(),
              ),
            ],
          ),
        );
      },
    );
  }
}
