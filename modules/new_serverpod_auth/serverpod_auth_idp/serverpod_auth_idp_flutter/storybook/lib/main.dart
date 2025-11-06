import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import 'utils/client.dart';
import 'stories/google.dart';

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
    return Storybook(
      canvasColor: Colors.white,
      initialStory: 'Home',
      plugins: StorybookPlugins(
        enableTimeDilation: true,
        initialDeviceFrameData: const DeviceFrameData(
          visibility: DeviceFrameVisibility.visible,
          orientation: Orientation.portrait,
        ),
      ),
      stories: [...googleStories],
    );
  }
}
