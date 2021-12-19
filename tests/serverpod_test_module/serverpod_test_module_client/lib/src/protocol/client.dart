/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data' as typed_data;
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class _EndpointModule extends EndpointRef {
  @override
  String get name => 'serverpod_test_module.module';

  _EndpointModule(EndpointCaller caller) : super(caller);

  Future<String> hello(
    String name,
  ) async {
    return await caller
        .callServerEndpoint('serverpod_test_module.module', 'hello', 'String', {
      'name': name,
    });
  }

  Future<ModuleClass> modifyModuleObject(
    ModuleClass object,
  ) async {
    return await caller.callServerEndpoint(
        'serverpod_test_module.module', 'modifyModuleObject', 'ModuleClass', {
      'object': object,
    });
  }
}

class _EndpointStreaming extends EndpointRef {
  @override
  String get name => 'serverpod_test_module.streaming';

  _EndpointStreaming(EndpointCaller caller) : super(caller);
}

class Caller extends ModuleEndpointCaller {
  late final _EndpointModule module;
  late final _EndpointStreaming streaming;

  Caller(ServerpodClientShared client) : super(client) {
    module = _EndpointModule(this);
    streaming = _EndpointStreaming(this);
  }

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
        'serverpod_test_module.module': module,
        'serverpod_test_module.streaming': streaming,
      };
}
