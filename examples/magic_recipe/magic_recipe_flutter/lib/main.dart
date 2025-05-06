// @@@SNIPSTART 03-flutter
import 'package:image_picker/image_picker.dart';
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
/// In a larger app, you may want to use the dependency injection of your choice
/// instead of using a global client object. This is just a simple example.
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

  /// Holds the last error message that we've received from the server or null
  // if no error exists yet.
  String? _errorMessage;

  String? _imagePath;

  final _textEditingController = TextEditingController();

  bool _loading = false;

  void _callGenerateRecipe() async {
    Recipe? result;
    try {
      setState(() {
        _errorMessage = null;
        _recipe = null;
        _loading = true;
      });
      await for (var updatedRecipe in client.recipe
          .generateRecipeAsStream(_textEditingController.text, _imagePath)) {
        print('Updated recipe: $updatedRecipe');
        setState(() {
          result = updatedRecipe;
          _recipe = updatedRecipe;
          _errorMessage = null;
        });
      }
      setState(() {
        _errorMessage = null;
        _recipe = result;
        _loading = false;
        if (result != null) {
          _recipeHistory.insert(0, result!);
        }
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
                      recipe.text.substring(
                        0,
                        recipe.text.indexOf('\n'),
                      ),
                    ),
                    subtitle: Text('${recipe.author} - ${recipe.date}'),
                    onTap: () {
                      setState(() {
                        _errorMessage = null;
                        _textEditingController.text = recipe.ingredients;
                        _imagePath = recipe.imageUrl;
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
                    child: Row(
                      spacing: 16,
                      children: [
                        ElevatedButton(
                          onPressed: _loading ? null : _callGenerateRecipe,
                          child: _loading
                              ? const Text('Loading...')
                              : const Text('Send to Server'),
                        ),
                        ImageUploadButton(
                          key: ValueKey(_imagePath),
                          onImagePathChanged: (imagePath) {
                            setState(() {
                              _imagePath = imagePath;
                            });
                          },
                          imagePath: _imagePath,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child:
                          // Change the ResultDisplay to use the Recipe object
                          ResultDisplay(
                        resultMessage: _recipe != null
                            ? '${_recipe?.author} on ${_recipe?.date}:'
                                '\n${_recipe?.text}'
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

class ImageUploadButton extends StatefulWidget {
  final String? imagePath;

  final ValueChanged<String?>? onImagePathChanged;

  const ImageUploadButton({super.key, this.onImagePathChanged, this.imagePath});

  @override
  State<ImageUploadButton> createState() => _ImageUploadButtonState();
}

class _ImageUploadButtonState extends State<ImageUploadButton> {
  Future<String?> uploadImage(XFile imageFile) async {
    var imageStream = imageFile.openRead();
    var length = await imageFile.length();
    final (uploadDescription, path) =
        await client.recipe.getUploadDescription(imageFile.name);
    if (uploadDescription != null) {
      var uploader = FileUploader(uploadDescription);
      await uploader.upload(imageStream, length);
      var success = await client.recipe.verifyUpload(path);
      return success ? path : null;
    }
    return null;
  }

  bool uploading = false;

  late ValueNotifier<String?> imagePath;

  @override
  void initState() {
    super.initState();
    imagePath = ValueNotifier<String?>(widget.imagePath);
    imagePath.addListener(() {
      widget.onImagePathChanged?.call(imagePath.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (uploading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (imagePath.value != null)
          Stack(
            children: [
              // delete button
              Positioned(
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      imagePath.value = null;
                    });
                  },
                ),
              ),
              ServerpodImage(
                  imagePath: imagePath.value, key: ValueKey(imagePath.value)),
            ],
          ),
        if (imagePath.value == null)
          ElevatedButton(
            onPressed: () async {
              // pick an image
              final imageFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);

              if (imageFile != null) {
                // get the file stream
                // upload the image
                setState(() {
                  uploading = true;
                });
                imagePath.value = await uploadImage(imageFile);
                setState(() {
                  uploading = false;
                });
                print('Image path: $imagePath');
              }
            },
            child: const Text('Upload Image'),
          ),
      ],
    );
  }
}

class ServerpodImage extends StatefulWidget {
  const ServerpodImage({
    super.key,
    required this.imagePath,
  });

  final String? imagePath;

  @override
  State<ServerpodImage> createState() => _ServerpodImageState();
}

class _ServerpodImageState extends State<ServerpodImage> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.imagePath != null) {
      print('Image path: ${widget.imagePath}');
      fetchUrlAndRebuild();
    }
  }

  Future<void> fetchUrlAndRebuild() async {
    imageUrl = await client.recipe.getPublicUrlForPath(widget.imagePath!);
    print('Image URL: $imageUrl');
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ServerpodImage oldWidget) {
    if (widget.imagePath != oldWidget.imagePath) {
      imageUrl = null;
      fetchUrlAndRebuild();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Image.network(imageUrl!, width: 100, height: 100, fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.error);
    }, loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
// @@@SNIPEND
