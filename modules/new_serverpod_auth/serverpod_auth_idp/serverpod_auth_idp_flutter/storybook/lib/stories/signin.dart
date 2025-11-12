import 'package:flutter/material.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../utils/client.dart';
import '../utils/notification.dart';

final List<Story> signInStories = [
  Story(
    name: 'Sign In/Global Widget',
    description:
        'Sign in flow using the global ServerpodSignInWidget, demonstrating '
        'registration and authentication with email (mocked endpoint).',
    builder: (context) {
      final client = context.read<Client>();
      return Container(
        width: 350,
        color: Colors.white,
        child: SignInWidget(
          client: client,
          onAuthenticated: () {
            context.showSuccessSnackBar('Authenticated!');
          },
          onError: (error) {
            context.showErrorSnackBar(error.toString());
          },
        ),
      );
    },
  ),
];
