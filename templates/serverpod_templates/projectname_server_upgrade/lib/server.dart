// {{#webserver}}
import 'dart:io';
// {{/webserver}}

import 'package:serverpod/serverpod.dart';
// {{#auth}}
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
// {{/auth}}

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
// {{#webapp}}
import 'src/web/routes/app_config_route.dart';
// {{/webapp}}
// {{#website}}
import 'src/web/routes/root.dart';
// {{/website}}

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // {{#auth}}
  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Configure the email identity provider for email/password authentication.
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
      ),
    ],
  );
  // {{/auth}}

  // {{#website}}
  // Setup a default page at the web root.
  // These are used by the default page.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');
  // {{/website}}

  // {{#webserver}}
  // Serve all files in the web/static relative directory under /.
  // These are used by the default web page.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));
  // {{/webserver}}

  // {{#webapp}}
  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under the /app path.
    pod.webServer.addRoute(
      FlutterRoute(
        appDir,
        // If building the Flutter app with WASM, set the below parameter to
        // true and add the --wasm flag to the flutter build command.
        enableWasmHeaders: false,
      ),
      '/app',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    pod.webServer.addRoute(
      StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      ),
      '/app/**',
    );
  }
  // {{/webapp}}

  // Start the server.
  await pod.start();
}

// {{#auth}}
void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the code to the user. For
  // testing, we just log it. `session.alert` shows this as a copyable alert in
  // the `serverpod` CLI's terminal UI and auto-copies the `<...>` segment to
  // the clipboard. Other log destinations treat it as a regular log message.
  session.alert('Registration code for $email: <$verificationCode>');
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the code to the user. For
  // testing, we just log it. `session.alert` shows this as a copyable alert in
  // the `serverpod` CLI's terminal UI and auto-copies the `<...>` segment to
  // the clipboard. Other log destinations treat it as a regular log message.
  session.alert('Password reset code for $email: <$verificationCode>');
}

// {{/auth}}
