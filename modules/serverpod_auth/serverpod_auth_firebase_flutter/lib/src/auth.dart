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
  var completer = Completer<UserInfo?>();

  unawaited(
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SignInScreen(
            providers: authProviders,
            actions: [
              AuthCancelledAction((context) {
                completer.complete(null);
                Navigator.of(context).pop();
              }),
              AuthStateChangeAction<SignedIn>((context, state) async {
                try {
                  if (state.user == null) {
                    completer.complete(null);
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
                        completer.complete(null);
                        return;
                      }

                      // Store the user info in the session manager.
                      var sessionManager = await SessionManager.instance;
                      await sessionManager.registerSignedInUser(
                        serverResponse.userInfo!,
                        serverResponse.keyId!,
                        serverResponse.key!,
                      );

                      completer.complete(serverResponse.userInfo);
                      return;
                    } catch (e) {
                      if (kDebugMode) {
                        print('serverpod_auth_firebase: Failed to authenticate '
                            'with Serverpod backend: $e');
                      }
                      completer.complete(null);
                      return;
                    }
                  }
                } finally {
                  Navigator.of(context).pop();
                }
              })
            ],
          );
        },
      ),
    ),
  );

  var result = await completer.future;

  return result;
}
