# auth_flutter

The example Flutter application for Serverpod's authentication module.

See the [Serverpod documentation](https://docs.serverpod.dev) for more
information.

## Sign-In With Google Setup

Additional steps are required to run the app with Google Sign-In. For web,
replace the `GOOGLE_CLIENT_ID` in the `web/index.html` file with the client ID
from your Google Cloud project.

For iOS and Android, run the app passing the `--dart-define` flag with the
Google client ID:

```bash
flutter run \
  --dart-define=GOOGLE_CLIENT_ID=your_google_client_id \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=your_google_server_client_id
```

Also make sure to add the reversed client ID for iOS as indicated in the
[official documentation](https://developers.google.com/identity/sign-in/ios/start-integrating):

```xml
<!-- Put me in the [my_project]/ios/Runner/Info.plist file -->
<!-- Google Sign-in Section -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- TODO Replace this value: -->
            <!-- Copied from GoogleService-Info.plist key REVERSED_CLIENT_ID -->
            <string>com.googleusercontent.apps.REVERSED_GOOGLE_CLIENT_ID</string>
        </array>
    </dict>
</array>
<!-- End of the Google Sign-in Section -->
```

To run the app for web, make sure to specify the hostname and port using the
same port configured on the Google OAuth credentials (usually 7357):

```bash
flutter run -d chrome --web-hostname localhost --web-port 7357
```

> For more information on how to configure the credentials for each platform
> see the [Google Sign-In for Flutter documentation](https://pub.dev/packages/google_sign_in).

## Sign-In With Apple Setup

Additional steps are required to run the app with Apple Sign-In on Android and
web platforms.

For **Android** and **web**, run the app passing the `--dart-define` flag with
the Apple service identifier and redirect URI:

```bash
flutter run \
  --dart-define=APPLE_SERVICE_IDENTIFIER=com.example.app.service \
  --dart-define=APPLE_REDIRECT_URI=https://example.com/auth/apple/callback
```

It is also possible to set these parameters through the code by providing them
when initializing Apple Sign-In:

```dart
await client.auth.initializeAppleSignIn(
  serviceIdentifier: 'com.example.app.service',
  redirectUri: 'https://example.com/auth/apple/callback',
);
```

**Note**: These configuration parameters are **not required** for native Apple
platforms (iOS/macOS), as they use the native Apple Sign-In flow. They are only
needed for Android and web platforms.

> For more information on how to configure Apple Sign-In credentials, see the
> [Sign in with Apple documentation](https://developer.apple.com/documentation/sign_in_with_apple/sign_in_with_apple_js/incorporating_sign_in_with_apple_into_other_platforms).

## Sign-In With Firebase Setup

Firebase Authentication allows you to use Firebase's authentication system with
Serverpod. This enables you to leverage Firebase's various sign-in providers
(email/password, phone, social providers, etc.) while syncing the authenticated
user with Serverpod's auth system.

### 1. Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable the Authentication providers you want to use (e.g., Email/Password)

### 2. Configure FlutterFire

Install the FlutterFire CLI and configure your Flutter app:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure your Flutter app (run from the auth_flutter directory)
flutterfire configure
```

This will generate the `lib/firebase_options.dart` file with your Firebase
configuration.

### 3. Enable Firebase in the App

In `lib/firebase.dart`, uncomment the import and options line:

```dart
// Uncomment this import:
import 'firebase_options.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    // Uncomment this line:
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
```

### 4. Server Configuration

On the server side, you need to configure the Firebase service account key for
ID token verification. In your server's `config/passwords.yaml`, add your
Firebase service account JSON:

```yaml
firebase:
  serviceAccountKey: |
    {
      "type": "service_account",
      "project_id": "your-project-id",
      ...
    }
```

You can download the service account key from the Firebase Console under
**Project Settings > Service Accounts > Generate New Private Key**.

> For more information on Firebase Authentication, see the
> [Firebase Authentication documentation](https://firebase.google.com/docs/auth/flutter/start)
