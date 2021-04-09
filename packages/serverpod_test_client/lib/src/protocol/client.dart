/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'dart:io';
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class _EndpointBasicDatabase {
  Client client;
  _EndpointBasicDatabase(this.client);
}

class _EndpointBasicTypes {
  Client client;
  _EndpointBasicTypes(this.client);
}

class _EndpointSimple {
  Client client;
  _EndpointSimple(this.client);
}

class _EndpointAsyncTasks {
  Client client;
  _EndpointAsyncTasks(this.client);
}

class _EndpointTransactionsDatabase {
  Client client;
  _EndpointTransactionsDatabase(this.client);
}

class Client extends ServerpodClient {
  late final _EndpointBasicDatabase basicDatabase;
  late final _EndpointBasicTypes basicTypes;
  late final _EndpointSimple simple;
  late final _EndpointAsyncTasks asyncTasks;
  late final _EndpointTransactionsDatabase transactionsDatabase;

  Client(host, {SecurityContext? context, ServerpodClientErrorCallback? errorHandler, AuthenticationKeyManager? authenticationKeyManager}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler, authenticationKeyManager: authenticationKeyManager) {
    basicDatabase = _EndpointBasicDatabase(this);
    basicTypes = _EndpointBasicTypes(this);
    simple = _EndpointSimple(this);
    asyncTasks = _EndpointAsyncTasks(this);
    transactionsDatabase = _EndpointTransactionsDatabase(this);
  }
}
