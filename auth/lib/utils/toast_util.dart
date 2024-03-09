import 'package:ente_auth/ente_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(
  BuildContext context,
  String message, {
  toastLength = Toast.LENGTH_LONG,
  iOSDismissOnTap = true,
}) async {
  await Fluttertoast.cancel();
  await Fluttertoast.showToast(
    msg: message,
    toastLength: toastLength,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Theme.of(context).colorScheme.toastBackgroundColor,
    textColor: Theme.of(context).colorScheme.toastTextColor,
    fontSize: 16.0,
  );
}

void showShortToast(context, String message) {
  showToast(context, message, toastLength: Toast.LENGTH_SHORT);
}
