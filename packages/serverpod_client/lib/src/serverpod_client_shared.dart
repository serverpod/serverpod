// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/client_method_stream_manager.dart';
import 'package:serverpod_client/src/method_stream/method_stream_connection_details.dart';

import 'serverpod_client_shared_private.dart';

import 'serverpod_client_io.dart'
    if (dart.library.js_interop) 'serverpod_client_browser.dart'
    if (dart.library.io) 'serverpod_client_io.dart';

/// A callback with no parameters or return value.
typedef VoidCallback = void Function();

/// Context for a method call.
class MethodCallContext {
  /// Name of the called endpoint.
  final String endpointName;

  /// Name of the called endpoint method.
  final String methodName;

  /// Arguments passed to the method.
  final Map<String, dynamic> arguments;

  /// Creates a new [MethodCallContext].
  const MethodCallContext({
    required this.endpointName,
    required this.methodName,
    required this.arguments,
  });
}

/// Defines the interface of the delegate that performs the actual request to the server
/// and returns the response data.
/// The delegate is used by [ServerpodClientShared] to perform the actual request.
/// It's overridden in different versions depending on if the dart:io library
/// is available.
abstract class ServerpodClientRequestDelegate {
  /// Performs the actual request to the server and returns the response data.
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
  });

  /// Closes the connection to the server.
  /// This delegate should not be used after calling this.
  void close();
}

/// Superclass with shared methods for handling communication with the server.
/// Is typically overridden by generated code to provide implementations of methods for calling the server.
abstract class ServerpodClientShared extends EndpointCaller {
  /// Full url to the Serverpod server. E.g. "https://example.com/"
  final String host;

  late final ServerpodClientRequestDelegate _requestDelegate;

  ClientMethodStreamManager? _clientMethodStreamManager;
  ClientMethodStreamManager get _methodStreamManager {
    var methodStreamManager = _clientMethodStreamManager;
    if (methodStreamManager == null) {
      methodStreamManager = ClientMethodStreamManager(
        connectionTimeout: streamingConnectionTimeout,
        webSocketHost: _webSocketHost.replace(path: '/v1/websocket'),
        serializationManager: serializationManager,
      );
      _clientMethodStreamManager = methodStreamManager;
    }

    return methodStreamManager;
  }

  late bool _disconnectMethodStreamsOnLostInternetConnection;

  /// Host name of the web socket endpoint, without a path.
  /// E.g. "wss://example.com/"
  Uri get _webSocketHost {
    var uri = Uri.parse(host);
    if (uri.scheme == 'http') {
      uri = uri.replace(scheme: 'ws');
    } else if (uri.scheme == 'https') {
      uri = uri.replace(scheme: 'wss');
    }
    return uri;
  }

  /// The [SerializationManager] used to serialize objects sent to the server.
  final SerializationManager serializationManager;

  /// Optional [AuthenticationKeyManager] if the client needs to sign the user in.
  @Deprecated(
    'Use authKeyProvider instead. This will be removed in future releases.',
  )
  AuthenticationKeyManager? get authenticationKeyManager {
    final provider = authKeyProvider;
    if (provider == null) return null;
    if (provider is AuthenticationKeyManager) return provider;
    throw StateError(
      'The authKeyProvider is not an AuthenticationKeyManager. '
      'Use authKeyProvider directly instead of authenticationKeyManager.',
    );
  }

  /// Looks up module callers by their name. Overridden by generated code.
  Map<String, ModuleEndpointCaller> get moduleLookup;

  /// Timeout when opening a web socket connection for a streaming method
  /// call. If the connection has not been established within the timeout
  /// duration the socket will be closed.
  final Duration streamingConnectionTimeout;

  /// Timeout when calling a server endpoint. If no response has been received, defaults to 20 seconds.
  final Duration connectionTimeout;

  /// Callback when any call to the server fails or an exception is
  /// thrown.
  final void Function(
    MethodCallContext callContext,
    Object error,
    StackTrace stackTrace,
  )?
  onFailedCall;

  /// Callback when any call to the server succeeds.
  final void Function(MethodCallContext callContext)? onSucceededCall;

  ConnectivityMonitor? _connectivityMonitor;

  /// Set a connectivity monitor to better manage streaming connections. You
  /// can find the FlutterConnectivityMonitor in the serverpod_flutter package.
  ConnectivityMonitor? get connectivityMonitor => _connectivityMonitor;

  set connectivityMonitor(ConnectivityMonitor? monitor) {
    _connectivityMonitor?.removeListener(_connectivityChanged);
    monitor?.addListener(_connectivityChanged);
    _connectivityMonitor = monitor;
  }

  void _connectivityChanged(bool connected) {
    if (connected) return;

    if (_disconnectMethodStreamsOnLostInternetConnection) {
      closeStreamingMethodConnections();
    }
  }

  /// Provides the authentication key for the client. Required to make
  /// authenticated requests. If not provided, all requests will be
  /// unauthenticated.
  ClientAuthKeyProvider? authKeyProvider;

  /// Creates a new ServerpodClientShared.
  ServerpodClientShared(
    String host,
    this.serializationManager, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    AuthenticationKeyManager? authenticationKeyManager,
    required Duration? streamingConnectionTimeout,
    required Duration? connectionTimeout,
    this.onFailedCall,
    this.onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    http.Client? httpClientOverride,
  }) : host = host.endsWith('/') ? host : '$host/',
       connectionTimeout = connectionTimeout ?? const Duration(seconds: 20),
       streamingConnectionTimeout =
           streamingConnectionTimeout ?? const Duration(seconds: 5) {
    assert(
      this.host.startsWith('http://') || this.host.startsWith('https://'),
      'host must include protocol, eg: https://example.com/',
    );
    _requestDelegate = ServerpodClientRequestDelegateImpl(
      connectionTimeout: this.connectionTimeout,
      serializationManager: serializationManager,
      securityContext: securityContext,
      httpClientOverride: httpClientOverride,
    );
    disconnectStreamsOnLostInternetConnection ??= false;
    _disconnectMethodStreamsOnLostInternetConnection =
        disconnectStreamsOnLostInternetConnection;

    // Use authKeyProvider if provided, otherwise fall back to deprecated
    // authenticationKeyManager for backwards compatibility.
    authKeyProvider ??= authenticationKeyManager;
  }

  /// Closes all open connections to the server.
  void close() {
    _requestDelegate.close();
    closeStreamingMethodConnections();
  }

  /// Closes all open streaming method connections.
  ///
  /// [exception] is an optional exception that will be thrown to all
  /// listeners of open streams.
  ///
  /// If [exception] is not provided, a [WebSocketClosedException] will be
  /// thrown.
  Future<void> closeStreamingMethodConnections({
    Object? exception = const WebSocketClosedException(),
  }) async {
    await _methodStreamManager.closeAllConnections(exception);
  }

  @override
  Future<T> callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args, {
    bool authenticated = true,
  }) async {
    try {
      return await _callServerEndpoint(
        endpoint,
        method,
        args,
        authenticated: authenticated,
      );
    } on ServerpodClientUnauthorized catch (_) {
      final keyProvider = authKeyProvider;

      // A first failure here with 401 can be due to an access token expiration.
      // We will retry only once in such case, and only if the `authKeyProvider`
      // exposes a `refreshAuthKey` method (like JWT).
      if (keyProvider is RefresherClientAuthKeyProvider) {
        final refreshResult = await keyProvider.refreshAuthKey();
        if (refreshResult == RefreshAuthKeyResult.success) {
          return _callServerEndpoint(
            endpoint,
            method,
            args,
            authenticated: authenticated,
          );
        }
      }
      rethrow;
    }
  }

  Future<T> _callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args, {
    bool authenticated = true,
  }) async {
    var callContext = MethodCallContext(
      endpointName: endpoint,
      methodName: method,
      arguments: args,
    );

    try {
      var authenticationValue = authenticated
          ? await authKeyProvider?.authHeaderValue
          : null;
      var body = formatArgs(args);
      var url = method.isEmpty
          ? Uri.parse('$host$endpoint')
          : Uri.parse('$host$endpoint/$method');

      var data = await _requestDelegate.serverRequest(
        url,
        body: body,
        authenticationValue: authenticationValue,
      );

      T result;
      if (T == getType<void>()) {
        result = returnVoid() as T;
      } else {
        result = parseData<T>(data, T, serializationManager);
      }

      onSucceededCall?.call(callContext);
      return result;
    } catch (e, s) {
      onFailedCall?.call(callContext, e, s);
      rethrow;
    }
  }

  @override
  dynamic callStreamingServerEndpoint<T, G>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
    Map<String, Stream> streams, {
    bool authenticated = true,
  }) {
    var connectionDetails = MethodStreamConnectionDetails(
      endpoint: endpoint,
      method: method,
      args: args,
      parameterStreams: streams,
      outputController: StreamController<G>(),
      authKeyProvider: authenticated ? authKeyProvider : null,
    );

    _methodStreamManager.openMethodStream(connectionDetails).catchError((e, _) {
      Object error;
      if (e is OpenMethodStreamException) {
        error = switch (e.responseType) {
          OpenMethodStreamResponseType.endpointNotFound =>
            ServerpodClientNotFound(),
          OpenMethodStreamResponseType.authenticationFailed =>
            ServerpodClientUnauthorized(),
          OpenMethodStreamResponseType.authorizationDeclined =>
            ServerpodClientForbidden(),
          OpenMethodStreamResponseType.invalidArguments =>
            ServerpodClientBadRequest(),
          OpenMethodStreamResponseType.success => ServerpodClientException(
            'Unknown error, data: $e',
            -1,
          ),
        };
      } else {
        error = e;
      }

      if (!connectionDetails.outputController.isClosed) {
        connectionDetails.outputController.addError(error);
      }
      connectionDetails.outputController.close();
    });

    if (T == Stream<G>) {
      return connectionDetails.outputController.stream;
    } else if ((T == Future<G>) && G == getType<void>()) {
      var result = Completer<void>();
      // Listen to stream so that close can be called when method has returned.
      connectionDetails.outputController.stream.listen(
        (e) {},
        onError: ((e, _) => result.completeError(e)),
        onDone: () => result.complete(),
        cancelOnError: true,
      );
      return result.future;
    } else if (T == Future<G>) {
      var result = Completer<G>();
      connectionDetails.outputController.stream.first.then(
        (e) {
          result.complete(e);
        },
        onError: (e, _) {
          result.completeError(e);
        },
      );
      return result.future;
    } else {
      throw UnsupportedError('Unsupported type $T');
    }
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
  Future<T> callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args, {
    bool authenticated = true,
  }) {
    return client.callServerEndpoint<T>(
      endpoint,
      method,
      args,
      authenticated: authenticated,
    );
  }

  @override
  dynamic callStreamingServerEndpoint<T, G>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
    Map<String, Stream> streams, {
    bool authenticated = true,
  }) {
    return client.callStreamingServerEndpoint<T, G>(
      endpoint,
      method,
      args,
      streams,
      authenticated: authenticated,
    );
  }
}

/// Super class for all classes that can call a server endpoint.
abstract class EndpointCaller {
  /// Looks up an [EndpointRef] by its name. This method is typically only
  /// used internally and overridden by generated code.
  Map<String, EndpointRef> get endpointRefLookup;

  /// Calls a server endpoint method by its name, passing arguments in a map.
  /// Typically, this method is called by generated code.
  Future<T> callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args, {
    bool authenticated = true,
  });

  /// Calls a server endpoint method that supports streaming. The [streams]
  /// parameter is a map of stream names to stream objects. The method will
  /// listen to the streams and send the data to the server.
  /// Typically, this method is called by generated code.
  ///
  /// [T] is the type of the return value of the endpoint stream. This is either
  /// a [Stream] or a [Future].
  ///
  /// [G] is the generic of [T], such as `T<G>`.
  ///
  /// If [T] is not a [Stream] or a [Future], the method will throw an exception.
  dynamic callStreamingServerEndpoint<T, G>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
    Map<String, Stream> streams, {
    bool authenticated = true,
  });

  /// Returns an endpoint of type [T]. If more than one endpoint of type [T]
  /// exists, [name] can be used to disambiguate.
  ///
  /// Usage:
  /// ```dart
  /// final connectedIdps = await client.auth.idp.getConnectedIdps();
  ///
  /// /// Look up an Idp by its name, in this case, the string "email"
  /// final userHasEmailAndPassword = connectedIdps.has(EmailIdp.method);
  ///
  /// /// Look up an Idp by its type
  /// final userHasGoogleAccount = connectedIdps.has<EndpointGoogleIdpBase>();
  /// ```
  T getEndpointOfType<T extends EndpointRef>([String? name]) {
    if (name != null) {
      final endpoint = endpointRefLookup[name] as T?;
      if (endpoint == null) {
        throw ServerpodClientEndpointNotFound(T, name: name);
      }
      return endpoint;
    }

    var foundEndpoints = endpointRefLookup.values.whereType<T>();
    switch (foundEndpoints.length) {
      case 0:
        throw ServerpodClientEndpointNotFound(T);
      case 1:
        return foundEndpoints.single;
      default:
        throw ServerpodClientMultipleEndpointsFound(T, foundEndpoints);
    }
  }
}

/// This class connects endpoints on the server with the client, it also
/// hooks up streams with the endpoint. Overridden by generated code.
abstract class EndpointRef {
  /// Holds a reference to the caller class.
  final EndpointCaller caller;

  /// Reference to the client.
  late final ServerpodClientShared client;

  /// Creates a new [EndpointRef].
  EndpointRef(this.caller) {
    if (caller is ServerpodClientShared) {
      client = caller as ServerpodClientShared;
    } else if (caller is ModuleEndpointCaller) {
      client = (caller as ModuleEndpointCaller).client;
    }
  }

  /// The name of the endpoint this reference is connected to.
  String get name;
}

/// Thrown if not able to get an endpoint on the client by type.
sealed class ServerpodClientGetEndpointException implements Exception {
  /// The error message to show to the user.
  final String message;

  /// Creates an Endpoint Missing Exception.
  const ServerpodClientGetEndpointException(this.message);

  @override
  String toString() => message;
}

/// Thrown if the client tries to call an endpoint that was not generated.
/// This will typically happen if getting the endpoint by type while the user
/// has not defined the endpoint in their project.
final class ServerpodClientEndpointNotFound
    extends ServerpodClientGetEndpointException {
  /// Creates an Endpoint Missing Exception.
  const ServerpodClientEndpointNotFound(Type type, {String? name})
    : super(
        'No endpoint of type "$type" '
        '${name != null ? 'with name "$name" ' : ''}found.',
      );
}

/// Thrown if the client tries to call an endpoint by type, but multiple
/// endpoints of that type exists. The user should disambiguate by using the
/// name parameter.
final class ServerpodClientMultipleEndpointsFound
    extends ServerpodClientGetEndpointException {
  /// Creates an Multiple Endpoints Found Exception.
  ServerpodClientMultipleEndpointsFound(
    Type type,
    Iterable<EndpointRef> endpoints,
  ) : super(
        'Found ${endpoints.length} endpoints of type "$type": '
        '${endpoints.map((e) => '"${e.name}"').join(', ')}. '
        'Use the name parameter to disambiguate.',
      );
}
