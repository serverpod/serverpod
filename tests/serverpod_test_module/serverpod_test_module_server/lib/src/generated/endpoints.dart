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
import '../endpoints/module_endpoint.dart' as _i2;
import '../endpoints/streaming.dart' as _i3;
import '../module_feature/endpoints/my_feature_endpoint.dart' as _i4;
import 'package:serverpod_test_module_server/src/generated/module_class.dart'
    as _i5;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'module': _i2.ModuleEndpoint()
        ..initialize(
          server,
          'module',
          'serverpod_test_module',
        ),
      'streaming': _i3.StreamingEndpoint()
        ..initialize(
          server,
          'streaming',
          'serverpod_test_module',
        ),
      'myModuleFeature': _i4.MyModuleFeatureEndpoint()
        ..initialize(
          server,
          'myModuleFeature',
          'serverpod_test_module',
        ),
    };
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
              (endpoints['module'] as _i2.ModuleEndpoint).hello(
            session,
            params['name'],
          ),
        ),
        'modifyModuleObject': _i1.MethodConnector(
          name: 'modifyModuleObject',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i5.ModuleClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['module'] as _i2.ModuleEndpoint).modifyModuleObject(
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
              (endpoints['streaming'] as _i3.StreamingEndpoint)
                  .wasStreamOpenCalled(session),
        ),
        'wasStreamClosedCalled': _i1.MethodConnector(
          name: 'wasStreamClosedCalled',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['streaming'] as _i3.StreamingEndpoint)
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
              (endpoints['streaming'] as _i3.StreamingEndpoint).intEchoStream(
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
              (endpoints['streaming'] as _i3.StreamingEndpoint)
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
              (endpoints['myModuleFeature'] as _i4.MyModuleFeatureEndpoint)
                  .myFeatureMethod(session),
        ),
        'myFeatureModel': _i1.MethodConnector(
          name: 'myFeatureModel',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['myModuleFeature'] as _i4.MyModuleFeatureEndpoint)
                  .myFeatureModel(session),
        ),
      },
    );
  }
}
