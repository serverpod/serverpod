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
