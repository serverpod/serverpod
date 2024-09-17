import 'package:serverpod/serverpod.dart';

/// Interface for accessing the database.
abstract interface class DatabaseAccessor {
  /// The database to access.
  Database get db;

  /// Optional transaction to use for all database queries.
  Transaction? get transaction;
}
