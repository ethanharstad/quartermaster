import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Widget avatar() {
    if (logoUrl != null) {
      return FutureBuilder(
        future: FirebaseStorage.instance
            .getReferenceFromUrl(logoUrl)
            .then((StorageReference ref) => ref.getDownloadURL()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data),
            );
          } else {
            return CircleAvatar(
              child: Text(
                abbreviation.toUpperCase(),
              ),
            );
          }
        },
      );
    } else {
      return CircleAvatar(
        child: Text(
          abbreviation.toUpperCase(),
        ),
      );
    }
  }
}
