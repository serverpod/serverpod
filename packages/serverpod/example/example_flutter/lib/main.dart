import 'package:example_flutter/src/sign_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:example_client/example_client.dart';
import 'package:serverpod_auth_google_flutter/serverpod_auth_google_flutter.dart';

late SessionManager sessionManager;
late Client client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // The session manager keeps track of the signed-in state of the user. You
  // can query it to see if the user is currently signed in and get information
  // about the user.
  sessionManager = await SessionManager.instance;

  // Sets up a singleton client object that can be used to talk to the server
  // from anywhere in our app. The client is generated from your server code.
  // The client is set up to connect to a Serverpod running on a local server on
  // the default port. You will need to modify this to connect to staging or
  // production servers.
  client = Client(
    'http://localhost:8080/',
    authenticationKeyManager: sessionManager.keyManager,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Serverpod Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          _UserInfoTile(),
        ],
      ),
    );
  }
}

class _UserInfoTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserInfoTileState();
}

class _UserInfoTileState extends State<_UserInfoTile> {
  @override
  Widget build(BuildContext context) {
    var userInfo = sessionManager.signedInUser;

    if (userInfo == null) {
      return ListTile(
        title: Text('Not signed in'),
        trailing: OutlinedButton(
          onPressed: _signIn,
          child: Text('Sign In'),
        ),
      );
    }
    else {
      return ListTile(
        title: Text(userInfo.userName),
        subtitle: Text(userInfo.email ?? 'Unknown email'),
        trailing: OutlinedButton(
          onPressed: _signOut,
          child: Text('Sign Out'),
        ),
      );
    }
  }

  void _signOut() {
    sessionManager.signOut(client.modules.auth).then((bool success) {
      setState(() {});
    });
  }

  void _signIn() {
    showSignInDialog(
      context: context,
      onSignedIn: () {
        setState(() {});
      },
    );
  }
}


