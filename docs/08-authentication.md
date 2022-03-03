# Authentication
In Serverpod, authentication is managed through the `serverpod_auth` module. It makes it easy to authenticate users through email or 3rd parties. Currently supported is Signing in with email, Google, and Apple. Future versions of the authentication module will include more options. Using this module requires some setup with Google and Apple for things to work.

The authentication module also handles basic user information, such as user names and profile pictures.

![Sign-in with Serverpod](https://github.com/serverpod/serverpod/raw/main/misc/images/sign-in.png)

## Installing the module
To install the auth module in your Serverpod server, you need to include it in your server's `pubspec.yaml`. The `serverpod_auth` module is released with the same version numbers as `serverpod` itself, so make sure to use a matching version number in your pubspec file.

```yaml
dependencies:
  serverpod_auth_server: ^0.9.5
```

In addition, you will need to add the module to the config/generator.yaml file.

```yaml
modules:
  serverpod_auth:
    nickname: auth
```

This will tell Serverpod to include the module when it generates the client and server code. The nickname defines which name the client is using to reference the module.

To finalize the installation you will need to run `pub get` and `serverpod generate` from your server's directory.

```sh
flutter pub get
serverpod generate
```

## Setting up Sign in with Google
To set up Sign in with Google, you will need a Google account for your organization and setup a new project. For the project you need to setup _Credentials_ and _Oauth consent screen_. You will need a OAuth 2.0 Client id of type _Web application_.

1. Follow the instructions in the [google_sign_in](https://pub.dev/packages/google_sign_in) plug-in for iOS and Android.
   - For iOS, make sure that you obtain the `GoogleService-Info.plist` and add it to your Xcode project.
   - For Android, there are other setup steps you need to take.
2. In Google cloud, you need to do some additional setup.
   - Activate the _People API_ on your project.
   - Set up the OAuth consent screen. You will need to add the `../auth/userinfo.email` and `../auth/userinfo.profile` scopes. You can also setup additional scopes and access them through Google's APIs on the client or server side.
3. Finally, you need to set up the Google client secret so your server can authenticate the user with Google. In GCP's _APIs & Services_, select the _Credentials tab_. Download the json from your _OAuth 2.0 Client IDs_. Rename it to `google_client_secret.json` and place it in the `config` directory of your server.

## Setting up Sign in with Apple
To configure Sign in with Apple, you will need an Apple developer account. Follow the instructions in [sign_in_with_apple](https://pub.dev/packages/sign_in_with_apple).

_Note that Sign in with Apple may not work on some versions of the Simulator (iOS 13.5 works). This issue doesn't affect real devices._

## Add sign-in buttons in your code
First, you need to add dependencies to your app's `pubspec.yaml` file for the methods of signing in that you want to support. Make sure to use the same version numbers as for serverpod itself.

```yaml
dependencies:
  flutter:
    sdk: flutter
  example_client:
    path: ../example_client
  serverpod_auth_google_flutter: ^0.9.5
  serverpod_auth_apple_flutter: ^0.9.5
```

Next, you need to set up a `SessionManager`, which keeps track of the user's state. It will also handle the authentication keys passed to the client from the server, upload user profile images, etc.

```dart
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

  runApp(MyApp());
}
```

Now, you can simply add the sign-in buttons to your code.

```dart
SignInWithGoogleButton(
  caller: client.modules.auth,
  onSignedIn: () { ... handle sign in here ... },
  onFailure: () { ... handle fail to sign in here ... },
)
```


This is a complete example of a sign-in dialog: [sign_in_dialog.dart](https://github.com/serverpod/serverpod/blob/main/packages/serverpod/example/example_flutter/lib/src/sign_in_dialog.dart).

## Displaying or editing user images
The module has built-in methods for handling a user's basic settings, including uploading new profile pictures.

![UserImageButton](https://github.com/serverpod/serverpod/raw/main/misc/images/user-image-button.png)

To display a user's profile picture, use the `CircularUserImage` widget and pass a `UserInfo` retrieved from the `SessionManager`.

To edit a user profile image, use the `UserImageButton` widget. It will automatically fetch the signed-in user's profile picture and communicate with the server.

## Full example code
Check out the Serverpod [example](https://github.com/serverpod/serverpod/tree/main/packages/serverpod/example) for a complete example of how to wire everything up.
