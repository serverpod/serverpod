import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter_facebook/serverpod_auth_idp_flutter_facebook.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import 'stories/anonymous.dart';
import 'stories/apple.dart';
import 'stories/email.dart';
import 'stories/facebook.dart';
import 'stories/github.dart';
import 'stories/google.dart';
import 'stories/microsoft.dart';
import 'stories/signin.dart';
import 'utils/client.dart';
import 'utils/wrapper.dart';

final client = Client('http://localhost:8080/')
  ..authSessionManager = FlutterAuthSessionManager();

void main() {
  client.auth.initialize();
  client.auth.initializeGoogleSignIn();
  client.auth.initializeAppleSignIn();
  client.auth.initializeGitHubSignIn();
  client.auth.initializeMicrosoftSignIn();
  client.auth.initializeFacebookSignIn(
    appId: 'your-facebook-app-id', // throws if not provided on web and macos
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => client),
      ],
      child: Storybook(
        canvasColor: Colors.white,
        wrapperBuilder: wrapperBuilder,
        initialStory: 'Home',
        plugins: StorybookPlugins(
          enableTimeDilation: true,
          initialDeviceFrameData: const DeviceFrameData(
            visibility: DeviceFrameVisibility.visible,
            orientation: Orientation.portrait,
          ),
        ),
        stories: [
          ...anonymousStories,
          ...emailStories,
          ...googleStories,
          ...appleStories,
          ...facebookStories,
          ...githubStories,
          ...microsoftStories,
          ...signInStories,
        ],
      ),
    );
  }
}
