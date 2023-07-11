/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;

class _EndpointModule extends _i1.EndpointRef {
  _EndpointModule(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'modulename.module';

  _i2.Future<String> hello(String name) => caller.callServerEndpoint<String>(
        'modulename.module',
        'hello',
        {'name': name},
      );
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    module = _EndpointModule(this);
  }

  late final _EndpointModule module;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup =>
      {'modulename.module': module};
}
