import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      backgroundColor: Theme.of(context).primaryColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 50, right: 50, bottom: 10),
      shape: const StadiumBorder(),
    ),
  );
}
