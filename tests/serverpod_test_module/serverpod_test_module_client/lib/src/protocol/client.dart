/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_test_module_client/src/protocol/module_class.dart'
    as _i3;

/// {@category Endpoint}
class EndpointModule extends _i1.EndpointRef {
  EndpointModule(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.module';

  _i2.Future<String> hello(String name) => caller.callServerEndpoint<String>(
        'serverpod_test_module.module',
        'hello',
        {'name': name},
      );

  _i2.Future<_i3.ModuleClass> modifyModuleObject(_i3.ModuleClass object) =>
      caller.callServerEndpoint<_i3.ModuleClass>(
        'serverpod_test_module.module',
        'modifyModuleObject',
        {'object': object},
      );
}

/// {@category Endpoint}
class EndpointStreaming extends _i1.EndpointRef {
  EndpointStreaming(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.streaming';
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    module = EndpointModule(this);
    streaming = EndpointStreaming(this);
  }

  late final EndpointModule module;

  late final EndpointStreaming streaming;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'serverpod_test_module.module': module,
        'serverpod_test_module.streaming': streaming,
      };
}
