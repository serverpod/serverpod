import 'package:serverpod/serverpod.dart';

/// Extensions for [Session] used in the email IDP module.
extension SessionExtension on Session {
  /// Returns the client's IP address, or empty string in case it could not be
  /// determined.
  String get remoteIpAddress {
    final session = this;

    return session is MethodCallSession ? session.request.remoteInfo : '';
  }
}
