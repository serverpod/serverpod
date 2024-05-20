import 'package:auth_example_flutter/src/serverpod_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

/// A sample page showing information about the signed in user.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          leading: CircularUserImage(
            userInfo: sessionManager.signedInUser,
            size: 42,
          ),
          title: Text(sessionManager.signedInUser!.userName ?? ''),
          subtitle: Text(sessionManager.signedInUser!.email ?? ''),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              sessionManager.signOut();
            },
            child: const Text('Sign out'),
          ),
        ),
      ],
    );
  }
}
