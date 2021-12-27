import 'package:example_client/example_client.dart';
import 'package:example_flutter/src/sign_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

late SessionManager sessionManager;
late Client client;

void main() async {
  // Need to call this as we are using Flutter bindings before runApp is called.
  WidgetsFlutterBinding.ensureInitialized();

  // Sets up a singleton client object that can be used to talk to the server
  // from anywhere in our app. The client is generated from your server code.
  // The client is set up to connect to a Serverpod running on a local server on
  // the default port. You will need to modify this to connect to staging or
  // production servers.
  client = Client(
    'http://localhost:8080/',
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  );

  // The session manager keeps track of the signed-in state of the user. You
  // can query it to see if the user is currently signed in and get information
  // about the user.
  sessionManager = SessionManager(
    caller: client.modules.auth,
  );
  await sessionManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Serverpod Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: UserSettings(
                  sessionManager: sessionManager,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: UserSettings(
                  compact: false,
                  sessionManager: sessionManager,
                ),
              ),
            ),
          ),
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
        title: const Text('Not signed in'),
        trailing: OutlinedButton(
          onPressed: _signIn,
          child: const Text('Sign In'),
        ),
      );
    } else {
      return ListTile(
        title: const Text('You are signed in'),
        trailing: OutlinedButton(
          onPressed: _signOut,
          child: const Text('Sign Out'),
        ),
      );
    }
  }

  void _signOut() {
    sessionManager.signOut().then((bool success) {
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
