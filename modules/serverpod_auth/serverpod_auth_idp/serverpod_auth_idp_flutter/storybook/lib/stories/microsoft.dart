import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/story.dart';

final microsoftStories = [
  Story(
    name: 'Microsoft/Button Styles',
    description: 'Microsoft Sign-In button styles side-by-side.',
    builder: (context) {
      final style = context.knobs.options<MicrosoftButtonStyle>(
        label: 'Fill style',
        options: MicrosoftButtonStyle.values.asOptions(),
        initial: MicrosoftButtonStyle.light,
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
        initial: SignInButtonLogoAlignment.center,
      );

      return buildIsolatedElementsForStory(context, {
        'Default': [
          MicrosoftSignInButton(
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
    name: 'Microsoft/Button States',
    description: 'Microsoft Sign-In button states side-by-side.',
    builder: (context) => buildIsolatedElementsForStory(context, {
      'Idle': [
        const MicrosoftSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: false,
        ),
      ],
      'Loading': [
        const MicrosoftSignInButton(
          onPressed: _nullCallback,
          isLoading: true,
          isDisabled: false,
        ),
      ],
      'Disabled': [
        const MicrosoftSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: true,
        ),
      ],
    }),
  ),
];

void _nullCallback() {}
