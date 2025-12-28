/// {@template rebase_migration_impl}
/// Rebase migration implementation
/// {@endtemplate}
class RebaseMigrationImpl {
  /// {@macro rebase_migration_impl}
  const RebaseMigrationImpl();

  /// Default branch
  static const defaultBranch = 'main';

  /// Rebase the migration
  Future<bool> rebaseMigration() async {
    final baseMigrationId = getBaseMigrationId();
    return baseMigrationId.isNotEmpty;
  }

  /// Check the migration
  Future<bool> checkMigration() async {
    final baseMigrationId = getBaseMigrationId();
    return baseMigrationId.isNotEmpty;
  }

  /// Get the base migration ID
  String getBaseMigrationId({
    String? onto,
    String? ontoBranch,
  }) {
    // If onto is specified, return onto
    if (onto != null) return onto;

    // If ontoBranch is specified, return the last migration ID from ontoBranch
    if (ontoBranch != null) return getLastMigrationIdFromBranch(ontoBranch);

    // If no onto or ontoBranch is specified, return the last migration ID from the default branch
    return getLastMigrationIdFromBranch(defaultBranch);
  }

  /// Get the last migration ID from [ontoBranch]
  String getLastMigrationIdFromBranch(String ontoBranch) {
    return 'm1';
  }
}
