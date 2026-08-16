import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/story.dart';

final appleStories = [
  Story(
    name: 'Apple/Button Styles',
    description: 'Apple Sign-In button styles side-by-side.',
    builder: (context) {
      final style = context.knobs.options<AppleButtonStyle>(
        label: 'Fill style',
        options: AppleButtonStyle.values.asOptions(),
        initial: AppleButtonStyle.black,
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
          AppleSignInButton(
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
    name: 'Apple/Button States',
    description: 'Apple Sign-In button states side-by-side.',
    builder: (context) => buildIsolatedElementsForStory(context, {
      'Idle': [
        const AppleSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: false,
        ),
      ],
      'Loading': [
        const AppleSignInButton(
          onPressed: _nullCallback,
          isLoading: true,
          isDisabled: false,
        ),
      ],
      'Disabled': [
        const AppleSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: true,
        ),
      ],
    }),
  ),
];

void _nullCallback() {}
