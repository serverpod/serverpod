import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';

import 'migration_metrics.dart';
import 'payload_builder.dart';
import 'project_identity.dart';
import 'project_metadata.dart';
import 'project_metadata_store.dart';
import 'protocol_feature_analyzer.dart';
import 'session_metrics.dart';

/// Rich lifecycle analytics sent to PostHog only (`cli.*` events).
///
/// Call sites never pass an enabled flag: the singleton starts disabled and is
/// switched on once, from [ServerpodCommandRunner.runCommand], after
/// `BetterCommandRunner` has resolved `--no-analytics`. Every capture method is
/// a no-op while disabled, so commands can call them unconditionally.
class CliAnalytics {
  CliAnalytics({required Analytics analytics}) : _analytics = analytics;

  /// A permanently disabled instance, used until [initializeCliAnalytics]
  /// installs the real one. Keeps `cliAnalytics` safe to call from code paths
  /// that run outside the CLI entry point (tests, MCP tools, embedders).
  CliAnalytics.disabled() : _analytics = _NoopAnalytics();

  final Analytics _analytics;

  /// Whether rich `cli.*` events are being sent. Set once by
  /// [ServerpodCommandRunner.runCommand] from the resolved `--no-analytics`
  /// state.
  bool enabled = false;

  Future<void> capture({
    required String event,
    required String serverDir,
    required Map<String, Object?> properties,
  }) async {
    if (!enabled) return;

    try {
      final metadata = await ProjectMetadataStore.loadOrCreate(serverDir);
      // Durable id from the git remote and server path; falls back to the
      // per-server checkout id for projects without a remote.
      final projectId =
          ProjectIdentity.durableProjectId(serverDir) ?? metadata.checkoutId;
      final payload = AnalyticsPayloadBuilder.build(
        event: event,
        properties: properties,
        projectId: projectId,
        checkoutId: metadata.checkoutId,
      );
      _analytics.track(event: event, properties: payload);
    } catch (_) {
      // Analytics must never disrupt CLI execution.
    }
  }

  /// Increments the per-command counter reported by `cli.session_start`.
  ///
  /// [commandName] must be a subcommand the CLI registered; callers pass it
  /// straight from the command runner so the counted set follows the real
  /// command list instead of a copy that drifts.
  Future<void> recordCommandInvocation({
    required String serverDir,
    required String commandName,
  }) async {
    if (!enabled) return;
    if (!AnalyticsPayloadBuilder.commandNamePattern.hasMatch(commandName)) {
      return;
    }

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
      properties: {
        'method': method,
        ..._templateProperties(template, context),
        'force': force,
      },
    );
  }

  /// Records `serverpod create .` run against an existing project, which
  /// upgrades it in place instead of scaffolding a new one.
  ///
  /// A separate event rather than a `method` on `cli.project_created`: an
  /// upgrade must not stamp `project_created_at`, which would reset the
  /// project's age on every upgrade.
  Future<void> captureProjectUpgraded({
    required String serverDir,
    required ServerpodTemplateType template,
    required TemplateContext context,
    required bool createdDefaultMigration,
  }) async {
    if (!enabled) return;

    ProjectMetadata? metadata;
    try {
      metadata = await ProjectMetadataStore.loadOrCreate(serverDir);
    } catch (_) {
      // Fall through; project age is simply unavailable.
    }

    await capture(
      event: 'cli.project_upgraded',
      serverDir: serverDir,
      properties: {
        ..._templateProperties(template, context),
        'created_default_migration': createdDefaultMigration,
        'project_age_days': metadata == null
            ? null
            : ProjectMetadataStore.projectAgeDays(metadata),
      },
    );
  }

  Map<String, Object?> _templateProperties(
    ServerpodTemplateType template,
    TemplateContext context,
  ) {
    return {
      'template': template.name,
      'with_flutter': context.flutterApp,
      'with_docker': context.docker,
      'with_auth': context.auth && context.postgres,
      'with_database': context.database,
      'database_dialect': _createDatabaseDialect(context),
      'with_redis': context.redis,
      'with_website': context.website,
      'with_webapp': context.webapp,
      'ides': context.ides.map((ide) => ide.name).toSet().toList()..sort(),
    };
  }

  Future<void> captureGenerate({
    required String serverDir,
    required ProtocolAnalyticsSnapshot snapshot,
    required bool success,
    required bool isWatchMode,
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

    await capture(
      event: 'cli.generate',
      serverDir: serverDir,
      properties: {
        'features': snapshot.features,
        'feature_counts': snapshot.featureCounts,
        'serverpod_modules': snapshot.serverpodModules,
        'counts': snapshot.counts,
        'num_generate_calls': metadata.generateCallCount,
        'project_age_days': ProjectMetadataStore.projectAgeDays(metadata),
        'is_watch_mode': isWatchMode,
        'generation_succeeded': success,
        'oneshot_duration_ms': oneshotDurationMs,
        'incremental_avg_duration_ms': incrementalAvgDurationMs,
        'incremental_run_count': incrementalRunCount,
      },
    );
  }

  Future<void> captureMigrationCreated({
    required GeneratorConfig config,
    required MigrationCreatedFlags flags,
    required bool isRepairMigration,
  }) async {
    if (!enabled) return;
    if (!flags.serverMigrationCreated && !flags.clientMigrationCreated) return;

    try {
      final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
      final metrics = await MigrationMetrics.load(config);

      await capture(
        event: 'cli.migration_created',
        serverDir: serverDir,
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
    required DockerStartMode dockerMode,
    required bool dockerComposePresent,
  }) async {
    if (!enabled) return;

    try {
      final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
      final metadata = await ProjectMetadataStore.loadOrCreate(serverDir);
      final flutter = FlutterAppMetrics.load(config);

      await capture(
        event: 'cli.session_start',
        serverDir: serverDir,
        properties: {
          'watch_mode': watchMode,
          'tui_enabled': tuiEnabled,
          'flutter_enabled': flutterEnabled,
          'flutter_app_count': flutter.appCount,
          'flutter_auto_launch_count': flutter.autoLaunchCount,
          'flutter_device_categories': flutter.deviceCategories,
          'flutter_device_platforms': flutter.devicePlatforms,
          'docker_mode': dockerMode.name,
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

  /// Records one companion Flutter app actually starting.
  ///
  /// `cli.session_start` reports which targets a project *configures*; this
  /// reports which it *runs*. Without it a target declared once in a pubspec
  /// and never launched would weigh the same as the one used every day.
  Future<void> captureFlutterLaunch({
    required String serverDir,
    required String? device,
    required bool isRelaunch,
  }) async {
    if (!enabled) return;

    try {
      final buckets = categorizeFlutterDevice(device);
      await capture(
        event: 'cli.flutter_launch',
        serverDir: serverDir,
        properties: {
          'device_category': buckets.category,
          'device_platform': buckets.platform,
          'is_relaunch': isRelaunch,
        },
      );
    } catch (_) {
      // Analytics must never disrupt launching an app.
    }
  }
}

String _createDatabaseDialect(TemplateContext context) {
  if (context.postgres) return 'postgres';
  if (context.sqlite) return 'sqlite';
  return 'none';
}

/// Swallows every event. Backs [CliAnalytics.disabled].
class _NoopAnalytics extends Analytics {
  @override
  Future<void> sendEvent({
    required String event,
    Map<String, dynamic> properties = const {},
  }) async {}
}

CliAnalytics _cliAnalytics = CliAnalytics.disabled();

/// The process-wide rich analytics sink.
///
/// Always safe to call: it is disabled until [initializeCliAnalytics] runs and
/// the command runner enables it.
CliAnalytics get cliAnalytics => _cliAnalytics;

void initializeCliAnalytics(CliAnalytics analytics) {
  _cliAnalytics = analytics;
}
