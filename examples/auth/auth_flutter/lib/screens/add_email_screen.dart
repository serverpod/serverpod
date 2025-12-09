import 'package:auth_client/auth_client.dart';
import 'package:auth_flutter/profile_model.dart';
import 'package:auth_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class AddEmailScreen extends StatelessWidget {
  const AddEmailScreen({
    required this.userProfile,
    super.key,
  });

  final UserProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${userProfile.display}'),
      ),
      drawer: ExampleDrawer(userProfile: userProfile),
      body: Center(
        child: SizedBox(
          width: 400,
          child: EmailSignInWidget(
            client: context.read<Client>(),
            startScreen: EmailFlowScreen.startRegistration,
            onAuthenticated: () => onAuthenticated(context),
            onError: (error) => onError(context, error),
          ),
        ),
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
