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
import 'package:http/http.dart' as _i85jenna;
import 'package:push_client/src/protocol/greetings/greeting.dart' as _ib5f07di;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_push_core_client/serverpod_push_core_client.dart'
    as _ipcc;
import 'package:serverpod_push_store_client/serverpod_push_store_client.dart'
    as _ipsc;
import 'protocol.dart' as _il2as5qe;

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_ib5f07di.Greeting> hello(String name) =>
      caller.callServerEndpoint<_ib5f07di.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// Interactive matrix harness for push notification testing.
/// {@category Endpoint}
class EndpointPushTest extends _isc.EndpointRef {
  EndpointPushTest(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'pushTest';

  /// Lists every case id and its description.
  _ida.Future<Map<String, String>> listCases() =>
      caller.callServerEndpoint<Map<String, String>>(
        'pushTest',
        'listCases',
        {},
      );

  /// Runs a single matrix case. Optional [installationId] / [credential] are
  /// needed for lifecycle cases that act on the calling device.
  _ida.Future<String> runCase({
    required String caseId,
    String? installationId,
    String? credential,
  }) => caller.callServerEndpoint<String>(
    'pushTest',
    'runCase',
    {
      'caseId': caseId,
      'installationId': installationId,
      'credential': credential,
    },
  );

  /// Queue depth snapshot.
  _ida.Future<String> queueStatus() => caller.callServerEndpoint<String>(
    'pushTest',
    'queueStatus',
    {},
  );

  /// Enqueues a real FCM ping to every live device with [notBefore]=+15s.
  ///
  /// Returns immediately after enqueue so you can background or terminate
  /// the app before delivery.
  _ida.Future<String> scheduleDelayedPing() =>
      caller.callServerEndpoint<String>(
        'pushTest',
        'scheduleDelayedPing',
        {},
      );

  /// Authenticated-only send. Anonymous callers get [NotAuthorizedException].
  /// Used by the security.unauthorized_send matrix case.
  _ida.Future<String> authorizedSend() => caller.callServerEndpoint<String>(
    'pushTest',
    'authorizedSend',
    {},
  );
}

class Modules {
  Modules(Client client) {
    push = _ipcc.Caller(client);
    pushStore = _ipsc.Caller(client);
  }

  late final _ipcc.Caller push;

  late final _ipsc.Caller pushStore;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    greeting = EndpointGreeting(this);
    pushTest = EndpointPushTest(this);
    modules = Modules(this);
  }

  late final EndpointGreeting greeting;

  late final EndpointPushTest pushTest;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'greeting': greeting,
    'pushTest': pushTest,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'push': modules.push,
    'pushStore': modules.pushStore,
  };
}
