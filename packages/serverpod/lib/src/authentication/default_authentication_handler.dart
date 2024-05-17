import '../server/session.dart';
import 'authentication_info.dart';

/// The default [AuthenticationHandler], throws an [UnimplementedError].
Future<AuthenticationInfo?> defaultAuthenticationHandler(
  Session session,
  String key,
) async {
  throw UnimplementedError(
    'Authentication not implemented, checkout the serverpod_auth package for a readily available solution.',
  );
}
