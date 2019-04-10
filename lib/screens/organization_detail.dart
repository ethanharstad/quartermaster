import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quartermaster/organization/organization.dart';
import 'package:quartermaster/widgets/app_drawer.dart';

class OrganizationDetailScreen extends StatefulWidget {
  static String routeName = '/organization';

  @override
  State<OrganizationDetailScreen> createState() =>
      _OrganizationDetailScreenState();
}

class _OrganizationDetailScreenState extends State<OrganizationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final String organizationId = ModalRoute.of(context).settings.arguments;
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('organizations')
          .document(organizationId)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          final OrganizationModel organization =
              OrganizationModel.fromSnapshot(snapshot.data);
          return Scaffold(
            appBar: AppBar(
              title: Text(organization.name),
            ),
            drawer: AppDrawer(),
            body: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: organization.avatar(),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        organization.name,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: _showMembers(organization),
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            drawer: AppDrawer(),
            body: Center(
              child: Text('Error loading organization'),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Loading Organization'),
          ),
          drawer: AppDrawer(),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _showMembers(OrganizationModel organization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Members',
          style: Theme.of(context).textTheme.subtitle,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('members')
                .where('organizationRef', isEqualTo: organization.reference)
                .orderBy('name')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                final members = snapshot.data.documents;
                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (BuildContext context, int index) {
                    final document = members[index];
                    return ListTile(
                      key: Key(document.documentID),
                      title: Text(document.data['name']),
                    );
                  },
                );
              }
              if (snapshot.hasError) {
                return Text('Error loading memebers.');
              }
              return Text('Loading...');
            },
          ),
        ),
      ],
    );
  }
}
