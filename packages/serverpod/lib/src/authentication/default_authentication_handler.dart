import '../server/session.dart';
import 'authentication_info.dart';

/// The default [AuthenticationHandler], throws an [UnimplementedError].
Future<AuthenticationInfo?> defaultAuthenticationHandler(
  Session session,
  String key,
) async {
  throw UnimplementedError(
    'Authentication not implemented. Set the param authenticationHandler in the Server constructor to override the default. Checkout the serverpod_auth package https://docs.serverpod.dev/concepts/authentication/setup.',
  );
}
