import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/client.dart';
import '../utils/notification.dart';
import '../utils/story.dart';

final anonymousStories = [
  Story(
    name: 'Anonymous/Working Example',
    description: 'Anonymous Sign-In working example.',
    builder: (context) {
      return wrapWidgetInDefaultColumn(width: 300, [
        AnonymousSignInWidget(
          client: context.read<Client>(),
          onAuthenticated: () {
            context.showSuccessSnackBar('Authenticated with anonymous!');
          },
        ),
      ]);
    },
  ),
];
