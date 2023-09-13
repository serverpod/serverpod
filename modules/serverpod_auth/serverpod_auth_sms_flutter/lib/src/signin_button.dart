import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';

import 'res/country_name.dart';
import 'signin_dialog.dart';

class SignInWithSMSButton extends StatefulWidget {
  /// The Auth module's [Caller] instance.
  final Caller caller;

  /// Called if sign in is successful.
  final VoidCallback? onSignedIn;

  /// The style of the button.
  final ButtonStyle? style;

  /// The text of the button.
  final Text? label;

  /// The icon of the button.
  final Icon? icon;

  /// Default country code. Defaults to India.
  final CountryName defaultCountry;

  const SignInWithSMSButton({
    required this.caller,
    this.onSignedIn,
    this.style,
    this.label,
    this.icon,
    this.defaultCountry = CountryName.India,
    Key? key,
  }) : super(key: key);

  @override
  State<SignInWithSMSButton> createState() => _SignInWithSMSButtonState();
}

/// State for Sign in with SMS button.
class _SignInWithSMSButtonState extends State<SignInWithSMSButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: widget.style ??
          ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
      onPressed: () {
        showSignInWithSMSDialog(
          context: context,
          caller: widget.caller,
          defaultCountry: widget.defaultCountry,
          onSignedIn: () {
            if (widget.onSignedIn != null) {
              widget.onSignedIn!();
            }
          },
        );
      },
      label: widget.label ?? const Text('Sign in with SMS'),
      icon: widget.icon ?? const Icon(Icons.phone),
    );
  }
}
