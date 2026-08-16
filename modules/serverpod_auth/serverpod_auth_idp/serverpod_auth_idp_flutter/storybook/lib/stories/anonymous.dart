import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import '../utils/client.dart';
import '../utils/notification.dart';
import '../utils/story.dart';

final anonymousStories = [
  Story(
    name: 'Anonymous/Button Styles',
    description: 'Anonymous Sign-In button styles side-by-side.',
    builder: (context) {
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

      return buildIsolatedElementsForStory(context, {
        'Default': [
          AnonymousSignInButton(
            onPressed: _nullCallback,
            isLoading: false,
            isDisabled: false,
            size: size,
            shape: shape,
          ),
        ],
      });
    },
  ),
  Story(
    name: 'Anonymous/Button States',
    description: 'Anonymous Sign-In button states side-by-side.',
    builder: (context) => buildIsolatedElementsForStory(context, {
      'Idle': [
        const AnonymousSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: false,
        ),
      ],
      'Loading': [
        const AnonymousSignInButton(
          onPressed: _nullCallback,
          isLoading: true,
          isDisabled: false,
        ),
      ],
      'Disabled': [
        const AnonymousSignInButton(
          onPressed: _nullCallback,
          isLoading: false,
          isDisabled: true,
        ),
      ],
    }),
  ),
  Story(
    name: 'Anonymous/Working Example',
    description: 'Anonymous Sign-In working example.',
    builder: (context) {
      return wrapWidgetInDefaultColumn(width: 300, [
        AnonymousSignInWidget(
          client: context.read<Client>(),
          onAuthenticated: () {
            context.showSuccessSnackBar('Authenticated with anonymous!');
          },
        ),
      ]);
    },
  ),
];

void _nullCallback() {}
