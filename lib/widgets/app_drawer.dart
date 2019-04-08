import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quartermaster/authentication/authentication.dart';
import 'package:quartermaster/widgets/not_implemented.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocBuilder(
      bloc: authBloc,
      builder: (BuildContext context, AuthenticationState state) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text('email@domain.com'),
                accountName: Text('Display Name'),
                currentAccountPicture: CircleAvatar(
                  child: Text('1'),
                ),
                onDetailsPressed: () {},
                otherAccountsPictures: <Widget>[
                  CircleAvatar(
                    child: Text('2'),
                  ),
                  CircleAvatar(
                    child: Text('3'),
                  )
                ],
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Dashboard'),
                onTap: () => showNotImplementedDialog(context),
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Checklists'),
                onTap: () => showNotImplementedDialog(context),
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Tasks'),
                onTap: () => showNotImplementedDialog(context),
              ),
              ListTile(
                leading: Icon(Icons.schedule),
                title: Text('Schedule'),
                onTap: () => showNotImplementedDialog(context),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () => showNotImplementedDialog(context),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: () => authBloc.dispatch(Logout()),
              ),
            ],
          ),
        );
      },
    );
  }
}