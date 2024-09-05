import '../server/session.dart';
import 'authentication_info.dart';

/// The default [AuthenticationHandler], throws an [UnimplementedError].
Future<AuthenticationInfo?> defaultAuthenticationHandler(
  Session session,
  String key,
) async {
  throw UnimplementedError(
    'Authentication not implemented. Set the param authenticationHandler in the Serverpod constructor to override the default. Authentication is easily implemented using the serverpod_auth package/Read more on how to implement authentication in Serverpod here  https://docs.serverpod.dev/concepts/authentication/setup.',
  );
}
