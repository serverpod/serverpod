import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'auth_key_manager.dart';

/// Method called when errors occur in communication with the server.
typedef ServerpodClientErrorCallback = void Function(dynamic e, StackTrace stackTrace);

/// Superclass with shared methods for handling communication with the server.
/// It's overridden i two different versions depending on if the dart:io library
/// is available.
abstract class ServerpodClientShared extends EndpointCaller {
  /// Full host name of the Serverpod server. E.g. "https://example.com/"
  final String host;

  /// The [SerializationManager] used to serialize objects sent to the server.
  final SerializationManager serializationManager;

  /// If true, the client will log any failed calls to stdout.
  final bool logFailedCalls;

  /// Optional [AuthenticationKeyManager] if the client needs to sign the user
  /// in.
  final AuthenticationKeyManager? authenticationKeyManager;

  /// Optional error handler. If the errorHandler is used, exceptions will not
  /// be thrown when a call to the server fails, instead the errorHandler will
  /// be called.
  ServerpodClientErrorCallback? errorHandler;

  /// Creates a new ServerpodClient.
  ServerpodClientShared(this.host, this.serializationManager, {
    dynamic context,
    this.errorHandler,
    this.authenticationKeyManager,
    this.logFailedCalls=true,
  }){
    assert(host.endsWith('/'), 'host must end with a slash, eg: https://example.com/');
    assert(host.startsWith('http://') || host.startsWith('https://'), 'host must include protocol, eg: https://example.com/');
  }

  /// Registers a module with the client. This is typically done from
  /// generated code.
  void registerModuleProtocol(SerializationManager protocol) {
    serializationManager.merge(protocol);
  }
}

/// This class is used to connect modules with the client. Overridden by
/// generated code.
abstract class ModuleEndpointCaller extends EndpointCaller {
  /// Reference to the client.
  final ServerpodClientShared client;

  /// Creates a new [ModuleEndpointCaller].
  ModuleEndpointCaller(this.client);

  @override
  Future<dynamic> callServerEndpoint(String endpoint, String method, String returnTypeName, Map<String, dynamic> args) {
    return client.callServerEndpoint(endpoint, method, returnTypeName, args);
  }
}

/// Super class for all classes that can call a server endpoint.
abstract class EndpointCaller {
  /// Calls a server endpoint method by its name, passing arguments in a map.
  /// Typically, this method is called by generated code.
  Future<dynamic> callServerEndpoint(String endpoint, String method, String returnTypeName, Map<String, dynamic> args);
}