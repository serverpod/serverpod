/// This library should not be directly imported in application code.
/// It contains exports required by the code generator to integrate the
/// Serverpod IDP module.
library;

export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    hide Protocol, Endpoints;

export 'src/utils/auth_services_initialize.dart';
