import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:flutterfire_ui/auth.dart';

/// Attempts to Sign in with Firebase. If successful, a [UserInfo] is returned.
/// If the attempt is not a success, null is returned.
Future<UserInfo?> signInWithFirebase({
  required Caller caller,
  required List<ProviderConfiguration> providerConfigs,
  required BuildContext context,
  bool debug = false,
}) async {
  var completer = Completer<UserInfo?>();

  unawaited(
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SignInScreen(
            providerConfigs: providerConfigs,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) async {
                if (state.user == null) {
                  completer.complete(null);
                } else {
                  var user = state.user!;

                  try {
                    var idToken = await user.getIdToken();
                    var serverResponse =
                        await caller.firebase.authenticate(idToken);

                    if (!serverResponse.success &&
                        serverResponse.userInfo != null) {
                      // Faild to sign in.
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
                    completer.complete(null);
                    return;
                  }
                }
              })
            ],
          );
        },
      ),
    ),
  );

  var result = await completer.future;
  Navigator.of(context).pop();
  return result;
}
