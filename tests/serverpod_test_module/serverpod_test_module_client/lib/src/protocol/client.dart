/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_test_module_client/src/protocol/module_class.dart'
    as _i3;
import 'package:serverpod_test_module_client/src/protocol/module_feature/models/my_feature_model.dart'
    as _i4;

/// An abstract endpoint with a virtual method.
///
/// Uses same name and path than the endpoint on `serverpod_test_server` to
/// enure classes are not being matched by name only.
/// {@category Endpoint}
abstract class EndpointAbstractBase extends _i1.EndpointRef {
  EndpointAbstractBase(_i1.EndpointCaller caller) : super(caller);

  /// This is a virtual method that must be overriden.
  _i2.Future<String> virtualMethod();

  /// This body should not be present in the generated abstract class.
  _i2.Future<String> abstractBaseMethod();
}

/// A concrete endpoint that extends the abstract endpoint.
///
/// Uses same name and path than the endpoint on `serverpod_test_server` to
/// enure classes are not being matched by name only.
/// {@category Endpoint}
class EndpointConcreteBase extends EndpointAbstractBase {
  EndpointConcreteBase(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.concreteBase';

  @override
  _i2.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'serverpod_test_module.concreteBase',
    'virtualMethod',
    {},
  );

  /// A concrete method that should be present in the generated class.
  _i2.Future<String> concreteMethod() => caller.callServerEndpoint<String>(
    'serverpod_test_module.concreteBase',
    'concreteMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _i2.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'serverpod_test_module.concreteBase',
    'abstractBaseMethod',
    {},
  );
}

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

  _i2.Future<bool> wasStreamOpenCalled() => caller.callServerEndpoint<bool>(
    'serverpod_test_module.streaming',
    'wasStreamOpenCalled',
    {},
  );

  _i2.Future<bool> wasStreamClosedCalled() => caller.callServerEndpoint<bool>(
    'serverpod_test_module.streaming',
    'wasStreamClosedCalled',
    {},
  );

  _i2.Stream<int> intEchoStream(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'serverpod_test_module.streaming',
        'intEchoStream',
        {},
        {'stream': stream},
      );

  _i2.Future<int> simpleInputReturnStream(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<int>, int>(
        'serverpod_test_module.streaming',
        'simpleInputReturnStream',
        {},
        {'stream': stream},
      );
}

/// An endpoint class with all methods marked as unauthenticated.
/// {@category Endpoint}
class EndpointUnauthenticated extends _i1.EndpointRef {
  EndpointUnauthenticated(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.unauthenticated';

  _i2.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'serverpod_test_module.unauthenticated',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  _i2.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<bool>, bool>(
        'serverpod_test_module.unauthenticated',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );
}

/// An endpoint with only one method marked as unauthenticated.
/// {@category Endpoint}
class EndpointPartiallyUnauthenticated extends _i1.EndpointRef {
  EndpointPartiallyUnauthenticated(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.partiallyUnauthenticated';

  _i2.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'serverpod_test_module.partiallyUnauthenticated',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  _i2.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<bool>, bool>(
        'serverpod_test_module.partiallyUnauthenticated',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );

  _i2.Future<bool> authenticatedMethod() => caller.callServerEndpoint<bool>(
    'serverpod_test_module.partiallyUnauthenticated',
    'authenticatedMethod',
    {},
  );

  _i2.Stream<bool> authenticatedStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<bool>, bool>(
        'serverpod_test_module.partiallyUnauthenticated',
        'authenticatedStream',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointMyModuleFeature extends _i1.EndpointRef {
  EndpointMyModuleFeature(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.myModuleFeature';

  _i2.Future<String> myFeatureMethod() => caller.callServerEndpoint<String>(
    'serverpod_test_module.myModuleFeature',
    'myFeatureMethod',
    {},
  );

  _i2.Future<_i4.MyModuleFeatureModel> myFeatureModel() =>
      caller.callServerEndpoint<_i4.MyModuleFeatureModel>(
        'serverpod_test_module.myModuleFeature',
        'myFeatureModel',
        {},
      );
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    concreteBase = EndpointConcreteBase(this);
    module = EndpointModule(this);
    streaming = EndpointStreaming(this);
    unauthenticated = EndpointUnauthenticated(this);
    partiallyUnauthenticated = EndpointPartiallyUnauthenticated(this);
    myModuleFeature = EndpointMyModuleFeature(this);
  }

  late final EndpointConcreteBase concreteBase;

  late final EndpointModule module;

  late final EndpointStreaming streaming;

  late final EndpointUnauthenticated unauthenticated;

  late final EndpointPartiallyUnauthenticated partiallyUnauthenticated;

  late final EndpointMyModuleFeature myModuleFeature;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'serverpod_test_module.concreteBase': concreteBase,
    'serverpod_test_module.module': module,
    'serverpod_test_module.streaming': streaming,
    'serverpod_test_module.unauthenticated': unauthenticated,
    'serverpod_test_module.partiallyUnauthenticated': partiallyUnauthenticated,
    'serverpod_test_module.myModuleFeature': myModuleFeature,
  };
}
