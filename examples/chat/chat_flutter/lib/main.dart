import 'package:chat_flutter/src/disconnected_page.dart';
import 'package:chat_flutter/src/loading_page.dart';
import 'package:chat_flutter/src/main_page.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';
import 'package:chat_client/chat_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late SessionManager sessionManager;
late Client client;

void main() async {
  // Need to call this as SessionManager is using Flutter bindings before runApp
  // is called.
  WidgetsFlutterBinding.ensureInitialized();

  // Sets up a singleton client object that can be used to talk to the server
  // from anywhere in our app. The client is generated from your server code.
  // The client is set up to connect to a Serverpod running on a local server on
  // the default port. You will need to modify this to connect to staging or
  // production servers.
  client = Client(
    'http://$localhost:8080/',
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

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
  const MyApp({super.key});

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

// The _SignInPage either displays a dialog for signing in or, if the user is
// signed in, displays the _ConnectionPage.
class _SignInPage extends StatefulWidget {
  const _SignInPage();

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
    client.removeStreamingConnectionStatusListener(_changedSessionStatus);
  }

  @override
  Widget build(BuildContext context) {
    if (sessionManager.isSignedIn) {
      return const _ConnectionPage();
    } else {
      return Scaffold(
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Center(
            child: SignInWithEmailButton(
              caller: client.modules.auth,
            ),
          ),
        ),
      );
    }
  }

  // This method is called whenever the user signs in or out.
  void _changedSessionStatus() {
    setState(() {});
  }
}

// The _ConnectionPage can display three states; a loading spinner, a page
// if loading fails or if the connection to the server is broken, or the
// main chat page.
class _ConnectionPage extends StatefulWidget {
  const _ConnectionPage();

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<_ConnectionPage> {
  // List of channels as retrieved from the server. Null if the chats hasn't
  // been successfully loaded.
  List<Channel>? _channels;

  // True if we are currently trying to connect to the server.
  bool _connecting = false;

  // Contains a list of ChatControllers.
  final Map<String, ChatController> _chatControllers = {};

  @override
  void initState() {
    super.initState();

    // Starts listening to changes in the websocket connection.
    client.addStreamingConnectionStatusListener(_changedConnectionStatus);
    _connect();
  }

  @override
  void dispose() {
    super.dispose();

    // Stops listening to websocket connections.
    client.removeStreamingConnectionStatusListener(_changedConnectionStatus);
    _disposeChatControllers();
  }

  // Disposes all chat controllers and removes the references to them.
  void _disposeChatControllers() {
    for (var chatController in _chatControllers.values) {
      chatController.dispose();
    }
    _chatControllers.clear();
  }

  // Starts connecting to the server. Connection is complete when we have
  // established a connection to the websocket and to all chat channels.
  Future<void> _connect() async {
    // Reset to initial state.
    setState(() {
      _channels = null;
      _connecting = true;
      _disposeChatControllers();
    });

    try {
      // Load list of channels.
      _channels = await client.channels.getChannels();

      // Make sure that the web socket is connected.
      await client.openStreamingConnection();

      // Setup ChatControllers for all the channels in the list.
      for (var channel in _channels!) {
        var controller = ChatController(
          channel: channel.channel,
          module: client.modules.chat,
          sessionManager: sessionManager,
        );

        _chatControllers[channel.channel] = controller;

        // Listen to changes in the connection status of the chat channel.
        controller.addConnectionStatusListener(_chatConnectionStatusChanged);
      }
    } catch (e) {
      // We failed to connect.
      setState(() {
        _channels = null;
        _connecting = false;
      });
      return;
    }
  }

  // This method is called whenever the state for the web socket has changed.
  void _changedConnectionStatus() {
    setState(() {});
  }

  // This method is called whenever we have established a connection to a chat
  // channel.
  void _chatConnectionStatusChanged() {
    // Make sure that we have received the list of channels.
    if (_channels == null || _channels!.isEmpty) {
      setState(() {
        _channels = null;
        _connecting = false;
      });
      return;
    }

    var numJoinedChannels = 0;

    // Count the number of channels that we have joined.
    for (var chatController in _chatControllers.values) {
      if (chatController.joinedChannel) {
        numJoinedChannels += 1;
      } else if (chatController.joinFailed) {
        setState(() {
          _channels = null;
          _connecting = false;
        });
        return;
      }
    }

    // If we have joined all the channels loading is complete.
    if (numJoinedChannels == _chatControllers.length) {
      setState(() {
        _connecting = false;
      });
    }
  }

  // Attempt to reconnect to the server.
  void _reconnect() {
    if (client.streamingConnectionStatus ==
        StreamingConnectionStatus.disconnected) {
      _connect();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connecting) {
      return const LoadingPage();
    } else if (_channels == null ||
        client.streamingConnectionStatus ==
            StreamingConnectionStatus.disconnected) {
      return DisconnectedPage(
        onReconnect: _reconnect,
      );
    } else {
      return MainPage(
        channels: _channels!,
        chatControllers: _chatControllers,
      );
    }
  }
}
