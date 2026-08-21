import 'package:serverpod/serverpod.dart';

/// Exposes the opt-in [InsightsDatabaseEndpoint] so the e2e migration tests
/// can reset and inspect the live database.
class InsightsDatabaseTestEndpoint extends InsightsDatabaseEndpoint {
  // The e2e migration test client is unauthenticated.
  @override
  bool get requireLogin => false;
}
