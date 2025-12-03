import 'package:serverpod/serverpod.dart';

/// Extensions for [Session] used in the email Idp module.
extension SessionExtension on Session {
  /// Returns the client's IP address, or empty string in case it could not be
  /// determined.
  IPAddress? get remoteIpAddress {
    return request?.connectionInfo.remote.address;
  }
}
