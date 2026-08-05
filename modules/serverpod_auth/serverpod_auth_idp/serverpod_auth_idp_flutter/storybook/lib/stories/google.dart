import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/client.dart';
import '../utils/notification.dart';
import '../utils/story.dart';

final googleStories = [
  Story(
    name: 'Google/Button Styles',
    description: 'Google Sign-In button styles side-by-side.',
    builder: (context) {
      final style = context.knobs.options<GoogleButtonStyle>(
        label: 'Fill style',
        options: GoogleButtonStyle.values.asOptions(),
        initial: GoogleButtonStyle.outline,
      );

      final size = context.knobs.options<SignInButtonSize>(
        label: 'Size',
        options: SignInButtonSize.values.asOptions(),
        initial: SignInButtonSize.large,
      );

      final shape = context.knobs.options<SignInButtonShape>(
        label: 'Shape',
        options: SignInButtonShape.values.asOptions(),
        initial: SignInButtonShape.pill,
      );

      final text = context.knobs.options<SignInButtonTextVariant>(
        label: 'Text',
        options: SignInButtonTextVariant.values.asOptions(),
        initial: SignInButtonTextVariant.continueWith,
      );

      final logoAlignment = context.knobs.options<SignInButtonLogoAlignment>(
        label: 'Logo alignment',
        options: SignInButtonLogoAlignment.values.asOptions(),
        initial: SignInButtonLogoAlignment.left,
      );

      return buildIsolatedElementsForStory(context, {
        'Default': [
          GoogleSignInNativeButton(
            onPressed: _nullCallback,
            isLoading: false,
            isDisabled: false,
            style: style,
            size: size,
            text: text,
            shape: shape,
            logoAlignment: logoAlignment,
          ),
        ],
      });
    },
  ),
  Story(
    name: 'Google/Button States',
    description: 'Google Sign-In button states side-by-side.',
    builder: (context) => buildIsolatedElementsForStory(context, {
      'Idle': [
        const GoogleSignInNativeButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: false,
        ),
      ],
      'Loading': [
        const GoogleSignInNativeButton(
          onPressed: _nullCallback,
          isLoading: true,
          isDisabled: false,
        ),
      ],
      'Disabled': [
        const GoogleSignInNativeButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: true,
        ),
      ],
    }),
  ),
  Story(
    name: 'Google/Working Example',
    description: 'Configure the project and test this working example.',
    builder: (context) => wrapWidgetInDefaultColumn([
      const Text(
        'For this story to work, follow the instructions in the README.md file '
        'of the example project at `examples/auth/auth_flutter` to configure '
        'this project as well. The server is mocked, so this test will only '
        'validate the correct behavior of the Google Sign-In widget, not the '
        'authentication flow itself.',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      GoogleSignInWidget(
        client: context.read<Client>(),
        onAuthenticated: () {
          context.showSuccessSnackBar('Authenticated with Google!');
        },
        onError: (error) {
          context.showErrorSnackBar(error.toString());
        },
      ),
    ], width: 300),
  ),
];

void _nullCallback() {}
