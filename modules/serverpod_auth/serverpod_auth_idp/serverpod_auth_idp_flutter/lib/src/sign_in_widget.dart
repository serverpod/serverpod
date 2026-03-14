import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import 'anonymous/anonymous_sign_in_widget.dart';
import 'apple/apple_sign_in_widget.dart';
import 'common/external_idp_registry.dart';
import 'common/widgets/column.dart';
import 'common/widgets/divider.dart';
import 'common/widgets/gaps.dart';
import 'email/email_sign_in_widget.dart';
import 'github/github_sign_in_widget.dart';
import 'google/google_sign_in_widget.dart';
import 'localization/sign_in_localization_provider.dart';
import 'microsoft/microsoft_sign_in_widget.dart';
import 'providers.dart';

/// A widget that provides a complete authentication onboarding experience.
///
/// This widget automatically detects which authentication providers are
/// available on the server by checking for their endpoint implementations,
/// and displays the appropriate sign-in options.
///
/// Currently supports:
/// - Email authentication (via [EndpointEmailIdpBase])
/// - Google Sign-In (via [EndpointGoogleIdpBase])
/// - Apple Sign-In (via [EndpointAppleIdpBase])
/// - GitHub Sign-In (via [EndpointGitHubIdpBase])
/// - Microsoft Sign-In (via [EndpointMicrosoftIdpBase])
/// - External providers registered via [ExternalIdpRegistry]
///
/// The widget separates email authentication from other providers with a
/// visual divider showing "Or continue with" text.
///
/// Example usage:
/// ```dart
/// SignInWidget(
///   client: client,
///   onAuthenticated: () {
///     Navigator.of(context).pushReplacement(
///       MaterialPageRoute(builder: (_) => HomePage()),
///     );
///   },
///   onError: (error) {
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text('Authentication failed: $error')),
///     );
///   },
/// )
/// ```
class SignInWidget extends StatefulWidget {
  /// The Serverpod client instance.
  final ServerpodClientShared client;

  /// Callback when authentication is successful.
  final VoidCallback? onAuthenticated;

  /// Callback when an error occurs during authentication.
  final Function(Object error)? onError;

  /// Whether to disable the anonymous sign-in widget if it is available.
  final bool disableAnonymousSignInWidget;

  /// Whether to disable the email sign-in widget if it is available.
  final bool disableEmailSignInWidget;

  /// Whether to disable the Google sign-in widget if it is available.
  final bool disableGoogleSignInWidget;

  /// Whether to disable the Apple sign-in widget if it is available.
  final bool disableAppleSignInWidget;

  /// Whether to disable the GitHub sign-in widget if it is available.
  final bool disableGitHubSignInWidget;

  /// Whether to disable the Microsoft sign-in widget if it is available.
  final bool disableMicrosoftSignInWidget;

  /// Whether to disable the Facebook sign-in widget if it is available.
  final bool disableFacebookSignInWidget;

  /// Customized widget to use for anonymous sign-in.
  final AnonymousSignInWidget? anonymousSignInWidget;

  /// Customized widget to use for email sign-in.
  final EmailSignInWidget? emailSignInWidget;

  /// Customized widget to use for Google sign-in.
  final GoogleSignInWidget? googleSignInWidget;

  /// Customized widget to use for Apple sign-in.
  final AppleSignInWidget? appleSignInWidget;

  /// Customized widget to use for GitHub sign-in.
  final GitHubSignInWidget? githubSignInWidget;

  /// Customized widget to use for Microsoft sign-in.
  final MicrosoftSignInWidget? microsoftSignInWidget;

  /// Creates an authentication onboarding widget.
  const SignInWidget({
    required this.client,
    this.onAuthenticated,
    this.onError,
    this.disableAnonymousSignInWidget = false,
    this.disableEmailSignInWidget = false,
    this.disableGoogleSignInWidget = false,
    this.disableAppleSignInWidget = false,
    this.disableGitHubSignInWidget = false,
    this.disableMicrosoftSignInWidget = false,
    this.disableFacebookSignInWidget = false,
    this.anonymousSignInWidget,
    this.emailSignInWidget,
    this.googleSignInWidget,
    this.appleSignInWidget,
    this.githubSignInWidget,
    this.microsoftSignInWidget,
    super.key,
  });

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  FlutterAuthSessionManager get auth => widget.client.auth;

  bool get hasAnonymous => auth.idp.hasAnonymous && !widget.disableAnonymousSignInWidget;

  bool get hasEmail => auth.idp.hasEmail && !widget.disableEmailSignInWidget;

  bool get hasGoogle => auth.idp.hasGoogle && !widget.disableGoogleSignInWidget;

  bool get hasApple => auth.idp.hasApple && !widget.disableAppleSignInWidget;

  bool get hasGitHub => auth.idp.hasGitHub && !widget.disableGitHubSignInWidget;

  bool get hasMicrosoft => auth.idp.hasMicrosoft && !widget.disableMicrosoftSignInWidget;

  bool get hasFacebook => auth.idp.hasFacebook && !widget.disableFacebookSignInWidget;

  @override
  Widget build(BuildContext context) {
    final texts = context.basicSignInTexts;

    if (!auth.idp.hasAny) {
      return Center(
        child: Text(
          texts.noAuthenticationProvidersConfigured,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    }

    final socialProviders = <Widget>[
      if (hasGoogle)
        widget.googleSignInWidget ??
            GoogleSignInWidget(
              client: widget.client,
              onAuthenticated: widget.onAuthenticated,
              onError: widget.onError,
            ),
    ];

    if (hasApple) {
      final appleSignInWidget =
          widget.appleSignInWidget ??
          AppleSignInWidget(
            client: widget.client,
            onAuthenticated: widget.onAuthenticated,
            onError: widget.onError,
          );

      // On Apple platforms, display the Apple sign-in widget first.
      if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
        socialProviders.insert(0, appleSignInWidget);
      } else {
        socialProviders.add(appleSignInWidget);
      }
    }

    if (hasFacebook) {
      final builder = ExternalIdpRegistry.instance.getBuilder<EndpointFacebookIdpBase>();
      if (builder != null) {
        socialProviders.add(
          builder(
            context,
            widget.client,
            widget.onAuthenticated,
            widget.onError,
          ),
        );
      }
    }

    if (hasGitHub) {
      socialProviders.add(
        widget.githubSignInWidget ??
            GitHubSignInWidget(
              client: widget.client,
              onAuthenticated: widget.onAuthenticated,
              onError: widget.onError,
            ),
      );
    }

    if (hasMicrosoft) {
      socialProviders.add(
        widget.microsoftSignInWidget ??
            MicrosoftSignInWidget(
              client: widget.client,
              onAuthenticated: widget.onAuthenticated,
              onError: widget.onError,
            ),
      );
    }

    // TODO: Make this adaptative.
    return SignInWidgetsColumn(
      spacing: 12,
      children: [
        if (hasEmail)
          widget.emailSignInWidget ??
              EmailSignInWidget(
                client: widget.client,
                onAuthenticated: widget.onAuthenticated,
                onError: widget.onError,
              ),
        if (socialProviders.isNotEmpty && hasEmail) const _SignInSeparator(),
        ...socialProviders,
        if (hasAnonymous) ...[
          widget.anonymousSignInWidget ??
              AnonymousSignInWidget(
                client: widget.client,
                onAuthenticated: widget.onAuthenticated,
                onError: widget.onError,
              ),
        ],
      ],
    );
  }
}

class _SignInSeparator extends StatelessWidget {
  const _SignInSeparator();

  @override
  Widget build(BuildContext context) {
    final texts = context.basicSignInTexts;

    return Column(
      children: [
        tinyGap,
        Row(
          children: [
            const ExpandedDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                texts.orContinueWith,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const ExpandedDivider(),
          ],
        ),
        // Each social sign-in widget has its top padding, so we only need a
        // tiny gap that will be extended and symmetrical with the top gap.
        tinyGap,
      ],
    );
  }
}
