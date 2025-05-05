// @@@SNIPSTART 03-flutter
import 'package:magic_recipe_client/magic_recipe_client.dart';
import 'package:flutter/material.dart';
import 'package:magic_recipe_flutter/admin_dashboard.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
/// In a larger app, you may want to use the dependency injection of your choice instead of
/// using a global client object. This is just a simple example.
late final Client client;

late final String serverUrl;

late final SessionManager sessionManager;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // When you are running the app on a physical device, you need to set the
  // server URL to the IP address of your computer. You can find the IP
  // address by running `ipconfig` on Windows or `ifconfig` on Mac/Linux.
  // You can set the variable when running or building your app like this:
  // E.g. `flutter run --dart-define=SERVER_URL=https://api.example.com/`
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl =
      serverUrlFromEnv.isEmpty ? 'http://$localhost:8080/' : serverUrlFromEnv;

  client = Client(
    serverUrl,
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

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
      title: 'Serverpod Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: sessionManager.isSignedIn
          ? const MyHomePage(title: 'Serverpod Example')
          : const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SignInWithEmailButton(
          caller: client.modules.auth,
          onSignedIn: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const MyHomePage(title: 'Serverpod Example'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  /// Holds the last result or null if no result exists yet.
  Recipe? _recipe;

  List<Recipe> _recipeHistory = [];

  /// Holds the last error message that we've received from the server or null if no
  /// error exists yet.
  String? _errorMessage;

  final _textEditingController = TextEditingController();

  bool _loading = false;

  void _callGenerateRecipe() async {
    try {
      setState(() {
        _errorMessage = null;
        _recipe = null;
        _loading = true;
      });
      final result =
          await client.recipe.generateRecipe(_textEditingController.text);
      setState(() {
        _errorMessage = null;
        _recipe = result;
        _loading = false;
        _recipeHistory.insert(0, result);
      });
    } catch (e) {
      setState(() {
        _errorMessage = '$e';
        _recipe = null;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Get the favourite recipes from the database
    client.recipe.getRecipes().then((favouriteRecipes) {
      setState(() {
        _recipeHistory = favouriteRecipes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (sessionManager.signedInUser?.scopeNames
                  .contains('serverpod.admin') ??
              false)
            IconButton(
                icon: const Icon(Icons.admin_panel_settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminDashboard(),
                    ),
                  );
                }),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await sessionManager.signOutDevice();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: ListView.builder(
                itemCount: _recipeHistory.length,
                itemBuilder: (context, index) {
                  final recipe = _recipeHistory[index];
                  return ListTile(
                    title: Text(
                        recipe.text.substring(0, recipe.text.indexOf('\n'))),
                    subtitle: Text('${recipe.author} - ${recipe.date}'),
                    onTap: () {
                      // Show the recipe in the text field
                      _textEditingController.text = recipe.ingredients;
                      setState(() {
                        _recipe = recipe;
                      });
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // Delete the recipe from the database
                        await client.recipe.deleteRecipe(recipe.id!);
                        setState(
                          () {
                            _recipeHistory.removeAt(index);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your ingredients',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: _loading ? null : _callGenerateRecipe,
                      child: _loading
                          ? const Text('Loading...')
                          : const Text('Send to Server'),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child:
                          // Change the ResultDisplay to use the Recipe object
                          ResultDisplay(
                        resultMessage: _recipe != null
                            ? '${_recipe?.author} on ${_recipe?.date}:\n${_recipe?.text}'
                            : null,
                        errorMessage: _errorMessage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ResultDisplays shows the result of the call. Either the returned result from
/// the `example.greeting` endpoint method or an error message.
class ResultDisplay extends StatelessWidget {
  final String? resultMessage;
  final String? errorMessage;

  const ResultDisplay({
    super.key,
    this.resultMessage,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    Color backgroundColor;
    if (errorMessage != null) {
      backgroundColor = Colors.red[300]!;
      text = errorMessage!;
    } else if (resultMessage != null) {
      backgroundColor = Colors.green[300]!;
      text = resultMessage!;
    } else {
      backgroundColor = Colors.grey[300]!;
      text = 'No server response yet.';
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 50),
      child: Container(
        color: backgroundColor,
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
// @@@SNIPEND
