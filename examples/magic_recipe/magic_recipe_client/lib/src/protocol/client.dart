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
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i3;
import 'package:magic_recipe_client/src/protocol/greeting.dart' as _i4;
import 'package:magic_recipe_client/src/protocol/recipes/recipe.dart' as _i5;
import 'protocol.dart' as _i6;

/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _i2.Future<List<_i3.UserInfo>> listUsers() =>
      caller.callServerEndpoint<List<_i3.UserInfo>>(
        'admin',
        'listUsers',
        {},
      );

  _i2.Future<void> blockUser(int userId) => caller.callServerEndpoint<void>(
        'admin',
        'blockUser',
        {'userId': userId},
      );

  _i2.Future<void> unblockUser(int userId) => caller.callServerEndpoint<void>(
        'admin',
        'unblockUser',
        {'userId': userId},
      );

  _i2.Future<void> deleteUser(int userId) => caller.callServerEndpoint<void>(
        'admin',
        'deleteUser',
        {'userId': userId},
      );
}

/// This is an example endpoint that returns a greeting message through its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i4.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i4.Greeting>(
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
  _i2.Stream<_i5.Recipe> generateRecipeAsStream(
    String ingredients, [
    String? imagePath,
  ]) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i5.Recipe>, _i5.Recipe>(
        'recipe',
        'generateRecipeAsStream',
        {
          'ingredients': ingredients,
          'imagePath': imagePath,
        },
        {},
      );

  /// Pass in a string containing the ingredients and get a recipe back.
  _i2.Future<_i5.Recipe> generateRecipe(
    String ingredients, [
    String? imagePath,
  ]) =>
      caller.callServerEndpoint<_i5.Recipe>(
        'recipe',
        'generateRecipe',
        {
          'ingredients': ingredients,
          'imagePath': imagePath,
        },
      );

  /// This method returns all the generated recipes from the database.
  _i2.Future<List<_i5.Recipe>> getRecipes() =>
      caller.callServerEndpoint<List<_i5.Recipe>>(
        'recipe',
        'getRecipes',
        {},
      );

  _i2.Future<void> deleteRecipe(int recipeId) =>
      caller.callServerEndpoint<void>(
        'recipe',
        'deleteRecipe',
        {'recipeId': recipeId},
      );

  _i2.Future<(String?, String)> getUploadDescription(String filename) =>
      caller.callServerEndpoint<(String?, String)>(
        'recipe',
        'getUploadDescription',
        {'filename': filename},
      );

  _i2.Future<bool> verifyUpload(String path) => caller.callServerEndpoint<bool>(
        'recipe',
        'verifyUpload',
        {'path': path},
      );

  _i2.Future<String> getPublicUrlForPath(String path) =>
      caller.callServerEndpoint<String>(
        'recipe',
        'getPublicUrlForPath',
        {'path': path},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i3.Caller(client);
  }

  late final _i3.Caller auth;
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
          _i6.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    admin = EndpointAdmin(this);
    greeting = EndpointGreeting(this);
    recipe = EndpointRecipe(this);
    modules = Modules(this);
  }

  late final EndpointAdmin admin;

  late final EndpointGreeting greeting;

  late final EndpointRecipe recipe;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'admin': admin,
        'greeting': greeting,
        'recipe': recipe,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
