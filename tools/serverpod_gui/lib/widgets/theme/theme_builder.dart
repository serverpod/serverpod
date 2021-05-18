import 'package:flutter/material.dart';

ThemeData buildDefaultTheme() => ThemeData(
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.compact,
  backgroundColor: Colors.blueGrey[50],
  // popupMenuTheme: PopupMenuThemeData(
  //   textStyle: TextStyle(
  //     fontSize: 20.0,
  //   ),
  // ),
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 12.0),
    bodyText2: TextStyle(fontSize: 12.0),
    caption: TextStyle(fontSize: 11.0),
    button: TextStyle(fontSize: 14.0),
  ),
);

List<BoxShadow> buildFancyBoxShadow(BuildContext context) {
  return [
    BoxShadow(
      offset: Offset(0.0, 1.0),
      blurRadius: 0.5,
      color: Theme.of(context).brightness == Brightness.light ? Colors.black12 : Colors.black54,
    ),
  ];
}