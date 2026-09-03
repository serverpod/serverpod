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
import 'package:serverpod_test_module_server/src/generated/module_class.dart'
    as _i6f0lekx;
import 'package:serverpod_test_module_server/src/generated/module_streaming_class.dart'
    as _irv1xa50;
import '../endpoints/abstract_endpoint.dart' as _iaxb2v6g;
import '../endpoints/module_endpoint.dart' as _irho5ak1;
import '../endpoints/record_streaming.dart' as _i157ib2o;
import '../endpoints/streaming.dart' as _i8rqmf36;
import '../endpoints/unauthenticated.dart' as _ius7wovq;
import '../module_feature/endpoints/my_feature_endpoint.dart' as _iv1xl3uy;
import '../test_module_module.dart' as _idn2qzyz;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'concreteBase': _iaxb2v6g.ConcreteBaseEndpoint()
        ..initialize(
          server,
          'concreteBase',
          'serverpod_test_module',
        ),
      'module': _irho5ak1.ModuleEndpoint()
        ..initialize(
          server,
          'module',
          'serverpod_test_module',
        ),
      'recordStreaming': _i157ib2o.RecordStreamingEndpoint()
        ..initialize(
          server,
          'recordStreaming',
          'serverpod_test_module',
        ),
      'streaming': _i8rqmf36.StreamingEndpoint()
        ..initialize(
          server,
          'streaming',
          'serverpod_test_module',
        ),
      'unauthenticated': _ius7wovq.UnauthenticatedEndpoint()
        ..initialize(
          server,
          'unauthenticated',
          'serverpod_test_module',
        ),
      'partiallyUnauthenticated': _ius7wovq.PartiallyUnauthenticatedEndpoint()
        ..initialize(
          server,
          'partiallyUnauthenticated',
          'serverpod_test_module',
        ),
      'myModuleFeature': _iv1xl3uy.MyModuleFeatureEndpoint()
        ..initialize(
          server,
          'myModuleFeature',
          'serverpod_test_module',
        ),
    };
    connectors['concreteBase'] = _is.EndpointConnector(
      name: 'concreteBase',
      endpoint: endpoints['concreteBase']!,
      methodConnectors: {
        'virtualMethod': _is.MethodConnector(
          name: 'virtualMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteBase'] as _iaxb2v6g.ConcreteBaseEndpoint)
                      .virtualMethod(session),
        ),
        'concreteMethod': _is.MethodConnector(
          name: 'concreteMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteBase'] as _iaxb2v6g.ConcreteBaseEndpoint)
                      .concreteMethod(session),
        ),
        'abstractBaseMethod': _is.MethodConnector(
          name: 'abstractBaseMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['concreteBase'] as _iaxb2v6g.ConcreteBaseEndpoint)
                      .abstractBaseMethod(session),
        ),
      },
    );
    connectors['module'] = _is.EndpointConnector(
      name: 'module',
      endpoint: endpoints['module']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['module'] as _irho5ak1.ModuleEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
        'modifyModuleObject': _is.MethodConnector(
          name: 'modifyModuleObject',
          params: {
            'object': _is.ParameterDescription(
              name: 'object',
              type: _is.getType<_i6f0lekx.ModuleClass>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['module'] as _irho5ak1.ModuleEndpoint)
                  .modifyModuleObject(
                    session,
                    params['object'],
                  ),
        ),
      },
    );
    connectors['recordStreaming'] = _is.EndpointConnector(
      name: 'recordStreaming',
      endpoint: endpoints['recordStreaming']!,
      methodConnectors: {
        'streamModuleClass': _is.MethodStreamConnector(
          name: 'streamModuleClass',
          params: {},
          streamParams: {
            'values':
                _is.StreamParameterDescription<
                  (int?, _irv1xa50.ModuleStreamingClass?)
                >(
                  name: 'values',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['recordStreaming']
                          as _i157ib2o.RecordStreamingEndpoint)
                      .streamModuleClass(
                        session,
                        streamParams['values']!
                            .cast<(int?, _irv1xa50.ModuleStreamingClass?)>(),
                      ),
        ),
      },
    );
    connectors['streaming'] = _is.EndpointConnector(
      name: 'streaming',
      endpoint: endpoints['streaming']!,
      methodConnectors: {
        'intEchoStream': _is.MethodStreamConnector(
          name: 'intEchoStream',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['streaming'] as _i8rqmf36.StreamingEndpoint)
                  .intEchoStream(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
        'simpleInputReturnStream': _is.MethodStreamConnector(
          name: 'simpleInputReturnStream',
          params: {},
          streamParams: {
            'stream': _is.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            ),
          },
          returnType: _is.MethodStreamReturnType.futureType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['streaming'] as _i8rqmf36.StreamingEndpoint)
                  .simpleInputReturnStream(
                    session,
                    streamParams['stream']!.cast<int>(),
                  ),
        ),
      },
    );
    connectors['unauthenticated'] = _is.EndpointConnector(
      name: 'unauthenticated',
      endpoint: endpoints['unauthenticated']!,
      methodConnectors: {
        'unauthenticatedMethod': _is.MethodConnector(
          name: 'unauthenticatedMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['unauthenticated']
                          as _ius7wovq.UnauthenticatedEndpoint)
                      .unauthenticatedMethod(session),
        ),
        'unauthenticatedStream': _is.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['unauthenticated']
                          as _ius7wovq.UnauthenticatedEndpoint)
                      .unauthenticatedStream(session),
        ),
      },
    );
    connectors['partiallyUnauthenticated'] = _is.EndpointConnector(
      name: 'partiallyUnauthenticated',
      endpoint: endpoints['partiallyUnauthenticated']!,
      methodConnectors: {
        'unauthenticatedMethod': _is.MethodConnector(
          name: 'unauthenticatedMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['partiallyUnauthenticated']
                          as _ius7wovq.PartiallyUnauthenticatedEndpoint)
                      .unauthenticatedMethod(session),
        ),
        'authenticatedMethod': _is.MethodConnector(
          name: 'authenticatedMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['partiallyUnauthenticated']
                          as _ius7wovq.PartiallyUnauthenticatedEndpoint)
                      .authenticatedMethod(session),
        ),
        'unauthenticatedStream': _is.MethodStreamConnector(
          name: 'unauthenticatedStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['partiallyUnauthenticated']
                          as _ius7wovq.PartiallyUnauthenticatedEndpoint)
                      .unauthenticatedStream(session),
        ),
        'authenticatedStream': _is.MethodStreamConnector(
          name: 'authenticatedStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['partiallyUnauthenticated']
                          as _ius7wovq.PartiallyUnauthenticatedEndpoint)
                      .authenticatedStream(session),
        ),
      },
    );
    connectors['myModuleFeature'] = _is.EndpointConnector(
      name: 'myModuleFeature',
      endpoint: endpoints['myModuleFeature']!,
      methodConnectors: {
        'myFeatureMethod': _is.MethodConnector(
          name: 'myFeatureMethod',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['myModuleFeature']
                          as _iv1xl3uy.MyModuleFeatureEndpoint)
                      .myFeatureMethod(session),
        ),
        'myFeatureModel': _is.MethodConnector(
          name: 'myFeatureModel',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['myModuleFeature']
                          as _iv1xl3uy.MyModuleFeatureEndpoint)
                      .myFeatureModel(session),
        ),
      },
    );
  }

  @override
  Future<void> onStartup(_is.Session session) async {
    await _idn2qzyz.TestModuleModule().onStartup(session);
  }
}
