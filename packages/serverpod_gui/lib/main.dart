import 'package:flutter/material.dart';
import 'widgets/theme/theme_builder.dart';
import 'widgets/navigation/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod',
      theme: buildDefaultTheme(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key,}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainPage(),
    );
  }
}
