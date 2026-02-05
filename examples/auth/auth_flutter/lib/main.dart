import 'package:auth_client/auth_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'firebase.dart';
import 'widgets/profile_info.dart';

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
/// In a larger app, you may want to use the dependency injection of your choice
/// instead of using a global client object. This is just a simple example.
late final Client client;

late String serverUrl;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  // When you are running the app on a physical device, you need to set the
  // server URL to the IP address of your computer. You can find the IP
  // address by running `ipconfig` on Windows or `ifconfig` on Mac/Linux.
  // You can set the variable when running or building your app like this:
  // E.g. `flutter run --dart-define=SERVER_URL=https://api.example.com/`
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl = serverUrlFromEnv.isEmpty
      ? 'http://$localhost:8080/'
      : serverUrlFromEnv;

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  client.auth.initialize();

  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          surface: Colors.white,
          primary: Color.fromARGB(255, 1, 58, 104),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();

    // NOTE: This is the only required setState to ensure that the  UI gets
    // updated when the auth state changes.
    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _updateSignedInState();
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = client.auth.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSignedIn ? const ConnectedScreen() : const SignInScreen();
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uncomment this to replace the default sign-in screen with Firebase.
      // See the `firebase.dart` file for more information.
      // body: FirebaseSignInScreen(client: client),
      body: SignInWidget(
        client: client,
        // NOTE: No need to call navigation here if it gets done on the
        // client.auth.authInfo listener.
        onAuthenticated: () => onAuthenticated(context),
        onError: (error) => onError(context, error),
        // NOTE: To customize widgets, pass the desired widget here.
        // googleSignInWidget: GoogleSignInWidget(
        //   client: client,
        //   onAuthenticated: () => onAuthenticated(context),
        //   onError: (error) => onError(context, error),
        //   scopes: const [],
        // ),
      ),
    );
  }

  void onAuthenticated(BuildContext context) {
    context.showSnackBar(
      message: 'User authenticated.',
      backgroundColor: Colors.green,
    );
  }

  void onError(BuildContext context, Object error) {
    context.showSnackBar(
      message: 'Authentication failed: $error',
      backgroundColor: Colors.red,
    );
  }
}

class ConnectedScreen extends StatefulWidget {
  const ConnectedScreen({super.key});

  @override
  State<ConnectedScreen> createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen> {
  ConnectedIdps? connectedIdps;

  @override
  void initState() {
    client.auth.idp.getConnectedIdps().then((c) {
      setState(() {
        connectedIdps = c;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileWidget(client: client),
            const Text('You are connected'),
            FilledButton(
              onPressed: () async {
                await client.auth.signOutDevice();
              },
              child: const Text('Sign out'),
            ),

            if (connectedIdps == null) CircularProgressIndicator.adaptive(),

            if (connectedIdps != null) ...[
              Text('All connected Idps: ${connectedIdps!.names}'),
              SizedBox(height: 8),
              Text('User has Google: ${connectedIdps!.hasGoogle ? '✅' : '❌'}'),
              SizedBox(height: 8),
              Text('User has Email: ${connectedIdps!.hasEmail ? '✅' : '❌'}'),
              SizedBox(height: 8),
              Text('User has Apple: ${connectedIdps!.hasApple ? '✅' : '❌'}'),
              SizedBox(height: 8),
              Text(
                'User has Firebase: ${connectedIdps!.hasFirebase ? '✅' : '❌'}',
              ),
              SizedBox(height: 8),
            ],

            if (connectedIdps != null && connectedIdps!.hasGoogle)
              FilledButton(
                onPressed: () async {
                  await client.auth.disconnectGoogleAccount();
                },
                child: const Text('Disconnect Google'),
              ),
          ],
        ),
      ),
    );
  }
}

extension on BuildContext {
  void showSnackBar({
    required String message,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
