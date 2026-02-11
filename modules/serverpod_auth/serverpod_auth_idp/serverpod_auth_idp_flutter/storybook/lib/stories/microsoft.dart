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

      final size = context.knobs.options<MicrosoftButtonSize>(
        label: 'Size',
        options: MicrosoftButtonSize.values.asOptions(),
        initial: MicrosoftButtonSize.large,
      );

      final shape = context.knobs.options<MicrosoftButtonShape>(
        label: 'Shape',
        options: MicrosoftButtonShape.values.asOptions(),
        initial: MicrosoftButtonShape.pill,
      );

      final text = context.knobs.options<MicrosoftButtonText>(
        label: 'Text',
        options: MicrosoftButtonText.values.asOptions(),
        initial: MicrosoftButtonText.continueWith,
      );

      final logoAlignment = context.knobs.options<MicrosoftButtonLogoAlignment>(
        label: 'Logo alignment',
        options: MicrosoftButtonLogoAlignment.values.asOptions(),
        initial: MicrosoftButtonLogoAlignment.center,
      );

      final type = context.knobs.options<MicrosoftButtonType>(
        label: 'Type',
        options: MicrosoftButtonType.values.asOptions(),
        initial: MicrosoftButtonType.standard,
      );

      return buildIsolatedElementsForStory(context, {
        'Default': [
          MicrosoftSignInButton(
            onPressed: _nullCallback,
            isLoading: false,
            isDisabled: false,
            style: style,
            type: type,
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
