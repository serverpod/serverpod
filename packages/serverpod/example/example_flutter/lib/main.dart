import 'package:example_client/example_client.dart';
import 'package:example_flutter/src/disconnected_page.dart';
import 'package:example_flutter/src/loading_page.dart';
import 'package:example_flutter/src/main_page.dart';
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
      home: const _SignInPage(),
    );
  }
}

class _SignInPage extends StatefulWidget {
  const _SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<_SignInPage> {
  @override
  void initState() {
    super.initState();

    sessionManager.addListener(_changedSessionStatus);
  }

  @override
  void dispose() {
    super.dispose();

    client.removeWebSocketConnectionStatusListener(_changedSessionStatus);
  }

  @override
  Widget build(BuildContext context) {
    if (sessionManager.isSignedIn) {
      return _ConnectionPage();
    } else {
      return Scaffold(
        body: Container(
          color: Colors.blueGrey,
          alignment: Alignment.center,
          child: SignInDialog(
            shownAsDialog: false,
          ),
        ),
      );
    }
  }

  void _changedSessionStatus() {
    // This method is called whenever the user signs in or out.
    setState(() {});
  }
}

class _ConnectionPage extends StatefulWidget {
  const _ConnectionPage({Key? key}) : super(key: key);

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<_ConnectionPage> {
  List<Channel>? _channels;
  bool _connecting = false;
  // bool _attemptedFirstConnect = false;

  @override
  void initState() {
    super.initState();

    client.addWebSocketConnectionStatusListener(_changedConnectionStatus);
    _connect();
  }

  @override
  void dispose() {
    super.dispose();

    client.removeWebSocketConnectionStatusListener(_changedConnectionStatus);
  }

  Future<void> _connect() async {
    // Reset to initial state.
    setState(() {
      _channels = null;
      _connecting = true;
    });

    try {
      // Load list of channels.
      var channelList = await client.channels.getChannels();

      // Make sure that the web socket is connected.
      await client.connectWebSocket();

      _channels = channelList.channels;
    } catch (e) {
      // We failed to connect.
    }

    setState(() {
      _connecting = false;
    });
  }

  void _changedConnectionStatus() {
    // This method is called whenever the state for the web socket has changed.
    setState(() {});
  }

  void _reconnect() {
    if (client.isWebSocketConnected) {
      return;
    }
    _connect();
  }

  @override
  Widget build(BuildContext context) {
    if (_connecting) {
      return const LoadingPage();
    } else if (_channels == null || !client.isWebSocketConnected) {
      return DisconnectedPage(
        onReconnect: _reconnect,
      );
    } else {
      return MainPage(
        channels: _channels!,
      );
    }
  }
}
