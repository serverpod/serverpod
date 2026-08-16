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
          GitHubSignInButton(
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
