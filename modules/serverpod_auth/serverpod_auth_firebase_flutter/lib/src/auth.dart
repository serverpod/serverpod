import 'dart:async';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

/// Attempts to Sign in with Firebase. If successful, a [UserInfo] is returned.
/// If the attempt is not a success, null is returned.
Future<UserInfo?> signInWithFirebase({
  required Caller caller,
  required List<AuthProvider> authProviders,
  required BuildContext context,
  bool debug = false,
}) async {
  final navigator = Navigator.of(context);
  return navigator.push<UserInfo?>(
    MaterialPageRoute(
      builder: (context) {
        return SignInScreen(
          providers: authProviders,
          actions: [
            AuthCancelledAction((context) {
              navigator.maybePop();
            }),
            AuthStateChangeAction<SignedIn>((context, state) async {
              if (state.user == null) {
                navigator.maybePop();
                return;
              } else {
                var user = state.user!;

                try {
                  var idToken = await user.getIdToken();
                  var serverResponse =
                      await caller.firebase.authenticate(idToken!);

                  if (!serverResponse.success) {
                    // Failed to sign in.
                    if (kDebugMode) {
                      print(
                        'serverpod_auth_firebase: Failed to authenticate '
                        'with Serverpod backend: '
                        '${serverResponse.failReason ?? 'reason unknown'}'
                        '. Aborting.',
                      );
                    }
                    navigator.maybePop();
                    return;
                  }

                  // Store the user info in the session manager.
                  var sessionManager = await SessionManager.instance;
                  await sessionManager.registerSignedInUser(
                    serverResponse.userInfo!,
                    serverResponse.keyId!,
                    serverResponse.key!,
                  );

                  navigator.pop(serverResponse.userInfo);
                  return;
                } catch (e) {
                  if (kDebugMode) {
                    print('serverpod_auth_firebase: Failed to authenticate '
                        'with Serverpod backend: $e');
                  }
                  navigator.maybePop();
                  return;
                }
              }
            }),
          ],
        );
      },
    ),
  );
}
