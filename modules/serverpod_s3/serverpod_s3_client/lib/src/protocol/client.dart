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
  String get name => 'serverpod_s3.module';

  _EndpointModule(EndpointCaller caller) : super(caller);

  Future<String> hello(String name,) async {
    return await caller.callServerEndpoint('serverpod_s3.module', 'hello', 'String', {
      'name':name,
    });
  }
}

class Caller extends ModuleEndpointCaller {
  late final _EndpointModule module;

  Caller(ServerpodClientShared client) : super(client) {
    module = _EndpointModule(this);
  }

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
    'serverpod_s3.module' : module,
  };
}
