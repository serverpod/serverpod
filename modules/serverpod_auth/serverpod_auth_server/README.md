# Serverpod authentication module
The Serverpod auth module makes it easy to authenticate users using 3rd parties. Currently supported is Signing in with email, Google, and Apple. Future versions of the authentication module will include more options. Using this module requires some setup with Google and Apple for things to work.

The authentication module also handles basic user information, such as user names and profile pictures.

![Sign-in with Serverpod](https://github.com/serverpod/serverpod/raw/main/misc/images/sign-in.png)

## Installing the module
To install the auth module in your Serverpod server, you need to include it in your server's `pubspec.yaml`. At this point, the auth module is not yet published on pub.dev, so you will need to clone the serverpod repo and set the path for the serverpod_auth_server package.

    dependencies:
      serverpod_auth_server:
        path: path/to/serverpod/modules/serverpod_auth/serverpod_auth_server

In addition, you will need to add the module to the config/generator.yaml file.

    modules:
      serverpod_auth:
        nickname: auth

This will tell Serverpod to include the module when it generates the client and server code. The nickname defines which name the client is using to reference the module.

## Setting up Sign in with Google
To set up Sign in with Google, you will need a Firebase and Google account for your organization.

1. Follow the instructions in the [google_sign_in](https://pub.dev/packages/google_sign_in) plug-in for iOS and Android.
   - For iOS, make sure that you obtain the `GoogleService-Info.plist` and add it to your Xcode project.
   - For Android, there are other setup steps you need to take.
2. In Google cloud, you need to do some additional setup.
   - To access the Firebase project in Google cloud the first time, you may need to copy the project identifier and place it directly in the Google cloud URL. Otherwise, you may not see the project on the list. E.g., https://console.cloud.google.com/apis/dashboard?project=PROJECT_ID
   - Activate the _People API_ on your project.
   - Set up the OAuth consent screen. You will need to add the `../auth/userinfo.email` and `../auth/userinfo.profile` scopes.
3. Finally, you need to set up the Google client secret so your server can authenticate the user with Google. In GCP's _APIs & Services_, select the Credentials tab. Download the _Web client (auto created by Google Service)_ under _OAuth 2.0 Client IDs_. Rename it to `google_client_secret.json` and place it in the `config` directory of your server.

## Setting up Sign in with Apple
To configure Sign in with Apple, you will need an Apple developer account. Follow the instructions in [sign_in_with_apple](https://pub.dev/packages/sign_in_with_apple).

_Note that Sign in with Apple may not work on some versions of the Simulator (iOS 13.5 works). This issue doesn't affect real devices._

## Add sign-in buttons in your code
First, you need to add dependencies to your app's pubspec.yaml file for the methods of signing in that you want to support.

    dependencies:
      flutter:
        sdk: flutter
      example_client:
        path: ../example_client
      serverpod_auth_google_flutter:
        path: path/to/serverpod/modules/serverpod_auth/serverpod_auth_google_flutter
      serverpod_auth_apple_flutter:
        path: path/to/serverpod/modules/serverpod_auth/serverpod_auth_apple_flutter

Next, you need to set up a `SessionManager`, which keeps track of the user's state. It will also handle the authentication keys passed to the client from the server, upload user profile images, etc.

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

Now, you can simply add the sign-in buttons to your code.

    SignInWithGoogleButton(
      caller: client.modules.auth,
      onSignedIn: () { ... handle sign in here ... },
      onFailure: () { ... handle fail to sign in here ... },
    )


This is a complete example of a sign-in dialog: [sign_in_dialog.dart](https://github.com/serverpod/serverpod/blob/main/packages/serverpod/example/example_flutter/lib/src/sign_in_dialog.dart).

## Displaying or editing user images
The module has built-in methods for handling a user's basic settings, including uploading new profile pictures.

![UserImageButton](https://github.com/serverpod/serverpod/raw/main/misc/images/user-image-button.png)

To display a user's profile picture, use the `CircularUserImage` widget and pass a `UserInfo` retrieved from the `SessionManager`.

To edit a user profile image, use the `UserImageButton` widget. It will automatically fetch the signed-in user's profile picture and communicate with the server.

## Full example code
Check out the Serverpod [example](https://github.com/serverpod/serverpod/tree/main/packages/serverpod/example) for a complete example of how to wire everything up.