import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';

/// Details for a method stream connection.
class MethodStreamConnectionDetails {
  /// The endpoint to connect to.
  final String endpoint;

  /// The method to call.
  final String method;

  /// The arguments to pass to the method.
  final Map<String, dynamic> args;

  /// The outbound streams to send to the server.
  final Map<String, Stream> parameterStreams;

  /// The controller for the output stream.
  final StreamController outputController;

  /// The authentication key provider.
  final ClientAuthKeyProvider? authKeyProvider;

  /// The web auth mode declared on the open-stream command:
  /// [webAuthModeCookie] to permit authenticating the stream from the
  /// handshake auth cookie, null otherwise.
  final String? webAuthMode;

  /// Creates a new [MethodStreamConnectionDetails].
  MethodStreamConnectionDetails({
    required this.endpoint,
    required this.method,
    required this.args,
    required this.parameterStreams,
    required this.outputController,
    required this.authKeyProvider,
    this.webAuthMode,
  });
}
