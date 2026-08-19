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
import 'dart:async' as _ida;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_module_client/src/protocol/module_class.dart'
    as _iai9jyhu;
import 'package:serverpod_test_module_client/src/protocol/module_feature/models/my_feature_model.dart'
    as _i0ikjrwq;
import 'package:serverpod_test_module_client/src/protocol/module_streaming_class.dart'
    as _ie8x2k8p;

/// An abstract endpoint with a virtual method.
///
/// Uses same name and path than the endpoint on `serverpod_test_server` to
/// enure classes are not being matched by name only.
/// {@category Endpoint}
abstract class EndpointAbstractBase extends _isc.EndpointRef {
  EndpointAbstractBase(_isc.EndpointCaller caller) : super(caller);

  /// This is a virtual method that must be overriden.
  _ida.Future<String> virtualMethod();

  /// This body should not be present in the generated abstract class.
  _ida.Future<String> abstractBaseMethod();
}

/// A concrete endpoint that extends the abstract endpoint.
///
/// Uses same name and path than the endpoint on `serverpod_test_server` to
/// enure classes are not being matched by name only.
/// {@category Endpoint}
class EndpointConcreteBase extends EndpointAbstractBase {
  EndpointConcreteBase(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.concreteBase';

  @override
  _ida.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'serverpod_test_module.concreteBase',
    'virtualMethod',
    {},
  );

  /// A concrete method that should be present in the generated class.
  _ida.Future<String> concreteMethod() => caller.callServerEndpoint<String>(
    'serverpod_test_module.concreteBase',
    'concreteMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _ida.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'serverpod_test_module.concreteBase',
    'abstractBaseMethod',
    {},
  );
}

/// {@category Endpoint}
class EndpointModule extends _isc.EndpointRef {
  EndpointModule(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.module';

  _ida.Future<String> hello(String name) => caller.callServerEndpoint<String>(
    'serverpod_test_module.module',
    'hello',
    {'name': name},
  );

  _ida.Future<_iai9jyhu.ModuleClass> modifyModuleObject(
    _iai9jyhu.ModuleClass object,
  ) => caller.callServerEndpoint<_iai9jyhu.ModuleClass>(
    'serverpod_test_module.module',
    'modifyModuleObject',
    {'object': object},
  );
}

/// {@category Endpoint}
class EndpointRecordStreaming extends _isc.EndpointRef {
  EndpointRecordStreaming(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.recordStreaming';

  _ida.Stream<(int?, _ie8x2k8p.ModuleStreamingClass?)> streamModuleClass(
    _ida.Stream<(int?, _ie8x2k8p.ModuleStreamingClass?)> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<(int?, _ie8x2k8p.ModuleStreamingClass?)>,
        (int?, _ie8x2k8p.ModuleStreamingClass?)
      >(
        'serverpod_test_module.recordStreaming',
        'streamModuleClass',
        {},
        {'values': values},
      );
}

/// {@category Endpoint}
class EndpointStreaming extends _isc.EndpointRef {
  EndpointStreaming(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.streaming';

  _ida.Stream<int> intEchoStream(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'serverpod_test_module.streaming',
        'intEchoStream',
        {},
        {'stream': stream},
      );

  _ida.Future<int> simpleInputReturnStream(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<int>, int>(
        'serverpod_test_module.streaming',
        'simpleInputReturnStream',
        {},
        {'stream': stream},
      );
}

/// An endpoint class with all methods marked as unauthenticated.
/// {@category Endpoint}
class EndpointUnauthenticated extends _isc.EndpointRef {
  EndpointUnauthenticated(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.unauthenticated';

  _ida.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'serverpod_test_module.unauthenticated',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  _ida.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<bool>, bool>(
        'serverpod_test_module.unauthenticated',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );
}

/// An endpoint with only one method marked as unauthenticated.
/// {@category Endpoint}
class EndpointPartiallyUnauthenticated extends _isc.EndpointRef {
  EndpointPartiallyUnauthenticated(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.partiallyUnauthenticated';

  _ida.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'serverpod_test_module.partiallyUnauthenticated',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  _ida.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<bool>, bool>(
        'serverpod_test_module.partiallyUnauthenticated',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );

  _ida.Future<bool> authenticatedMethod() => caller.callServerEndpoint<bool>(
    'serverpod_test_module.partiallyUnauthenticated',
    'authenticatedMethod',
    {},
  );

  _ida.Stream<bool> authenticatedStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<bool>, bool>(
        'serverpod_test_module.partiallyUnauthenticated',
        'authenticatedStream',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointMyModuleFeature extends _isc.EndpointRef {
  EndpointMyModuleFeature(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_test_module.myModuleFeature';

  _ida.Future<String> myFeatureMethod() => caller.callServerEndpoint<String>(
    'serverpod_test_module.myModuleFeature',
    'myFeatureMethod',
    {},
  );

  _ida.Future<_i0ikjrwq.MyModuleFeatureModel> myFeatureModel() =>
      caller.callServerEndpoint<_i0ikjrwq.MyModuleFeatureModel>(
        'serverpod_test_module.myModuleFeature',
        'myFeatureModel',
        {},
      );
}

class Caller extends _isc.ModuleEndpointCaller {
  Caller(_isc.ServerpodClientShared client) : super(client) {
    concreteBase = EndpointConcreteBase(this);
    module = EndpointModule(this);
    recordStreaming = EndpointRecordStreaming(this);
    streaming = EndpointStreaming(this);
    unauthenticated = EndpointUnauthenticated(this);
    partiallyUnauthenticated = EndpointPartiallyUnauthenticated(this);
    myModuleFeature = EndpointMyModuleFeature(this);
  }

  late final EndpointConcreteBase concreteBase;

  late final EndpointModule module;

  late final EndpointRecordStreaming recordStreaming;

  late final EndpointStreaming streaming;

  late final EndpointUnauthenticated unauthenticated;

  late final EndpointPartiallyUnauthenticated partiallyUnauthenticated;

  late final EndpointMyModuleFeature myModuleFeature;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'serverpod_test_module.concreteBase': concreteBase,
    'serverpod_test_module.module': module,
    'serverpod_test_module.recordStreaming': recordStreaming,
    'serverpod_test_module.streaming': streaming,
    'serverpod_test_module.unauthenticated': unauthenticated,
    'serverpod_test_module.partiallyUnauthenticated': partiallyUnauthenticated,
    'serverpod_test_module.myModuleFeature': myModuleFeature,
  };
}
