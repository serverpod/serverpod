import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
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

      final size = context.knobs.options<FacebookButtonSize>(
        label: 'Size',
        options: FacebookButtonSize.values.asOptions(),
        initial: FacebookButtonSize.large,
      );

      final shape = context.knobs.options<FacebookButtonShape>(
        label: 'Shape',
        options: FacebookButtonShape.values.asOptions(),
        initial: FacebookButtonShape.pill,
      );

      final type = context.knobs.options<FacebookButtonText>(
        label: 'Text',
        options: FacebookButtonText.values.asOptions(),
        initial: FacebookButtonText.continueWith,
      );

      final logoAlignment = context.knobs.options<FacebookButtonLogoAlignment>(
        label: 'Logo alignment',
        options: FacebookButtonLogoAlignment.values.asOptions(),
        initial: FacebookButtonLogoAlignment.left,
      );

      return buildIsolatedElementsForStory(context, {
        'Default': [
          FacebookSignInButton(
            onPressed: _nullCallback,
            isLoading: false,
            isDisabled: false,
            style: style,
            type: type,
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
