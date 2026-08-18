/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:magic_recipe_client/src/protocol/greeting.dart' as _i3;
import 'protocol.dart' as _i4;

/// This is an example endpoint that returns a greeting message through its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i3.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i3.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// This is the endpoint that will be used to generate a recipe using the
/// Google Gemini API. It extends the Endpoint class and implements the
/// generateRecipe method.
/// {@category Endpoint}
class EndpointRecipe extends _i1.EndpointRef {
  EndpointRecipe(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recipe';

  /// Pass in a string containing the ingredients and get a recipe back.
  _i2.Future<String> generateRecipe(String ingredients) =>
      caller.callServerEndpoint<String>(
        'recipe',
        'generateRecipe',
        {'ingredients': ingredients},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i4.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    greeting = EndpointGreeting(this);
    recipe = EndpointRecipe(this);
  }

  late final EndpointGreeting greeting;

  late final EndpointRecipe recipe;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'greeting': greeting,
        'recipe': recipe,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
