import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

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
    name: 'Sign In/Disabled Anonymous Widget',
    description: 'Sign in flow suppressing the anonymous sign-in widget.',
    builder: (context) =>
        _signInWidgetStory(context, disableAnonymousSignInWidget: true),
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
  Story(
    name: 'Sign In/Disabled GitHub Widget',
    description: 'Sign in flow suppressing the GitHub sign-in widget.',
    builder: (context) =>
        _signInWidgetStory(context, disableGitHubSignInWidget: true),
  ),
  Story(
    name: 'Sign In/Disabled Microsoft Widget',
    description: 'Sign in flow suppressing the Microsoft sign-in widget.',
    builder: (context) =>
        _signInWidgetStory(context, disableMicrosoftSignInWidget: true),
  ),
  Story(
    name: 'Sign In/Disabled Facebook Widget',
    description: 'Sign in flow suppressing the Facebook sign-in widget.',
    builder: (context) =>
        _signInWidgetStory(context, disableFacebookSignInWidget: true),
  ),
  Story(
    name: 'Sign In/Only Email and Anonymous Widget',
    description: 'Sign in flow with only email and anonymous sign-in widgets.',
    builder: (context) => _signInWidgetStory(
      context,
      disableGoogleSignInWidget: true,
      disableAppleSignInWidget: true,
      disableGitHubSignInWidget: true,
      disableMicrosoftSignInWidget: true,
      disableFacebookSignInWidget: true,
    ),
  ),
];

Widget _signInWidgetStory(
  BuildContext context, {
  bool disableAnonymousSignInWidget = false,
  bool disableEmailSignInWidget = false,
  bool disableGoogleSignInWidget = false,
  bool disableAppleSignInWidget = false,
  bool disableGitHubSignInWidget = false,
  bool disableMicrosoftSignInWidget = false,
  bool disableFacebookSignInWidget = false,
}) {
  return SizedBox(
    width: 400,
    child: SignInWidget(
      client: context.read<Client>(),
      onAuthenticated: () {
        context.showSuccessSnackBar('Authenticated!');
      },
      onError: (error) {
        context.showErrorSnackBar(error.toString());
      },
      disableAnonymousSignInWidget: disableAnonymousSignInWidget,
      disableEmailSignInWidget: disableEmailSignInWidget,
      disableGoogleSignInWidget: disableGoogleSignInWidget,
      disableAppleSignInWidget: disableAppleSignInWidget,
      disableGitHubSignInWidget: disableGitHubSignInWidget,
      disableMicrosoftSignInWidget: disableMicrosoftSignInWidget,
      disableFacebookSignInWidget: disableFacebookSignInWidget,
    ),
  );
}
