/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_test_shared_module_client/serverpod_test_shared_module_client.dart'
    as _iyerxm0e;
import 'package:serverpod_test_sqlite_client/src/protocol/simple_data.dart'
    as _ilnisupq;
import 'protocol.dart' as _il2as5qe;
import 'package:serverpod_test_sqlite_client/migrations/migration_registry.dart';

/// {@category Endpoint}
class EndpointTestTools extends _isc.EndpointRef {
  EndpointTestTools(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'testTools';

  _ida.Future<void> createSimpleData(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleData',
        {'data': data},
      );

  _ida.Future<List<_ilnisupq.SimpleData>> getAllSimpleData() =>
      caller.callServerEndpoint<List<_ilnisupq.SimpleData>>(
        'testTools',
        'getAllSimpleData',
        {},
      );

  _ida.Future<void> createSimpleDatasInsideTransactions(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDatasInsideTransactions',
        {'data': data},
      );

  _ida.Future<void> createSimpleDataAndThrowInsideTransaction(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDataAndThrowInsideTransaction',
        {'data': data},
      );

  _ida.Future<void> createSimpleDatasInParallelTransactionCalls() =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDatasInParallelTransactionCalls',
        {},
      );
}

class Modules {
  Modules(Client client) {
    auth = _iacc.Caller(client);
    auth_idp = _iaic.Caller(client);
    shared_module = _iyerxm0e.Caller(client);
  }

  late final _iacc.Caller auth;

  late final _iaic.Caller auth_idp;

  late final _iyerxm0e.Caller shared_module;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    testTools = EndpointTestTools(this);
    modules = Modules(this);
  }

  late final EndpointTestTools testTools;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'testTools': testTools,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
    'auth_idp': modules.auth_idp,
    'shared_module': modules.shared_module,
  };

  /// Creates a new client-side database session for the given path.
  ///
  /// The [path] is the file path to the SQLite database file. Since SQLite uses
  /// WAL mode, note that `[path]-shm` and `[path]-wal` files might also exist
  /// transiently for the database while the session is open.
  ///
  /// If [runMigrations] is true, pending migrations will be applied when
  /// opening the database. Be careful when setting this to false, as it might
  /// lead to inconsistencies between the models and the database.
  ///
  /// If [isDebugMode] is true, the database integrity will be verified after
  /// the migrations are applied to provide feedback of possible issues. On a
  /// Flutter application, this should be set to [kDebugMode].
  _ida.Future<_isd.ClientDatabaseSession> createSession(
    String path, {
    bool runMigrations = true,
    bool isDebugMode = false,
  }) async {
    return await _isd.ClientDatabaseSession.open(
      path,
      _il2as5qe.Protocol(),
      clientMigrations: MigrationRegistry.migrations,
      runMigrations: runMigrations,
      isDebugMode: isDebugMode,
    );
  }
}
