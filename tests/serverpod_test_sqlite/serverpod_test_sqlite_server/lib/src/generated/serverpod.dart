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
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:io' as _i2;
import 'protocol.dart' as _i3;
import 'endpoints.dart' as _i4;
export 'package:serverpod/serverpod.dart' hide Serverpod;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

/// The Serverpod server for this project.
///
/// Pre-configured with the generated Protocol serialization manager and
/// Endpoints, so a server can be created with just the command line
/// arguments:
///
/// ```dart
/// final pod = Serverpod(args);
/// ```
class Serverpod extends _i1.Serverpod {
  Serverpod(
    List<String> args, {
    _i2.Directory? serverDirectory,
    _i1.ServerpodConfig? config,
    _i1.ServerpodConfig Function(_i1.ServerpodConfig)? configOverride,
    _i1.AuthenticationHandler? authenticationHandler,
    _i1.HealthCheckHandler? healthCheckHandler,
    _i1.HealthConfig? healthConfig,
    _i1.Headers? httpResponseHeaders,
    _i1.Headers? httpOptionsResponseHeaders,
    _i1.SecurityContextConfig? securityContextConfig,
    _i1.ExperimentalFeatures? experimentalFeatures,
    _i1.RuntimeParametersListBuilder? runtimeParametersBuilder,
    _i1.DatabaseInterceptor? databaseInterceptor,
  }) : super(
         args,
         _i3.Protocol(),
         _i4.Endpoints(),
         serverDirectory: serverDirectory,
         config: config,
         configOverride: configOverride,
         authenticationHandler: authenticationHandler,
         healthCheckHandler: healthCheckHandler,
         healthConfig: healthConfig,
         httpResponseHeaders: httpResponseHeaders,
         httpOptionsResponseHeaders: httpOptionsResponseHeaders,
         securityContextConfig: securityContextConfig,
         experimentalFeatures: experimentalFeatures,
         runtimeParametersBuilder: runtimeParametersBuilder,
         databaseInterceptor: databaseInterceptor,
       );
}
