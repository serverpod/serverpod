import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart';
import 'package:serverpod/src/server/features.dart';
import 'package:serverpod/src/server/log_manager/log_manager.dart';
import 'package:serverpod/src/server/log_manager/log_settings.dart';
import 'package:serverpod/src/server/log_manager/log_writers.dart';
import 'package:serverpod/src/server/serverpod.dart';

import '../cache/caches.dart';

/// A listener that will be called when the session is about to close.
typedef WillCloseListener = FutureOr<void> Function(Session session);

/// When a call is made to the [Server] a [Session] object is created. It
/// contains all data associated with the current connection and provides
/// easy access to the database.
abstract class Session implements DatabaseAccessor {
  final LinkedHashSet<WillCloseListener> _willCloseListeners = LinkedHashSet();

  /// Adds a listener that will be called when the session is about to close.
  /// The listener should return a [FutureOr] that completes when the listener
  /// is done.
  ///
  /// The listener will be called in the order they were added.
  void addWillCloseListener(WillCloseListener listener) {
    _willCloseListeners.add(listener);
  }

  /// Removes a listener that will be called when the session is about to close.
  void removeWillCloseListener(WillCloseListener listener) {
    _willCloseListeners.remove(listener);
  }

  /// The id of the session.
  final UuidValue sessionId;

  /// The [Server] that created the session.
  final Server server;

  /// The [Serverpod] this session is running on.
  Serverpod get serverpod => server.serverpod;

  late DateTime _startTime;

  /// The time the session object was created.
  DateTime get startTime => _startTime;

  int? _messageId;

  AuthenticationInfo? _authenticated;

  /// Updates the authentication information for the session.
  /// This is typically done by the [Server] when the user is authenticated.
  /// Using this method modifies the authenticated user for this session.
  void updateAuthenticated(AuthenticationInfo? info) {
    _initialized = true;
    _authenticated = info;
  }

  /// The authentication information for the session.
  /// This will be null if the session is not authenticated.
  Future<AuthenticationInfo?> get authenticated async {
    if (!_initialized) await _initialize();
    return _authenticated;
  }

  /// Returns true if the user is signed in.
  Future<bool> get isUserSignedIn async {
    return (await authenticated) != null;
  }

  String? _authenticationKey;

  /// The authentication key used to authenticate the session.
  String? get authenticationKey => _authenticationKey;

  /// An custom object associated with this [Session]. This is especially
  /// useful for keeping track of the state in a [StreamingEndpoint].
  dynamic userObject;

  /// Access to the database.
  Database? _db;

  /// Optional transaction to use for all database queries.
  /// Only exists to support the serverpod_test package.
  @override
  @visibleForTesting
  Transaction? get transaction => null;

  /// Access to the database.
  @override
  Database get db {
    var database = _db;
    if (database == null) {
      throw Exception('Database is not available in this session.');
    }
    return database;
  }

  /// Provides access to all caches used by the server.
  Caches get caches => server.caches;

  /// Map of passwords loaded from config/passwords.yaml
  Map<String, String> get passwords => server.passwords;

  /// Provides access to the cloud storages used by this [Serverpod].
  late final StorageAccess storage;

  /// Access to the [MessageCentral] for passing real time messages between
  /// web socket streams and other listeners.
  late MessageCentralAccess messages;

  bool _closed = false;

  /// True if logging is enabled for this session. Normally, logging should be
  /// enabled but it will be disabled for internal sessions used by Serverpod.
  final bool enableLogging;

  late final SessionLogManager? _logManager;

  /// Endpoint that triggered this session.
  final String endpoint;

  /// Method that triggered this session, if any.
  final String? method;

  /// Creates a new session. This is typically done internally by the [Server].
  Session({
    UuidValue? sessionId,
    required this.server,
    String? authenticationKey,
    HttpRequest? httpRequest,
    WebSocket? webSocket,
    required this.enableLogging,
    required this.endpoint,
    int? messageId,
    this.method,
  })  : _authenticationKey = authenticationKey,
        _messageId = messageId,
        sessionId = sessionId ?? const Uuid().v4obj() {
    _startTime = DateTime.now();

    storage = StorageAccess._(this);
    messages = MessageCentralAccess._(this);

    if (Features.enableDatabase) {
      _db = server.createDatabase(this);
    }

    if (enableLogging) {
      var logWriter = _createLogWriter(
        this,
        server.serverpod.logSettingsManager,
      );
      _logManager = SessionLogManager(
        logWriter,
        session: this,
        settingsForSession: (Session session) => server
            .serverpod.logSettingsManager
            .getLogSettingsForSession(session),
        disableLoggingSlowSessions: _isLongLived(this),
        serverId: server.serverId,
      );
    } else {
      _logManager = null;
    }
  }

  LogWriter _createLogWriter(Session session, LogSettingsManager settings) {
    var logSettings = settings.getLogSettingsForSession(session);

    var logWriters = <LogWriter>[];

    if (Features.enablePersistentLogging) {
      logWriters.add(
        DatabaseLogWriter(
          logWriterSession: session.serverpod.internalSession,
        ),
      );
    }

    if (Features.enableConsoleLogging) {
      var logFormat = session.serverpod.config.sessionLogs.consoleLogFormat;
      var consoleLogger = switch (logFormat) {
        ConsoleLogFormat.json => JsonStdOutLogWriter(session),
        ConsoleLogFormat.text => TextStdOutLogWriter(session),
      };
      logWriters.add(consoleLogger);
    }

    if ((_isLongLived(session)) &&
        logSettings.logStreamingSessionsContinuously) {
      return MultipleLogWriter(logWriters);
    }

    return MultipleLogWriter(
      logWriters.map((writer) => CachedLogWriter(writer)).toList(),
    );
  }

  bool _initialized = false;

  Future<void> _initialize() async {
    var authKey = _authenticationKey;
    if (authKey != null) {
      _authenticated = await server.authenticationHandler(this, authKey);
    }

    _initialized = true;
  }

  /// Returns the duration this session has been open.
  Duration get duration => DateTime.now().difference(_startTime);

  /// Closes the session. This method should only be called if you have
  /// manually created a the [Session] e.g. by calling [createSession] on
  /// [Serverpod]. Closing the session finalizes and writes logs to the
  /// database. After a session has been closed, you should not call any
  /// more methods on it. Optionally pass in an [error]/exception and
  /// [stackTrace] if the session ended with an error and it should be written
  /// to the logs. Returns the session id, if the session has been logged to the
  /// database.
  Future<int?> close({
    dynamic error,
    StackTrace? stackTrace,
  }) async {
    if (_closed) return null;
    _closed = true;

    var willCloseListeners = _willCloseListeners.toList();
    _willCloseListeners.clear();

    for (var listener in willCloseListeners) {
      await listener(this);
    }

    try {
      if (_logManager == null && error != null) {
        serverpod.logVerbose(error.toString());
        if (stackTrace != null) {
          serverpod.logVerbose(stackTrace.toString());
        }
      }

      server.messageCentral.removeListenersForSession(this);
      return await _logManager?.finalizeLog(
        this,
        exception: error?.toString(),
        stackTrace: stackTrace,
        authenticatedUserId: _authenticated?.userIdentifier,
      );
    } catch (e, stackTrace) {
      stderr.writeln('Failed to close session: $e');
      stderr.writeln('$stackTrace');
    }
    return null;
  }

  /// Logs a message. Default [LogLevel] is [LogLevel.info]. The log is written
  /// to the database when the session is closed.
  void log(
    String message, {
    LogLevel? level,
    dynamic exception,
    StackTrace? stackTrace,
  }) {
    if (_closed) {
      throw StateError(
        'Session is closed, and logging can no longer be performed.',
      );
    }

    _logManager?.logEntry(
      message: message,
      level: level ?? LogLevel.info,
      error: exception?.toString(),
      stackTrace: stackTrace,
    );
  }
}

/// A Session used internally in the [ServerPod]. Typically used to access
/// the database and do logging for events that are not triggered from a call,
/// or a stream.
class InternalSession extends Session {
  /// Creates a new [InternalSession]. Consider using the createSession
  /// method of [ServerPod] to create a new session.
  InternalSession({
    required super.server,
    super.enableLogging = true,
  }) : super(endpoint: 'InternalSession');
}

/// When a call is made to the [Server] a [MethodCallSession] object is created.
/// It contains all data associated with the current connection and provides
/// easy access to the database.
class MethodCallSession extends Session {
  /// The uri that was used to call the server.
  final Uri uri;

  /// The body of the server call.
  final String body;

  /// Query parameters of the server call.
  final Map<String, dynamic> queryParameters;

  final String _method;

  /// The name of the method that is being called.
  @override
  String get method => _method;

  /// The name of the method that is being called.
  @Deprecated('Use method instead')
  String get methodName => _method;

  /// The name of the endpoint that is being called.
  @Deprecated('Use endpoint instead')
  String get endpointName => endpoint;

  /// The [HttpRequest] associated with the call.
  final HttpRequest httpRequest;

  /// Creates a new [Session] for a method call to an endpoint.
  MethodCallSession({
    required super.server,
    required this.uri,
    required this.body,
    required String path,
    required this.httpRequest,
    required super.endpoint,
    required String method,
    required this.queryParameters,
    required super.authenticationKey,
    super.enableLogging = true,
  })  : _method = method,
        super(method: method);
}

/// When a request is made to the web server a [WebCallSession] object is
/// created. It contains all data associated with the current connection and
/// provides easy access to the database.
class WebCallSession extends Session {
  /// Creates a new [Session] for a method call to an endpoint.
  WebCallSession({
    required super.server,
    required super.endpoint,
    required super.authenticationKey,
    super.enableLogging = true,
  });
}

/// When a connection is made to the [Server] to an endpoint method that uses a
/// stream [MethodStreamSession] object is created. It contains all data
/// associated with the current connection and provides easy access to the
/// database.
class MethodStreamSession extends Session {
  /// The connection id that uniquely identifies the stream.
  final UuidValue connectionId;

  final String _method;

  @override
  String get method => _method;

  /// Creates a new [MethodStreamSession].
  MethodStreamSession({
    required super.server,
    required super.enableLogging,
    required super.authenticationKey,
    required super.endpoint,
    required String method,
    required this.connectionId,
  })  : _method = method,
        super(method: method);
}

/// When a web socket connection is opened to the [Server] a [StreamingSession]
/// object is created. It contains all data associated with the current
/// connection and provides easy access to the database.
class StreamingSession extends Session {
  /// The uri that was used to call the server.
  final Uri uri;

  /// Query parameters of the server call.
  late final Map<String, String> queryParameters;

  /// The [HttpRequest] associated with the call.
  final HttpRequest httpRequest;

  /// The underlying web socket that handles communication with the server.
  final WebSocket webSocket;

  /// Set if there is an open session log.
  int? sessionLogId;

  String _endpoint;

  /// The name of the endpoint that is being called.
  set endpoint(String endpoint) => _endpoint = endpoint;

  @override
  String get endpoint => _endpoint;

  /// The name of the endpoint that is being called.
  @Deprecated('Use endpoint instead')
  String get endpointName => _endpoint;

  /// Creates a new [Session] for the web socket stream.
  StreamingSession({
    required super.server,
    required this.uri,
    required this.httpRequest,
    required this.webSocket,
    super.endpoint = 'StreamingSession',
    super.enableLogging = true,
  })  : _endpoint = endpoint,
        super(messageId: 0) {
    // Read query parameters
    var queryParameters = <String, String>{};
    queryParameters.addAll(uri.queryParameters);
    this.queryParameters = queryParameters;

    // Get the authentication key, if any
    _authenticationKey = unwrapAuthHeaderValue(queryParameters['auth']);
  }

  /// Updates the authentication key for the streaming session.
  @internal
  void updateAuthenticationKey(String? authenticationKey) {
    _authenticationKey = authenticationKey;
    _initialized = false;
  }
}

/// Created when a [FutureCall] is being made. It contains all data associated
/// with the current call and provides easy access to the database.
class FutureCallSession extends Session {
  /// Name of the [FutureCall].
  final String futureCallName;

  /// Creates a new [Session] for a [FutureCall].
  FutureCallSession({
    required super.server,
    required this.futureCallName,
    super.enableLogging = true,
  }) : super(endpoint: 'FutureCall', method: futureCallName);
}

/// Collects methods for accessing cloud storage.
class StorageAccess {
  final Session _session;

  StorageAccess._(this._session);

  /// Store a file in the cloud storage. [storageId] is typically 'public' or
  /// 'private'. The public storage can be accessed through a public URL. The
  /// file is stored at the [path] relative to the cloud storage root directory,
  /// if a file already exists it will be replaced.
  Future<void> storeFile({
    required String storageId,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
  }) async {
    var storage = _session.server.serverpod.storage[storageId];
    if (storage == null) {
      throw CloudStorageException('Storage $storageId is not registered');
    }

    await storage.storeFile(session: _session, path: path, byteData: byteData);
  }

  /// Retrieve a file from cloud storage.
  Future<ByteData?> retrieveFile({
    required String storageId,
    required String path,
  }) async {
    var storage = _session.server.serverpod.storage[storageId];
    if (storage == null) {
      throw CloudStorageException('Storage $storageId is not registered');
    }

    return await storage.retrieveFile(session: _session, path: path);
  }

  /// Checks if a file exists in cloud storage.
  Future<bool> fileExists({
    required String storageId,
    required String path,
  }) async {
    var storage = _session.server.serverpod.storage[storageId];
    if (storage == null) {
      throw CloudStorageException('Storage $storageId is not registered');
    }

    return await storage.fileExists(session: _session, path: path);
  }

  /// Deletes a file from cloud storage.
  Future<void> deleteFile({
    required String storageId,
    required String path,
  }) async {
    var storage = _session.server.serverpod.storage[storageId];
    if (storage == null) {
      throw CloudStorageException('Storage $storageId is not registered');
    }

    await storage.deleteFile(session: _session, path: path);
  }

  /// Gets the public URL for a file, if the [storageId] is a public storage.
  Future<Uri?> getPublicUrl({
    required String storageId,
    required String path,
  }) async {
    var storage = _session.server.serverpod.storage[storageId];
    if (storage == null) {
      throw CloudStorageException('Storage $storageId is not registered');
    }

    return await storage.getPublicUrl(session: _session, path: path);
  }

  /// Bulk lookup of a list of public links to files given a list of paths in
  /// the storage. If any given file isn't public or if no such file exists,
  /// null is stored at the corresponding position in the output list. Saves
  /// on server roundtrips if a large number of public URLs must be fetched,
  /// relative to calling [getPublicUrl] via an endpoint for each one.
  Future<List<Uri?>> getPublicUrls({
    required String storageId,
    required List<String> paths,
  }) =>
      Future.wait(
          paths.map((path) => getPublicUrl(storageId: storageId, path: path)));

  /// Creates a new file upload description, that can be passed to the client's
  /// [FileUploader]. After the file has been uploaded, the
  /// [verifyDirectFileUpload] method should be called, or the file may be
  /// deleted.
  Future<String?> createDirectFileUploadDescription({
    required String storageId,
    required String path,
  }) async {
    var storage = _session.server.serverpod.storage[storageId];
    if (storage == null) {
      throw CloudStorageException('Storage $storageId is not registered');
    }

    return await storage.createDirectFileUploadDescription(
        session: _session, path: path);
  }

  /// Call this method after a file has been uploaded. It will return true
  /// if the file was successfully uploaded.
  Future<bool> verifyDirectFileUpload({
    required String storageId,
    required String path,
  }) async {
    var storage = _session.server.serverpod.storage[storageId];
    if (storage == null) {
      throw CloudStorageException('Storage $storageId is not registered');
    }

    return await storage.verifyDirectFileUpload(session: _session, path: path);
  }
}

/// Provides access to the Serverpod's [MessageCentral].
class MessageCentralAccess {
  final Session _session;

  MessageCentralAccess._(this._session);

  /// Adds a listener to a named channel. Whenever a message is posted using
  /// [postMessage], the [listener] will be notified.
  void addListener(
    String channelName,
    MessageCentralListenerCallback listener,
  ) {
    _session.server.messageCentral.addListener(
      _session,
      channelName,
      listener,
    );
  }

  /// Removes a listener from a named channel.
  void removeListener(
      String channelName, MessageCentralListenerCallback listener) {
    _session.server.messageCentral
        .removeListener(_session, channelName, listener);
  }

  /// Posts a [message] to a named channel. If [global] is set to true, the
  /// message will be posted to all servers in the cluster, otherwise it will
  /// only be posted locally on the current server. Returns true if the message
  /// was successfully posted.
  ///
  /// Returns true if the message was successfully posted.
  ///
  /// Throws a [StateError] if Redis is not enabled and [global] is set to true.
  Future<bool> postMessage(
    String channelName,
    SerializableModel message, {
    bool global = false,
  }) =>
      _session.server.messageCentral.postMessage(
        channelName,
        message,
        global: global,
      );

  /// Creates a stream that listens to a specified channel.
  ///
  /// This stream emits messages of type [T] whenever a message is received on
  /// the specified channel.
  ///
  /// If messages on the channel does not match the type [T], the stream will
  /// emit an error.
  Stream<T> createStream<T>(String channelName) =>
      _session.server.messageCentral.createStream<T>(_session, channelName);

  /// Broadcasts revoked authentication events to the Serverpod framework.
  /// This message ensures authenticated connections to the user are closed.
  ///
  /// The [userIdentifier] should be the [AuthenticationInfo.userIdentifier] for the concerned
  /// user.
  ///
  /// The [message] must be of type [RevokedAuthenticationUser],
  /// [RevokedAuthenticationAuthId], or [RevokedAuthenticationScope].
  ///
  /// [RevokedAuthenticationUser] is used to communicate that all the user's
  /// authentication is revoked.
  ///
  /// [RevokedAuthenticationAuthId] is used to communicate that a specific
  /// authentication id has been revoked for a user.
  ///
  /// [RevokedAuthenticationScope] is used to communicate that a specific
  /// scope or scopes have been revoked for the user.
  Future<bool> authenticationRevoked(
    // Uses `Object` to avoid breaking change, but should switch to `String` (mirroring `AuthenticationInfo.userIdentifier`) in the future
    Object userIdentifier,
    SerializableModel message,
  ) async {
    if (message is! RevokedAuthenticationUser &&
        message is! RevokedAuthenticationAuthId &&
        message is! RevokedAuthenticationScope) {
      throw ArgumentError(
        'Message must be of type RevokedAuthenticationUser, '
        'RevokedAuthenticationAuthId, or RevokedAuthenticationScope',
      );
    }

    try {
      return await _session.server.messageCentral.postMessage(
        MessageCentralServerpodChannels.revokedAuthentication(
            userIdentifier.toString()),
        message,
        global: true,
      );
    } on StateError catch (_) {
      // Throws StateError if Redis is not enabled that is ignored.
    }

    // If Redis is not enabled, send the message locally.
    return _session.server.messageCentral.postMessage(
      MessageCentralServerpodChannels.revokedAuthentication(
          userIdentifier.toString()),
      message,
      global: false,
    );
  }
}

/// Internal methods for [Session].
/// This is used to provide access to internal methods that should not be
/// accessed from outside the library.
extension SessionInternalMethods on Session {
  /// Returns the [LogManager] for the session.
  SessionLogManager? get logManager => _logManager;

  /// The authentication information for the session, if set.
  /// This will be null if the session is not authenticated or not initialized.
  AuthenticationInfo? get authInfoOrNull {
    return _authenticated;
  }

  /// Returns the next message id for the session.
  int? get messageId => _messageId;

  /// Returns the next message id for the session.
  int nextMessageId() {
    var id = _messageId ?? 0;
    _messageId = id + 1;

    return id;
  }
}

/// Returns true if the session is expected to be alive for an extended
/// period of time.
bool _isLongLived(Session session) =>
    session is StreamingSession || session is MethodStreamSession;
