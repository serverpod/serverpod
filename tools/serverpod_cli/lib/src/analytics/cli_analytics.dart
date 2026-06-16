import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';

import 'migration_metrics.dart';
import 'payload_builder.dart';
import 'project_metadata.dart';
import 'project_metadata_store.dart';
import 'protocol_feature_analyzer.dart';

/// Rich lifecycle analytics sent to PostHog only (`cli.*` events).
class CliAnalytics {
  CliAnalytics({required Analytics analytics}) : _analytics = analytics;

  final Analytics _analytics;

  Future<void> capture({
    required String event,
    required String serverDir,
    required Map<String, Object?> properties,
    required bool enabled,
  }) async {
    if (!enabled) return;

    try {
      final metadata = await ProjectMetadataStore.loadOrCreate(serverDir);
      final payload = AnalyticsPayloadBuilder.build(
        event: event,
        properties: properties,
        projectId: metadata.projectId,
      );
      _analytics.track(event: event, properties: payload);
    } catch (_) {
      // Analytics must never disrupt CLI execution.
    }
  }

  Future<void> recordCommandInvocation({
    required String serverDir,
    required String commandName,
    required bool enabled,
  }) async {
    if (!enabled) return;
    if (!AnalyticsPayloadBuilder.trackedCommands.contains(commandName)) return;

    try {
      await ProjectMetadataStore.incrementCommandInvocation(
        serverDir,
        commandName,
      );
    } catch (_) {
      // Ignore metadata write failures.
    }
  }

  Future<void> captureProjectCreated({
    required String serverDir,
    required String method,
    required ServerpodTemplateType template,
    required TemplateContext context,
    required bool force,
    required bool enabled,
  }) async {
    if (!enabled) return;

    try {
      await ProjectMetadataStore.initializeNewProject(
        serverDir,
        projectCreatedAt: DateTime.now().toUtc(),
      );
    } catch (_) {
      // Continue even if metadata initialization fails.
    }

    await capture(
      event: 'cli.project_created',
      serverDir: serverDir,
      enabled: enabled,
      properties: {
        'method': method,
        'template': template.name,
        'with_flutter': template.isServer,
        'with_docker': context.docker,
        'with_auth': context.auth && context.postgres,
        'with_database': context.database,
        'force': force,
      },
    );
  }

  Future<void> captureGenerate({
    required String serverDir,
    required GeneratorConfig config,
    required ProtocolAnalyticsSnapshot snapshot,
    required bool success,
    required bool isWatchMode,
    required bool enabled,
    int? oneshotDurationMs,
    int? incrementalRunCount,
    int? incrementalAvgDurationMs,
  }) async {
    if (!enabled) return;

    ProjectMetadata metadata;
    try {
      metadata = await ProjectMetadataStore.incrementGenerateCallCount(
        serverDir,
      );
    } catch (_) {
      return;
    }

    final properties = <String, Object?>{
      'features': snapshot.features,
      'serverpod_modules': snapshot.serverpodModules,
      'counts': snapshot.counts,
      'num_generate_calls': metadata.generateCallCount,
      'project_age_days': ProjectMetadataStore.projectAgeDays(metadata),
      'is_watch_mode': isWatchMode,
      'generation_succeeded': success,
      'oneshot_duration_ms': oneshotDurationMs,
      'incremental_avg_duration_ms': incrementalAvgDurationMs,
      'incremental_run_count': incrementalRunCount,
    };

    await capture(
      event: 'cli.generate',
      serverDir: serverDir,
      enabled: enabled,
      properties: properties,
    );
  }

  Future<void> captureMigrationCreated({
    required GeneratorConfig config,
    required MigrationCreatedFlags flags,
    required bool isRepairMigration,
    required bool enabled,
  }) async {
    if (!enabled) return;
    if (!flags.serverMigrationCreated && !flags.clientMigrationCreated) return;

    try {
      final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
      final metrics = await MigrationMetrics.load(config);

      await capture(
        event: 'cli.migration_created',
        serverDir: serverDir,
        enabled: enabled,
        properties: {
          'server_migration_created': flags.serverMigrationCreated,
          'client_migration_created': flags.clientMigrationCreated,
          'server_migration_count': metrics.serverMigrationCount,
          'client_migration_count': metrics.clientMigrationCount,
          'days_since_first_migration': metrics.daysSinceFirstMigration,
          'average_interval_days': metrics.averageIntervalDays,
          'is_repair_migration': isRepairMigration,
        },
      );
    } catch (_) {
      // Analytics must never disrupt CLI execution.
    }
  }

  Future<void> captureSessionStart({
    required GeneratorConfig config,
    required bool watchMode,
    required bool tuiEnabled,
    required bool flutterEnabled,
    required String flutterDevice,
    required bool dockerFlag,
    required bool dockerComposePresent,
    required bool enabled,
  }) async {
    if (!enabled) return;

    try {
      final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
      final metadata = await ProjectMetadataStore.loadOrCreate(serverDir);
      final category = categorizeFlutterDevice(flutterDevice);

      await capture(
        event: 'cli.session_start',
        serverDir: serverDir,
        enabled: enabled,
        properties: {
          'watch_mode': watchMode,
          'tui_enabled': tuiEnabled,
          'flutter_enabled': flutterEnabled,
          'flutter_device_category': ?category,
          'docker_flag': dockerFlag,
          'docker_compose_present': dockerComposePresent,
          'num_tool_calls': metadata.commandInvocations.values.fold<int>(
            0,
            (sum, count) => sum + count,
          ),
          'command_invocations': Map<String, int>.from(
            metadata.commandInvocations,
          ),
        },
      );
    } catch (_) {
      // Analytics must never disrupt CLI execution.
    }
  }
}

String? categorizeFlutterDevice(String device) {
  const allowed = AnalyticsPayloadBuilder.flutterDeviceCategories;
  if (allowed.contains(device)) return device;
  if (device.contains('headless')) return 'headless';
  if (RegExp(r'ios|iphone|android').hasMatch(device)) return 'mobile';
  if (RegExp(r'macos|windows|linux').hasMatch(device)) return 'desktop';
  return null;
}

CliAnalytics? _cliAnalytics;

CliAnalytics get cliAnalytics {
  final analytics = _cliAnalytics;
  if (analytics == null) {
    throw StateError('CliAnalytics has not been initialized.');
  }
  return analytics;
}

CliAnalytics? get cliAnalyticsOrNull => _cliAnalytics;

void initializeCliAnalytics(CliAnalytics analytics) {
  _cliAnalytics = analytics;
}

Future<Set<String>> readServerPubspecDependencies(
  GeneratorConfig config,
) async {
  final pubspecFile = File(
    p.joinAll([...config.serverPackageDirectoryPathParts, 'pubspec.yaml']),
  );
  if (!await pubspecFile.exists()) return {};

  final lines = await pubspecFile.readAsLines();
  final dependencies = <String>{};
  var inDependencies = false;
  for (final line in lines) {
    if (line.trim() == 'dependencies:') {
      inDependencies = true;
      continue;
    }
    if (!inDependencies) continue;
    if (line.isNotEmpty && !line.startsWith(' ')) break;
    final match = RegExp(r'^\s{2}([\w_]+):').firstMatch(line);
    if (match != null) {
      dependencies.add(match.group(1)!);
    }
  }
  return dependencies;
}
