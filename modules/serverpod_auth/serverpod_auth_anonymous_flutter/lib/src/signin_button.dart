import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_anonymous_flutter/src/auth.dart';
import 'package:serverpod_auth_anonymous_flutter/src/signin_labels.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

/// Sign in anonymously button. When pressed, an account is magically created
/// without burdening the user with any tasks. This account can only be accessed
/// from the current device unless the user later upgrades their account to a
/// more formal type of authentication.
class SignInAnonymouslyButton extends StatefulWidget {
  /// The Auth module's caller.
  final Caller caller;

  /// Called if sign in is successful.
  final VoidCallback? onSignedIn;

  /// The style of the button.
  final ButtonStyle? style;

  /// The text of the button.
  final Text? label;

  /// The icon of the button.
  final Icon? icon;

  /// Maximum allowed password length.
  /// Defaults to 128.
  /// If this value is modified, the server must be updated to match.
  final int? maxPasswordLength;

  /// Minimum allowed password length.
  /// Defaults to 8.
  /// If this value is modified, the server must be updated to match.
  final int? minPasswordLength;

  /// Labels for the sign in dialog.
  /// If [null], the default/english labels will be used.
  final SignInAnonymouslyDialogLabels? localization;

  /// Session listener, used to clear stored anonymous credentials on user
  /// signout.
  final SessionManager sessionManager;

  /// Creates a new Sign in with Email button.
  const SignInAnonymouslyButton({
    required this.caller,
    required this.sessionManager,
    this.onSignedIn,
    this.style,
    this.label,
    this.icon,
    this.maxPasswordLength,
    this.minPasswordLength,
    this.localization,
    super.key,
  });

  @override
  SignInAnonymouslyButtonState createState() => SignInAnonymouslyButtonState();
}

/// State for the Sign in anonymously button.
class SignInAnonymouslyButtonState extends State<SignInAnonymouslyButton> {
  late final AnonymousAuthController _anonymousAuth;
  late final SignInAnonymouslyDialogLabels _localization;

  @override
  void initState() {
    super.initState();
    _anonymousAuth = AnonymousAuthController(
      widget.caller,
      widget.sessionManager,
    );
    _localization = widget.localization ?? SignInAnonymouslyDialogLabels.enUS();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: widget.style ??
          ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.black,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
      onPressed: () async {
        if (await _anonymousAuth.anonymousAccountExists()) {
          _anonymousAuth.signIn();
        } else {
          _anonymousAuth.createAccount();
        }
      },
      label: widget.label ?? Text(_localization.buttonTitleSignUp),
      icon: widget.icon ?? const Icon(Icons.person_outline),
    );
  }
}
