import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/story.dart';

final twitchStories = [
  Story(
    name: 'Twitch/Button Styles',
    description: 'Twitch Sign-In button styles side-by-side.',
    builder: (context) {
      final style = context.knobs.options<TwitchButtonStyle>(
        label: 'Fill style',
        options: TwitchButtonStyle.values.asOptions(),
        initial: TwitchButtonStyle.black,
      );

      final size = context.knobs.options<TwitchButtonSize>(
        label: 'Size',
        options: TwitchButtonSize.values.asOptions(),
        initial: TwitchButtonSize.large,
      );

      final shape = context.knobs.options<TwitchButtonShape>(
        label: 'Shape',
        options: TwitchButtonShape.values.asOptions(),
        initial: TwitchButtonShape.pill,
      );

      final text = context.knobs.options<TwitchButtonText>(
        label: 'Text',
        options: TwitchButtonText.values.asOptions(),
        initial: TwitchButtonText.continueWith,
      );

      final logoAlignment = context.knobs.options<TwitchButtonLogoAlignment>(
        label: 'Logo alignment',
        options: TwitchButtonLogoAlignment.values.asOptions(),
        initial: TwitchButtonLogoAlignment.left,
      );

      final type = context.knobs.options<TwitchButtonType>(
        label: 'Type',
        options: TwitchButtonType.values.asOptions(),
        initial: TwitchButtonType.standard,
      );

      return buildIsolatedElementsForStory(context, {
        'Default': [
          TwitchSignInButton(
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
    name: 'Twitch/Button States',
    description: 'Twitch Sign-In button states side-by-side.',
    builder: (context) => buildIsolatedElementsForStory(context, {
      'Idle': [
        const TwitchSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: false,
        ),
      ],
      'Loading': [
        const TwitchSignInButton(
          onPressed: _nullCallback,
          isLoading: true,
          isDisabled: false,
        ),
      ],
      'Disabled': [
        const TwitchSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: true,
        ),
      ],
    }),
  ),
];

void _nullCallback() {}
