/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: depend_on_referenced_packages

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
    var retval = await caller
        .callServerEndpoint('serverpod_test_module.module', 'hello', 'String', {
      'name': name,
    });
    return retval;
  }

  Future<ModuleClass> modifyModuleObject(
    ModuleClass object,
  ) async {
    var retval = await caller.callServerEndpoint(
        'serverpod_test_module.module', 'modifyModuleObject', 'ModuleClass', {
      'object': object,
    });
    return retval;
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
