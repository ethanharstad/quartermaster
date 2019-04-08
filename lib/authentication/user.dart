import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;

  UserModel(
      {@required this.uid, @required this.name, this.email, this.phoneNumber});

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.documentID,
        name = snapshot.data['name'],
        email = snapshot.data['email'],
        phoneNumber = snapshot.data['phoneNumber'];

  String initials() {
    List<String> names = name.split(' ');
    String initials = names[0][0];
    if (names.length > 1) {
      initials += names.last[0];
    }
    return initials.toUpperCase();
  }

  CircleAvatar avatar() {
    return CircleAvatar(
      child: Text(
        initials(),
        textScaleFactor: 2.0,
      ),
    );
  }
}
