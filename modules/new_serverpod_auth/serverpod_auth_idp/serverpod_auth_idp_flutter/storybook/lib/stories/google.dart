import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/story.dart';

final googleStories = [
  Story(
    name: 'Google/Button Styles',
    description:
        'Google Sign-In native and web button styles side-by-side. The first '
        'row is the native button, the second row is the web button.',
    builder: (context) {
      final fillStyle = context.knobs.options<GSIButtonTheme>(
        label: 'Fill style',
        options: GSIButtonTheme.values.asOptions(),
        initial: GSIButtonTheme.outline,
      );

      final size = context.knobs.options<GSIButtonSize>(
        label: 'Size',
        options: GSIButtonSize.values.asOptions(),
        initial: GSIButtonSize.large,
      );

      final shape = context.knobs.options<GSIButtonShape>(
        label: 'Shape',
        options: GSIButtonShape.values.asOptions(),
        initial: GSIButtonShape.pill,
      );

      final text = context.knobs.options<GSIButtonText>(
        label: 'Text',
        options: GSIButtonText.values.asOptions(),
        initial: GSIButtonText.continueWith,
      );

      final logoAlignment = context.knobs.options<GSIButtonLogoAlignment>(
        label: 'Logo alignment',
        options: GSIButtonLogoAlignment.values.asOptions(),
        initial: GSIButtonLogoAlignment.left,
      );

      return buildIsolatedElementsForStory(context, {
        'Default': [
          GoogleSignInNativeButton(
            onPressed: _nullCallback,
            isLoading: false,
            isDisabled: false,
            theme: fillStyle,
            size: size,
            text: text,
            shape: shape,
            logoAlignment: logoAlignment,
          ),
          GoogleSignInWebButton(
            theme: fillStyle,
            size: size,
            text: text,
            shape: shape,
            logoAlignment: logoAlignment,
          ),
        ],
        'Elevated': [
          GoogleSignInNativeButton.elevated(
            onPressed: _nullCallback,
            isLoading: false,
            isDisabled: false,
            theme: fillStyle,
            size: size,
            text: text,
            shape: shape,
            logoAlignment: logoAlignment,
          ),
          GoogleSignInWebButton.elevated(
            theme: fillStyle,
            size: size,
            text: text,
            shape: shape,
            logoAlignment: logoAlignment,
          ),
        ],
        'Filled': [
          GoogleSignInNativeButton.filled(
            onPressed: _nullCallback,
            isLoading: false,
            isDisabled: false,
            theme: fillStyle,
            size: size,
            text: text,
            shape: shape,
            logoAlignment: logoAlignment,
          ),
          GoogleSignInWebButton.filled(
            theme: fillStyle,
            size: size,
            text: text,
            shape: shape,
            logoAlignment: logoAlignment,
          ),
        ],
        'Outlined': [
          GoogleSignInNativeButton.outlined(
            onPressed: _nullCallback,
            isLoading: false,
            isDisabled: false,
            size: size,
            text: text,
            shape: shape,
            logoAlignment: logoAlignment,
          ),
          GoogleSignInWebButton.outlined(
            size: size,
            text: text,
            shape: shape,
            logoAlignment: logoAlignment,
          ),
        ],
        'Icon': [
          GoogleSignInNativeButton.icon(
            onPressed: _nullCallback,
            isLoading: false,
            isDisabled: false,
          ),
          GoogleSignInWebButton.icon(),
        ],
      });
    },
  ),
  Story(
    name: 'Google/Native Button States',
    description: 'Google Sign-In native button states side-by-side.',
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
];

void _nullCallback() {}
