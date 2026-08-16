import 'dart:async';

import 'package:serverpod_client/src/auth_key_provider.dart';
import 'package:serverpod_client/src/method_stream/method_stream_connection_details.dart';

class MethodStreamConnectionDetailsBuilder {
  String _endpoint;
  String _method;
  Map<String, dynamic> _args;
  Map<String, Stream> _parameterStreams;
  StreamController _outputController;
  ClientAuthKeyProvider? _authKeyProvider;

  MethodStreamConnectionDetailsBuilder()
    : _endpoint = 'ExampleEndpoint',
      _method = 'exampleMethod',
      _args = {},
      _parameterStreams = {},
      _authKeyProvider = null,
      _outputController = StreamController();

  MethodStreamConnectionDetailsBuilder withEndpoint(String endpoint) {
    _endpoint = endpoint;
    return this;
  }

  MethodStreamConnectionDetailsBuilder withMethod(String method) {
    _method = method;
    return this;
  }

  MethodStreamConnectionDetailsBuilder withArgs(Map<String, dynamic> args) {
    _args = args;
    return this;
  }

  MethodStreamConnectionDetailsBuilder withParameterStreams(
    Map<String, Stream> parameterStreams,
  ) {
    _parameterStreams = parameterStreams;
    return this;
  }

  MethodStreamConnectionDetailsBuilder withOutputController(
    StreamController outputController,
  ) {
    _outputController = outputController;
    return this;
  }

  MethodStreamConnectionDetailsBuilder withAuthKeyProvider(
    ClientAuthKeyProvider? authKeyProvider,
  ) {
    _authKeyProvider = authKeyProvider;
    return this;
  }

  MethodStreamConnectionDetails build() {
    return MethodStreamConnectionDetails(
      endpoint: _endpoint,
      method: _method,
      args: _args,
      parameterStreams: _parameterStreams,
      outputController: _outputController,
      authKeyProvider: _authKeyProvider,
    );
  }
}
