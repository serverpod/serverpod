import 'package:serverpod/serverpod.dart';

/// Exposes the opt-in [InsightsDatabaseEndpoint] so the migration tests can
/// reset the live database.
class InsightsDatabaseTestEndpoint extends InsightsDatabaseEndpoint {
  // The migration tests call this endpoint without authentication.
  @override
  bool get requireLogin => false;
}
