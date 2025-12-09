import 'package:auth_client/auth_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.read<Client>();
    return Scaffold(
      body: Column(
        children: <Widget>[
          SignInWidget(
            client: client,
            // NOTE: No need to trigger navigation here because that is handled
            // by the [MainScreen] widget.
            onAuthenticated: () => onAuthenticated(context),
            onError: (error) => onError(context, error),

            // NOTE: To customize widgets, pass the desired widget here.
            // googleSignInWidget: GoogleSignInWidget(
            //   client: client,
            //   onAuthenticated: () => onAuthenticated(context),
            //   onError: (error) => onError(context, error),
            //   scopes: const [],
            // ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: AnonymousSignInWidget(
              client: client,
              onAuthenticated: () => onAuthenticated(context),
              onError: (error) => onError(context, error),
            ),
          ),
        ],
      ),
    );
  }

  void onAuthenticated(BuildContext context) {
    context.showSnackBar(
      message: 'User authenticated.',
      backgroundColor: Colors.green,
    );
  }

  void onError(BuildContext context, Object error) {
    context.showSnackBar(
      message: 'Authentication failed: $error',
      backgroundColor: Colors.red,
    );
  }
}

extension on BuildContext {
  void showSnackBar({
    required String message,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
