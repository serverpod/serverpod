import 'package:auth_example_flutter/src/serverpod_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_apple_flutter/serverpod_auth_apple_flutter.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:serverpod_auth_google_flutter/serverpod_auth_google_flutter.dart';

// See https://docs.serverpod.dev/concepts/authentication for information on how
// to obtain the Client IDs. These can also be specified by adding a plist file
// to your Xcode project.
const _googleClientId = '<Your iOS Client ID from the Google Cloud console>';
const _googleServerClientId = '<Your Web app Client ID from the Cloud console>';

/// Sign in dialog with the option of signing in with email or Google.
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SignInWithEmailButton(
                caller: client.modules.auth,
              ),
              SignInWithGoogleButton(
                caller: client.modules.auth,
                clientId: _googleClientId,
                serverClientId: _googleServerClientId,
                redirectUri: Uri.parse('http://localhost:8082/googlesignin'),
              ),
              SignInWithAppleButton(
                caller: client.modules.auth,
              )
            ],
          ),
        ),
      ),
    );
  }
}
