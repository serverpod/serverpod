import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import 'apple/apple_sign_in_widget.dart';
import 'common/widgets/gaps.dart';
import 'common/widgets/column.dart';
import 'common/widgets/divider.dart';
import 'email/email_sign_in_widget.dart';
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
///
/// The widget separates email authentication from other providers with a
/// visual divider showing "Or continue with" text.
///
/// The widget coordinates loading states across all sign-in methods to
/// prevent multiple simultaneous authentication attempts.
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

  /// Whether to disable the email sign-in widget if it is available.
  final bool disableEmailSignInWidget;

  /// Whether to disable the Google sign-in widget if it is available.
  final bool disableGoogleSignInWidget;

  /// Whether to disable the Apple sign-in widget if it is available.
  final bool disableAppleSignInWidget;

  /// Customized widget to use for email sign-in.
  final EmailSignInWidget? emailSignInWidget;

  /// Customized widget to use for Google sign-in.
  final GoogleSignInWidget? googleSignInWidget;

  /// Customized widget to use for Apple sign-in.
  final AppleSignInWidget? appleSignInWidget;

  /// Creates an authentication onboarding widget.
  const SignInWidget({
    required this.client,
    this.onAuthenticated,
    this.onError,
    this.disableEmailSignInWidget = false,
    this.disableGoogleSignInWidget = false,
    this.disableAppleSignInWidget = false,
    this.emailSignInWidget,
    this.googleSignInWidget,
    this.appleSignInWidget,
    super.key,
  });

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  FlutterAuthSessionManager get auth => widget.client.auth;

  bool get hasEmail => auth.idp.hasEmail && !widget.disableEmailSignInWidget;
  bool get hasGoogle => auth.idp.hasGoogle && !widget.disableGoogleSignInWidget;
  bool get hasApple => auth.idp.hasApple && !widget.disableAppleSignInWidget;

  /// Tracks whether any sign-in method is currently in progress.
  ///
  /// This prevents users from initiating multiple simultaneous authentication
  /// attempts, which commonly occurs when switching between development and
  /// production environments or when users click multiple buttons quickly.
  bool _isAnySignInInProgress = false;

  /// Updates the sign-in progress state and disables/enables the interface.
  void _setSignInProgress(bool inProgress) {
    if (mounted) {
      setState(() => _isAnySignInInProgress = inProgress);
    }
  }

  /// Wraps the onAuthenticated callback to reset the loading state.
  void _handleAuthenticated() {
    _setSignInProgress(false);
    widget.onAuthenticated?.call();
  }

  /// Wraps the onError callback to reset the loading state.
  void _handleError(Object error) {
    _setSignInProgress(false);
    widget.onError?.call(error);
  }

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
              onAuthenticated: _handleAuthenticated,
              onError: _handleError,
            ),
    ];

    if (hasApple) {
      final appleSignInWidget =
          widget.appleSignInWidget ??
          AppleSignInWidget(
            client: widget.client,
            onAuthenticated: _handleAuthenticated,
            onError: _handleError,
          );

      // On Apple platforms, display the Apple sign-in widget first.
      if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
        socialProviders.insert(0, appleSignInWidget);
      } else {
        socialProviders.add(appleSignInWidget);
      }
    }

    // Disable all sign-in methods when any authentication is in progress
    return IgnorePointer(
      ignoring: _isAnySignInInProgress,
      child: Opacity(
        opacity: _isAnySignInInProgress ? 0.5 : 1.0,
        child: SignInWidgetsColumn(
          spacing: 12,
          children: [
            if (hasEmail)
              widget.emailSignInWidget ??
                  EmailSignInWidget(
                    client: widget.client,
                    onAuthenticated: _handleAuthenticated,
                    onError: _handleError,
                  ),
            if (socialProviders.isNotEmpty && hasEmail)
              const _SignInSeparator(),
            ...socialProviders,
          ],
        ),
      ),
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
