import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class OrganizationModel {
  final String id;
  final String name;
  final String abbreviation;
  final String logoUrl;
  final DocumentReference reference;

  OrganizationModel(
      {@required this.id,
      this.name,
      this.abbreviation,
      this.logoUrl,
      this.reference});

  OrganizationModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        name = snapshot.data['name'],
        abbreviation = snapshot.data['abbreviation'],
        logoUrl = snapshot.data['logoUrl'],
        reference = snapshot.reference;

  CircleAvatar avatar() {
    return CircleAvatar(
      child: Text(
        abbreviation.toUpperCase(),
      ),
    );
  }
}
