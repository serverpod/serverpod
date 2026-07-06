import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter_facebook/serverpod_auth_idp_flutter_facebook.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/story.dart';

final facebookStories = [
  Story(
    name: 'Facebook/Button Styles',
    description: 'Facebook Sign-In button styles side-by-side.',
    builder: (context) {
      final style = context.knobs.options<FacebookButtonStyle>(
        label: 'Fill style',
        options: FacebookButtonStyle.values.asOptions(),
        initial: FacebookButtonStyle.blue,
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
          FacebookSignInButton(
            onPressed: _nullCallback,
            isLoading: false,
            isDisabled: false,
            style: style,
            text: text,
            size: size,
            shape: shape,
            logoAlignment: logoAlignment,
          ),
        ],
      });
    },
  ),
  Story(
    name: 'Facebook/Button States',
    description: 'Facebook Sign-In button states side-by-side.',
    builder: (context) => buildIsolatedElementsForStory(context, {
      'Idle': [
        const FacebookSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: false,
        ),
      ],
      'Loading': [
        const FacebookSignInButton(
          onPressed: _nullCallback,
          isLoading: true,
          isDisabled: false,
        ),
      ],
      'Disabled': [
        const FacebookSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: true,
        ),
      ],
    }),
  ),
];

void _nullCallback() {}
