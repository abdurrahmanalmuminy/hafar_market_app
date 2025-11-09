import 'package:flutter/material.dart';

Function showProgressDialog(BuildContext context, String title) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog.adaptive(
      title: Text(title, style: TextStyle(fontFamily: "IBMPlexSans")),
      content: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: CircularProgressIndicator.adaptive(),
      ),
    ),
  );

  return () {
    Navigator.pop(context);
  };
}
