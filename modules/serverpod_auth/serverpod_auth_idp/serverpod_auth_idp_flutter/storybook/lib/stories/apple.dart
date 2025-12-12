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

      final size = context.knobs.options<AppleButtonSize>(
        label: 'Size',
        options: AppleButtonSize.values.asOptions(),
        initial: AppleButtonSize.large,
      );

      final shape = context.knobs.options<AppleButtonShape>(
        label: 'Shape',
        options: AppleButtonShape.values.asOptions(),
        initial: AppleButtonShape.pill,
      );

      final type = context.knobs.options<AppleButtonText>(
        label: 'Text',
        options: AppleButtonText.values.asOptions(),
        initial: AppleButtonText.continueWith,
      );

      final logoAlignment = context.knobs.options<AppleButtonLogoAlignment>(
        label: 'Logo alignment',
        options: AppleButtonLogoAlignment.values.asOptions(),
        initial: AppleButtonLogoAlignment.left,
      );

      return buildIsolatedElementsForStory(context, {
        'Default': [
          AppleSignInButton(
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

extension on List<AppleButtonStyle> {
  List<Option<AppleButtonStyle>> asOptions() {
    return map((e) => Option(label: e.name, value: e)).toList();
  }
}
