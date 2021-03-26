/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'dart:io';
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class _EndpointBasicTypes {
  Client client;
  _EndpointBasicTypes(this.client);

  Future<int?> testInt(int? value,) async {
    return await client.callServerEndpoint('basicTypes', 'testInt', 'int', {
      'value':value,
    });
  }

  Future<double?> testDouble(double? value,) async {
    return await client.callServerEndpoint('basicTypes', 'testDouble', 'double', {
      'value':value,
    });
  }

  Future<String?> testString(String? value,) async {
    return await client.callServerEndpoint('basicTypes', 'testString', 'String', {
      'value':value,
    });
  }
}

class _EndpointSimple {
  Client client;
  _EndpointSimple(this.client);

  Future<void> setGlobalInt(int? value,[int? secondValue,]) async {
    return await client.callServerEndpoint('simple', 'setGlobalInt', 'void', {
      'value':value,
      'secondValue': secondValue,
    });
  }

  Future<void> addToGlobalInt() async {
    return await client.callServerEndpoint('simple', 'addToGlobalInt', 'void', {
    });
  }

  Future<int?> getGlobalInt() async {
    return await client.callServerEndpoint('simple', 'getGlobalInt', 'int', {
    });
  }
}

class Client extends ServerpodClient {
  late final _EndpointBasicTypes basicTypes;
  late final _EndpointSimple simple;

  Client(host, {SecurityContext? context, ServerpodClientErrorCallback? errorHandler, AuthenticationKeyManager? authenticationKeyManager}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler, authenticationKeyManager: authenticationKeyManager) {
    basicTypes = _EndpointBasicTypes(this);
    simple = _EndpointSimple(this);
  }
}
