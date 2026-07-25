import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/client.dart';
import '../utils/notification.dart';
import '../utils/story.dart';

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
  final width = context.knobs.sliderInt(
    label: 'Column width',
    initial: 400,
    min: 270,
    max: 400,
  );

  return SizedBox(
    width: width.toDouble(),
    child: SignInWidget(
      client: context.read<Client>(),
      onAuthenticated: () {
        context.showSuccessSnackBar('Authenticated!');
      },
      onError: (error) {
        context.showErrorSnackBar(error.toString());
      },
      buttonStyle: _signInButtonStyleFromKnobs(context),
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

SignInButtonStyle _signInButtonStyleFromKnobs(BuildContext context) {
  final size = context.knobs.nullable.options<SignInButtonSize>(
    label: 'Size',
    options: SignInButtonSize.values.asOptions(),
    initial: SignInButtonSize.large,
  );

  final shape = context.knobs.nullable.options<SignInButtonShape>(
    label: 'Shape',
    options: SignInButtonShape.values.asOptions(),
    initial: SignInButtonShape.pill,
  );

  final logoAlignment = context.knobs.nullable
      .options<SignInButtonLogoAlignment>(
        label: 'Logo alignment',
        options: SignInButtonLogoAlignment.values.asOptions(),
        initial: SignInButtonLogoAlignment.left,
      );

  final text = context.knobs.nullable.options<SignInButtonTextVariant>(
    label: 'Text',
    options: SignInButtonTextVariant.values.asOptions(),
    initial: SignInButtonTextVariant.continueWith,
  );

  final minimumWidth = context.knobs.nullable
      .sliderInt(
        label: 'Minimum width',
        initial: 300,
        min: 100,
        max: 400,
      )
      ?.toDouble();

  final backgroundColor = context.knobs.nullable.options<Color>(
    label: 'Background color',
    options: _signInButtonColorOptions,
    initial: const Color(0xFFFFFFFF),
  );

  final foregroundColor = context.knobs.nullable.options<Color>(
    label: 'Foreground color',
    options: _signInButtonColorOptions,
    initial: const Color(0xFF1F1F1F),
  );

  final borderColor = context.knobs.nullable.options<Color>(
    label: 'Border color',
    options: _signInButtonColorOptions,
    initial: const Color(0xFFDADCE0),
  );

  return SignInButtonStyle(
    size: size,
    shape: shape,
    logoAlignment: logoAlignment,
    text: text,
    minimumWidth: minimumWidth,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    borderColor: borderColor,
  );
}

const _signInButtonColorOptions = [
  Option(label: 'White', value: Color(0xFFFFFFFF)),
  Option(label: 'Off-black', value: Color(0xFF1F1F1F)),
  Option(label: 'Light gray border', value: Color(0xFFDADCE0)),
  Option(label: 'Dark gray border', value: Color(0xFF5F6368)),
  Option(label: 'Blue', value: Colors.blue),
  Option(label: 'Google blue', value: Color(0xFF4285F4)),
];
