import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';

class MigrationAnalyticsSnapshot {
  const MigrationAnalyticsSnapshot({
    required this.serverMigrationCount,
    required this.clientMigrationCount,
    required this.daysSinceFirstMigration,
    this.averageIntervalDays,
  });

  final int serverMigrationCount;
  final int clientMigrationCount;
  final int daysSinceFirstMigration;
  final double? averageIntervalDays;
}

class MigrationMetrics {
  static Future<MigrationAnalyticsSnapshot> load(GeneratorConfig config) async {
    final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
    final clientDir = p.joinAll(config.clientPackagePathParts);

    final serverMigrationCount = await _countMigrationDirectories(
      p.join(serverDir, 'migrations'),
    );
    final clientMigrationCount = await _countMigrationDirectories(
      p.join(clientDir, 'lib', 'migrations'),
    );

    final firstMigrationAt = await _earliestMigrationTimestamp(
      p.join(serverDir, 'migrations'),
    );
    final daysSinceFirst = firstMigrationAt == null
        ? 0
        : DateTime.now().toUtc().difference(firstMigrationAt).inDays;

    double? averageIntervalDays;
    if (serverMigrationCount >= 2 && firstMigrationAt != null) {
      averageIntervalDays = daysSinceFirst / (serverMigrationCount - 1);
    }

    return MigrationAnalyticsSnapshot(
      serverMigrationCount: serverMigrationCount,
      clientMigrationCount: clientMigrationCount,
      daysSinceFirstMigration: daysSinceFirst,
      averageIntervalDays: averageIntervalDays,
    );
  }

  static Future<int> _countMigrationDirectories(String migrationsPath) async {
    final dir = Directory(migrationsPath);
    if (!await dir.exists()) return 0;

    var count = 0;
    await for (final entity in dir.list()) {
      if (entity is Directory) count += 1;
    }
    return count;
  }

  static Future<DateTime?> _earliestMigrationTimestamp(
    String migrationsPath,
  ) async {
    final dir = Directory(migrationsPath);
    if (!await dir.exists()) return null;

    DateTime? earliest;
    await for (final entity in dir.list()) {
      if (entity is! Directory) continue;
      final timestamp = _parseMigrationVersionTimestamp(
        p.basename(entity.path),
      );
      if (timestamp == null) continue;
      if (earliest == null || timestamp.isBefore(earliest)) {
        earliest = timestamp;
      }
    }
    return earliest;
  }

  static DateTime? _parseMigrationVersionTimestamp(String versionName) {
    if (versionName.length < 14) return null;
    final prefix = versionName.substring(0, 14);
    if (!RegExp(r'^\d{14}$').hasMatch(prefix)) return null;

    final year = int.parse(prefix.substring(0, 4));
    final month = int.parse(prefix.substring(4, 6));
    final day = int.parse(prefix.substring(6, 8));
    final hour = int.parse(prefix.substring(8, 10));
    final minute = int.parse(prefix.substring(10, 12));
    final second = int.parse(prefix.substring(12, 14));

    return DateTime.utc(year, month, day, hour, minute, second);
  }
}

class MigrationCreatedFlags {
  const MigrationCreatedFlags({
    required this.serverMigrationCreated,
    required this.clientMigrationCreated,
  });

  final bool serverMigrationCreated;
  final bool clientMigrationCreated;

  /// Maps a [CreateMigrationOutcome] onto which sides were written.
  ///
  /// `createMigrationAction` only returns a bare [CreateMigrationCreated] when
  /// the project has no client-side tables, so an unwrapped outcome is always
  /// the server side; the client side only ever appears inside a
  /// [CreateMigrationServerClientCreated].
  static MigrationCreatedFlags fromOutcome(CreateMigrationOutcome outcome) {
    return switch (outcome) {
      CreateMigrationCreated() => const MigrationCreatedFlags(
        serverMigrationCreated: true,
        clientMigrationCreated: false,
      ),
      CreateMigrationServerClientCreated(
        :final serverResult,
        :final clientResult,
      ) =>
        MigrationCreatedFlags(
          serverMigrationCreated: serverResult is CreateMigrationCreated,
          clientMigrationCreated: clientResult is CreateMigrationCreated,
        ),
      _ => const MigrationCreatedFlags(
        serverMigrationCreated: false,
        clientMigrationCreated: false,
      ),
    };
  }
}
