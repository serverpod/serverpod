import 'package:serverpod/serverpod.dart';

/// Stub endpoint for legacy admin operations. Requires admin scope.
class LegacyAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {Scope.admin};
}
