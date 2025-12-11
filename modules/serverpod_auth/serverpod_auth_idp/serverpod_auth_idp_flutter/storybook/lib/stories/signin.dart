import 'package:flutter/material.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../utils/client.dart';
import '../utils/notification.dart';

final List<Story> signInStories = [
  Story(
    name: 'Sign In/Default Widget',
    description:
        'Sign in flow using the default sign-in widget. Email can be '
        'tested as the endpoint is mocked.',
    builder: (context) => _signInWidgetStory(context),
  ),
  Story(
    name: 'Sign In/Disabled Email Widget',
    description: 'Sign in flow suppressing the email sign-in widget.',
    builder: (context) =>
        _signInWidgetStory(context, disableEmailSignInWidget: true),
  ),
  Story(
    name: 'Sign In/Disabled Google Widget',
    description: 'Sign in flow suppressing the Google sign-in widget.',
    builder: (context) =>
        _signInWidgetStory(context, disableGoogleSignInWidget: true),
  ),
  Story(
    name: 'Sign In/Disabled Apple Widget',
    description: 'Sign in flow suppressing the Apple sign-in widget.',
    builder: (context) =>
        _signInWidgetStory(context, disableAppleSignInWidget: true),
  ),
];

Widget _signInWidgetStory(
  BuildContext context, {
  bool disableEmailSignInWidget = false,
  bool disableGoogleSignInWidget = false,
  bool disableAppleSignInWidget = false,
}) {
  return SizedBox(
    width: 350,
    child: SignInWidget(
      client: context.read<Client>(),
      onAuthenticated: () {
        context.showSuccessSnackBar('Authenticated!');
      },
      onError: (error) {
        context.showErrorSnackBar(error.toString());
      },
      disableEmailSignInWidget: disableEmailSignInWidget,
      disableGoogleSignInWidget: disableGoogleSignInWidget,
      disableAppleSignInWidget: disableAppleSignInWidget,
    ),
  );
}
