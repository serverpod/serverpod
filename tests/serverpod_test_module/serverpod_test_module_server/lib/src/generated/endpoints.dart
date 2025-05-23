/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/ignored_endpoint.dart' as _i2;
import '../endpoints/module_endpoint.dart' as _i3;
import '../endpoints/streaming.dart' as _i4;
import '../module_feature/endpoints/my_feature_endpoint.dart' as _i5;
import 'package:serverpod_test_module_server/src/generated/protocol.dart'
    as _i6;
import 'package:serverpod_test_module_server/src/generated/ignored_endpoint_model.dart'
    as _i7;
import 'package:serverpod_test_module_server/src/generated/module_class.dart'
    as _i8;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'ignoredModule': _i2.IgnoredModuleEndpoint()
        ..initialize(
          server,
          'ignoredModule',
          'serverpod_test_module',
        ),
      'module': _i3.ModuleEndpoint()
        ..initialize(
          server,
          'module',
          'serverpod_test_module',
        ),
      'streaming': _i4.StreamingEndpoint()
        ..initialize(
          server,
          'streaming',
          'serverpod_test_module',
        ),
      'myModuleFeature': _i5.MyModuleFeatureEndpoint()
        ..initialize(
          server,
          'myModuleFeature',
          'serverpod_test_module',
        ),
    };
    connectors['ignoredModule'] = _i1.EndpointConnector(
      name: 'ignoredModule',
      endpoint: endpoints['ignoredModule']!,
      methodConnectors: {
        'echoString': _i1.MethodConnector(
          name: 'echoString',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['ignoredModule'] as _i2.IgnoredModuleEndpoint)
                  .echoString(
            session,
            params['value'],
          ),
        ),
        'echoRecord': _i1.MethodConnector(
          name: 'echoRecord',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<(int, BigInt)>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['ignoredModule'] as _i2.IgnoredModuleEndpoint)
                  .echoRecord(
                    session,
                    params['value'],
                  )
                  .then((record) => _i6.mapRecordToJson(record)),
        ),
        'echoContainer': _i1.MethodConnector(
          name: 'echoContainer',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Set<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['ignoredModule'] as _i2.IgnoredModuleEndpoint)
                  .echoContainer(
            session,
            params['value'],
          ),
        ),
        'echoModel': _i1.MethodConnector(
          name: 'echoModel',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i7.IgnoreEndpointModel>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['ignoredModule'] as _i2.IgnoredModuleEndpoint)
                  .echoModel(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['module'] = _i1.EndpointConnector(
      name: 'module',
      endpoint: endpoints['module']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['module'] as _i3.ModuleEndpoint).hello(
            session,
            params['name'],
          ),
        ),
        'modifyModuleObject': _i1.MethodConnector(
          name: 'modifyModuleObject',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i8.ModuleClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['module'] as _i3.ModuleEndpoint).modifyModuleObject(
            session,
            params['object'],
          ),
        ),
      },
    );
    connectors['streaming'] = _i1.EndpointConnector(
      name: 'streaming',
      endpoint: endpoints['streaming']!,
      methodConnectors: {
        'wasStreamOpenCalled': _i1.MethodConnector(
          name: 'wasStreamOpenCalled',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['streaming'] as _i4.StreamingEndpoint)
                  .wasStreamOpenCalled(session),
        ),
        'wasStreamClosedCalled': _i1.MethodConnector(
          name: 'wasStreamClosedCalled',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['streaming'] as _i4.StreamingEndpoint)
                  .wasStreamClosedCalled(session),
        ),
        'intEchoStream': _i1.MethodStreamConnector(
          name: 'intEchoStream',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['streaming'] as _i4.StreamingEndpoint).intEchoStream(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
        'simpleInputReturnStream': _i1.MethodStreamConnector(
          name: 'simpleInputReturnStream',
          params: {},
          streamParams: {
            'stream': _i1.StreamParameterDescription<int>(
              name: 'stream',
              nullable: false,
            )
          },
          returnType: _i1.MethodStreamReturnType.futureType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['streaming'] as _i4.StreamingEndpoint)
                  .simpleInputReturnStream(
            session,
            streamParams['stream']!.cast<int>(),
          ),
        ),
      },
    );
    connectors['myModuleFeature'] = _i1.EndpointConnector(
      name: 'myModuleFeature',
      endpoint: endpoints['myModuleFeature']!,
      methodConnectors: {
        'myFeatureMethod': _i1.MethodConnector(
          name: 'myFeatureMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['myModuleFeature'] as _i5.MyModuleFeatureEndpoint)
                  .myFeatureMethod(session),
        ),
        'myFeatureModel': _i1.MethodConnector(
          name: 'myFeatureModel',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['myModuleFeature'] as _i5.MyModuleFeatureEndpoint)
                  .myFeatureModel(session),
        ),
      },
    );
  }
}
