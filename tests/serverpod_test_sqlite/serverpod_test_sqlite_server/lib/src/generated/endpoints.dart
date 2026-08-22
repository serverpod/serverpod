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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:serverpod_test_shared_module_server/serverpod_test_shared_module_server.dart'
    as _iyx9etqn;
import 'package:serverpod_test_sqlite_server/src/generated/future_calls.dart'
    as _il0f3y8p;
import '../endpoints/test_tools.dart' as _itdztv0y;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'testTools': _itdztv0y.TestToolsEndpoint()
        ..initialize(
          server,
          'testTools',
          null,
        ),
    };
    connectors['testTools'] = _is.EndpointConnector(
      name: 'testTools',
      endpoint: endpoints['testTools']!,
      methodConnectors: {
        'createSimpleData': _is.MethodConnector(
          name: 'createSimpleData',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .createSimpleData(
                    session,
                    params['data'],
                  ),
        ),
        'getAllSimpleData': _is.MethodConnector(
          name: 'getAllSimpleData',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .getAllSimpleData(session),
        ),
        'createSimpleDatasInsideTransactions': _is.MethodConnector(
          name: 'createSimpleDatasInsideTransactions',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .createSimpleDatasInsideTransactions(
                    session,
                    params['data'],
                  ),
        ),
        'createSimpleDataAndThrowInsideTransaction': _is.MethodConnector(
          name: 'createSimpleDataAndThrowInsideTransaction',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .createSimpleDataAndThrowInsideTransaction(
                    session,
                    params['data'],
                  ),
        ),
        'createSimpleDatasInParallelTransactionCalls': _is.MethodConnector(
          name: 'createSimpleDatasInParallelTransactionCalls',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['testTools'] as _itdztv0y.TestToolsEndpoint)
                  .createSimpleDatasInParallelTransactionCalls(session),
        ),
      },
    );
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_test_shared_module'] = _iyx9etqn.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _il0f3y8p.FutureCalls();
  }
}
