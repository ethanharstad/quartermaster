import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quartermaster/authentication/authentication.dart';
import 'package:quartermaster/authentication/user.dart';
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
        final UserModel user = (state as Authenticated).user;
        final Map organizations = (state as Authenticated).organizations;
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text(user.email),
                accountName: Text(user.name),
                currentAccountPicture: user.avatar(),
                onDetailsPressed: () =>
                    showNotImplementedDialog(context, 'user profile'),
                otherAccountsPictures: _showOrganizations(organizations),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Dashboard'),
                onTap: () => Navigator.pushNamed(context, '/'),
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Checklists'),
                onTap: () => showNotImplementedDialog(context, 'checklists'),
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Tasks'),
                onTap: () => showNotImplementedDialog(context, 'tasks'),
              ),
              ListTile(
                leading: Icon(Icons.schedule),
                title: Text('Schedule'),
                onTap: () => showNotImplementedDialog(context, 'scheduling'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () => showNotImplementedDialog(context, 'settings'),
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

  List<Widget> _showOrganizations(Map organizations) {
    return organizations.keys.map((organizationId) {
      return GestureDetector(
        child: CircleAvatar(
          child: Text(organizationId[0]),
        ),
        onTap: () => showNotImplementedDialog(context, 'operation switching'),
        onLongPress: () => Navigator.pushNamed(context, '/organization',
            arguments: organizationId),
      );
    }).toList();
  }
}
