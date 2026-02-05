import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/story.dart';

final githubStories = [
  Story(
    name: 'GitHub/Button Styles',
    description: 'GitHub Sign-In button styles side-by-side.',
    builder: (context) {
      final style = context.knobs.options<GitHubButtonStyle>(
        label: 'Fill style',
        options: GitHubButtonStyle.values.asOptions(),
        initial: GitHubButtonStyle.black,
      );

      final size = context.knobs.options<GitHubButtonSize>(
        label: 'Size',
        options: GitHubButtonSize.values.asOptions(),
        initial: GitHubButtonSize.large,
      );

      final shape = context.knobs.options<GitHubButtonShape>(
        label: 'Shape',
        options: GitHubButtonShape.values.asOptions(),
        initial: GitHubButtonShape.pill,
      );

      final text = context.knobs.options<GitHubButtonText>(
        label: 'Text',
        options: GitHubButtonText.values.asOptions(),
        initial: GitHubButtonText.continueWith,
      );

      final logoAlignment = context.knobs.options<GitHubButtonLogoAlignment>(
        label: 'Logo alignment',
        options: GitHubButtonLogoAlignment.values.asOptions(),
        initial: GitHubButtonLogoAlignment.left,
      );

      final type = context.knobs.options<GitHubButtonType>(
        label: 'Type',
        options: GitHubButtonType.values.asOptions(),
        initial: GitHubButtonType.standard,
      );

      return buildIsolatedElementsForStory(context, {
        'Default': [
          GitHubSignInButton(
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
    name: 'GitHub/Button States',
    description: 'GitHub Sign-In button states side-by-side.',
    builder: (context) => buildIsolatedElementsForStory(context, {
      'Idle': [
        const GitHubSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: false,
        ),
      ],
      'Loading': [
        const GitHubSignInButton(
          onPressed: _nullCallback,
          isLoading: true,
          isDisabled: false,
        ),
      ],
      'Disabled': [
        const GitHubSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: true,
        ),
      ],
    }),
  ),
];

void _nullCallback() {}
