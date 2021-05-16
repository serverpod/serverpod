import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'auth_key_manager.dart';

typedef void ServerpodClientErrorCallback(var e, StackTrace stackTrace);

abstract class ServerpodClientShared extends EndpointCaller {
  final String host;
  final SerializationManager serializationManager;
  final bool logFailedCalls;
  final AuthenticationKeyManager? authenticationKeyManager;
  ServerpodClientErrorCallback? errorHandler;

  ServerpodClientShared(this.host, this.serializationManager, {
    dynamic context,
    this.errorHandler,
    this.authenticationKeyManager,
    this.logFailedCalls=true,
  }){
    assert(host.endsWith('/'), 'host must end with a slash, eg: https://example.com/');
    assert(host.startsWith('http://') || host.startsWith('https://'), 'host must include protocol, eg: https://example.com/');
  }

  void registerBundleProtocol(SerializationManager protocol) {
    serializationManager.merge(protocol);
  }
}

abstract class BundleEndpointCaller extends EndpointCaller {
  final ServerpodClientShared client;
  BundleEndpointCaller(this.client);

  Future<dynamic> callServerEndpoint(String endpoint, String method, String returnTypeName, Map<String, dynamic> args) {
    return client.callServerEndpoint(endpoint, method, returnTypeName, args);
  }
}

abstract class EndpointCaller {
  Future<dynamic> callServerEndpoint(String endpoint, String method, String returnTypeName, Map<String, dynamic> args);
}