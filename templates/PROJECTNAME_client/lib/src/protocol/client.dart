/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'dart:io';
import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class _EndpointExample {
  EndpointCaller caller;
  _EndpointExample(this.caller);

  Future<String> hello(String name,) async {
    return await caller.callServerEndpoint('example', 'hello', 'String', {
      'name':name,
    });
  }
}

class Client extends ServerpodClient {
  late final _EndpointExample example;

  Client(String host, {SecurityContext? context, ServerpodClientErrorCallback? errorHandler, AuthenticationKeyManager? authenticationKeyManager}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler, authenticationKeyManager: authenticationKeyManager) {
    example = _EndpointExample(this);
  }
}
