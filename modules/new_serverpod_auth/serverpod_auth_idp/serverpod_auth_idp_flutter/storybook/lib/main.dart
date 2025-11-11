import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import 'stories/email.dart';
import 'stories/google.dart';
import 'stories/signin.dart';
import 'utils/client.dart';

final client = Client('http://localhost:8080/')
  ..authSessionManager = ClientAuthSessionManager();

void main() {
  client.auth.initialize();
  client.auth.initializeGoogleSignIn();

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
        initialStory: 'Home',
        plugins: StorybookPlugins(
          enableTimeDilation: true,
          initialDeviceFrameData: const DeviceFrameData(
            visibility: DeviceFrameVisibility.visible,
            orientation: Orientation.portrait,
          ),
        ),
        stories: [...emailStories, ...googleStories, ...signInStories],
      ),
    );
  }
}
