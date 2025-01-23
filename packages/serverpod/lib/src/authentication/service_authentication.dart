import 'package:serverpod/serverpod.dart';

/// The [AuthenticationHandler] for the servers service connection.
Future<AuthenticationInfo?> serviceAuthenticationHandler(
    Session session, String key) async {
  try {
    var parts = key.split(':');
    // var name = parts[0];
    var secret = parts[1];

    ServerpodConfig config = session.serviceLocator.locate<ServerpodConfig>()!;
    if (config.serviceSecret == null) {
      return null;
    }

    if (secret == config.serviceSecret) {
      return AuthenticationInfo(0, <Scope>{Scope.none});
    }
  } catch (e) {
    return null;
  }

  return null;
}
