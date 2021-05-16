/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'dart:io';
import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class _EndpointBundle {
  EndpointCaller caller;
  _EndpointBundle(this.caller);

  Future<String> hello(String name,) async {
    return await caller.callServerEndpoint('serverpod_test_bundle.bundle', 'hello', 'String', {
      'name':name,
    });
  }

  Future<BundleClass> modifyBundleObject(BundleClass object,) async {
    return await caller.callServerEndpoint('serverpod_test_bundle.bundle', 'modifyBundleObject', 'BundleClass', {
      'object':object,
    });
  }
}

class Caller extends BundleEndpointCaller {
  late final _EndpointBundle bundle;

  Caller(ServerpodClientShared client) : super(client) {
    bundle = _EndpointBundle(this);
  }
}
