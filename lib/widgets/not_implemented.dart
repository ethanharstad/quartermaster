import 'package:flutter/material.dart';

void showNotImplementedDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not Implemented'),
          content: Text('Sorry, this feature is not implemented yet.'),
          actions: <Widget>[
            RaisedButton(
              child: Text(
                'Ok',
                style: Theme.of(context).primaryTextTheme.button,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}
