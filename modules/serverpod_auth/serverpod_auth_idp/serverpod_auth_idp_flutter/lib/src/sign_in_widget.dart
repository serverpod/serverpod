import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import 'anonymous/anonymous_sign_in_widget.dart';
import 'apple/apple_sign_in_widget.dart';
import 'common/widgets/column.dart';
import 'common/widgets/divider.dart';
import 'common/widgets/gaps.dart';
import 'email/email_sign_in_widget.dart';
import 'github/github_sign_in_widget.dart';
import 'google/google_sign_in_widget.dart';
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
    this.anonymousSignInWidget,
    this.emailSignInWidget,
    this.googleSignInWidget,
    this.appleSignInWidget,
    this.githubSignInWidget,
    super.key,
  });

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  FlutterAuthSessionManager get auth => widget.client.auth;

  bool get hasAnonymous =>
      auth.idp.hasAnonymous && !widget.disableAnonymousSignInWidget;
  bool get hasEmail => auth.idp.hasEmail && !widget.disableEmailSignInWidget;
  bool get hasGoogle => auth.idp.hasGoogle && !widget.disableGoogleSignInWidget;
  bool get hasApple => auth.idp.hasApple && !widget.disableAppleSignInWidget;
  bool get hasGitHub => auth.idp.hasGitHub && !widget.disableGitHubSignInWidget;

  @override
  Widget build(BuildContext context) {
    if (!auth.idp.hasAny) {
      return Center(
        child: Text(
          'No authentication providers configured',
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

      if (hasApple)
        widget.appleSignInWidget ??
            AppleSignInWidget(
              client: widget.client,
              onAuthenticated: widget.onAuthenticated,
              onError: widget.onError,
            ),

      if (hasGitHub)
        widget.githubSignInWidget ??
            GitHubSignInWidget(
              client: widget.client,
              onAuthenticated: widget.onAuthenticated,
              onError: widget.onError,
            ),
    ];

    // On Apple platforms, display the Apple sign-in widget first.
    if (hasApple && !kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      final appleWidget = socialProviders.removeAt(1);
      socialProviders.insert(0, appleWidget);
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
    return Column(
      children: [
        tinyGap,
        Row(
          children: [
            const ExpandedDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or continue with',
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
