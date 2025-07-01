import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/src/web/components/google_sign_in_redirect_page_component.dart';

/// A route that redirects the user back to the client after signing in with Google.
/// The redirect includes the auth code that will automatically be picked up by the
/// serverpod_auth_google_flutter package.
class RouteGoogleSignIn extends ComponentRoute {
  @override
  Future<AbstractComponent> build(Session session, HttpRequest request) async {
    return GoogleSignInRedirectPageComponent();
  }
}
