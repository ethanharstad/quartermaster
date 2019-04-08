import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quartermaster/authentication/authentication.dart';
import 'package:quartermaster/widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Widget> _buildActionsTiles() {
    return List.generate(9, (index) {
      return Card(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.event),
          Text('Action $index'),
        ],
      ));
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
            title: Text('Dashboard'),
          ),
          drawer: AppDrawer(),
          body: Column(
            children: <Widget>[
              Text('Welcome, ${(state as Authenticated).uid}'),
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
