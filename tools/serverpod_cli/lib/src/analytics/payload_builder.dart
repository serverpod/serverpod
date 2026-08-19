import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/ide.dart';

import 'protocol_feature_analyzer.dart';
import 'session_metrics.dart';

/// Runtime allowlist for PostHog event payloads.
///
/// Vocabularies are derived from the enums the CLI already defines rather than
/// re-typed here, so renaming a template, IDE or command cannot silently start
/// dropping events.
class AnalyticsPayloadBuilder {
  /// Schema version for `cli.*` events. Independent of the CLI version — bump
  /// only when an event's shape changes (property added / removed / retyped),
  /// so dashboards can tell "absent because old CLI" from "absent because
  /// removed".
  static const schemaVersion = 1;

  static const projectCreatedMethods = {'create', 'quickstart'};
  static const databaseDialects = {'postgres', 'sqlite', 'none'};

  static final projectCreatedTemplates = {
    for (final template in ServerpodTemplateType.values) template.name,
  };
  static final projectCreatedIdes = {
    for (final ide in TemplateIde.values) ide.name,
  };
  static final dockerStartModes = {
    for (final mode in DockerStartMode.values) mode.name,
  };

  /// Shape a `command_invocations` key must have to be sent.
  ///
  /// Keys are subcommand names the CLI itself registered (see
  /// [ServerpodCommandRunner.runCommand], which is what gates the write side),
  /// so this is a defensive bound rather than a vocabulary: a hand-maintained
  /// list of command names silently stops counting whenever a command is
  /// renamed or added.
  static final commandNamePattern = RegExp(r'^[a-z][a-z0-9-]{0,31}$');

  static Map<String, dynamic> build({
    required String event,
    required Map<String, Object?> properties,
    required String projectId,
    required String checkoutId,
  }) {
    final payload = <String, dynamic>{
      '\$groups': {'project': projectId},
      'checkout_id': checkoutId,
      'schema_version': schemaVersion,
    };

    switch (event) {
      case 'cli.project_created':
        _addString(
          payload,
          'method',
          properties['method'],
          projectCreatedMethods,
        );
        _addTemplateProperties(payload, properties);
        _addBool(payload, 'force', properties['force']);
      case 'cli.project_upgraded':
        _addTemplateProperties(payload, properties);
        _addBool(
          payload,
          'created_default_migration',
          properties['created_default_migration'],
        );
        _addOptionalInt(
          payload,
          'project_age_days',
          properties['project_age_days'],
        );
      case 'cli.generate':
        _addStringList(
          payload,
          'features',
          properties['features'],
          accepts: isProtocolFeatureTag,
        );
        _addStringList(
          payload,
          'serverpod_modules',
          properties['serverpod_modules'],
          accepts: officialServerpodModules.contains,
        );
        _addKeyedIntMap(
          payload,
          'counts',
          properties['counts'],
          accepts: generateCountKeys.contains,
          fillMissing: generateCountKeys,
        );
        _addKeyedIntMap(
          payload,
          'feature_counts',
          properties['feature_counts'],
          accepts: isProtocolFeatureTag,
        );
        _addInt(
          payload,
          'num_generate_calls',
          properties['num_generate_calls'],
        );
        _addInt(payload, 'project_age_days', properties['project_age_days']);
        _addBool(payload, 'is_watch_mode', properties['is_watch_mode']);
        _addBool(
          payload,
          'generation_succeeded',
          properties['generation_succeeded'],
        );
        _addOptionalInt(
          payload,
          'oneshot_duration_ms',
          properties['oneshot_duration_ms'],
        );
        _addOptionalInt(
          payload,
          'incremental_avg_duration_ms',
          properties['incremental_avg_duration_ms'],
        );
        _addOptionalInt(
          payload,
          'incremental_run_count',
          properties['incremental_run_count'],
        );
      case 'cli.migration_created':
        _addBool(
          payload,
          'server_migration_created',
          properties['server_migration_created'],
        );
        _addBool(
          payload,
          'client_migration_created',
          properties['client_migration_created'],
        );
        _addInt(
          payload,
          'server_migration_count',
          properties['server_migration_count'],
        );
        _addInt(
          payload,
          'client_migration_count',
          properties['client_migration_count'],
        );
        _addInt(
          payload,
          'days_since_first_migration',
          properties['days_since_first_migration'],
        );
        _addOptionalDouble(
          payload,
          'average_interval_days',
          properties['average_interval_days'],
        );
        _addBool(
          payload,
          'is_repair_migration',
          properties['is_repair_migration'],
        );
      case 'cli.session_start':
        _addBool(payload, 'watch_mode', properties['watch_mode']);
        _addBool(payload, 'tui_enabled', properties['tui_enabled']);
        _addBool(payload, 'flutter_enabled', properties['flutter_enabled']);
        _addInt(payload, 'flutter_app_count', properties['flutter_app_count']);
        _addInt(
          payload,
          'flutter_auto_launch_count',
          properties['flutter_auto_launch_count'],
        );
        _addStringList(
          payload,
          'flutter_device_categories',
          properties['flutter_device_categories'],
          accepts: flutterDeviceCategories.contains,
        );
        _addStringList(
          payload,
          'flutter_device_platforms',
          properties['flutter_device_platforms'],
          accepts: flutterDevicePlatforms.contains,
        );
        _addString(
          payload,
          'docker_mode',
          properties['docker_mode'],
          dockerStartModes,
        );
        _addBool(
          payload,
          'docker_compose_present',
          properties['docker_compose_present'],
        );
        _addInt(payload, 'num_tool_calls', properties['num_tool_calls']);
        _addCommandInvocations(
          payload,
          'command_invocations',
          properties['command_invocations'],
        );
      case 'cli.flutter_launch':
        _addString(
          payload,
          'device_category',
          properties['device_category'],
          flutterDeviceCategories,
        );
        _addString(
          payload,
          'device_platform',
          properties['device_platform'],
          flutterDevicePlatforms,
        );
        _addBool(payload, 'is_relaunch', properties['is_relaunch']);
      default:
        throw ArgumentError.value(
          event,
          'event',
          'Unsupported analytics event',
        );
    }

    return payload;
  }

  static void _addBool(
    Map<String, dynamic> payload,
    String key,
    Object? value,
  ) {
    if (value is! bool) {
      throw ArgumentError('Expected bool for $key');
    }
    payload[key] = value;
  }

  static void _addInt(Map<String, dynamic> payload, String key, Object? value) {
    if (value is! int) {
      throw ArgumentError('Expected int for $key');
    }
    payload[key] = value;
  }

  static void _addOptionalInt(
    Map<String, dynamic> payload,
    String key,
    Object? value,
  ) {
    if (value == null) return;
    _addInt(payload, key, value);
  }

  static void _addOptionalDouble(
    Map<String, dynamic> payload,
    String key,
    Object? value,
  ) {
    if (value == null) return;
    if (value is! double) {
      throw ArgumentError('Expected double for $key');
    }
    payload[key] = value;
  }

  static void _addString(
    Map<String, dynamic> payload,
    String key,
    Object? value,
    Set<String> allowed,
  ) {
    if (value is! String || !allowed.contains(value)) {
      throw ArgumentError('Invalid value for $key');
    }
    payload[key] = value;
  }

  static void _addStringList(
    Map<String, dynamic> payload,
    String key,
    Object? value, {
    required bool Function(String) accepts,
  }) {
    if (value is! List) {
      throw ArgumentError('Expected List for $key');
    }
    final values = <String>[];
    for (final item in value) {
      if (item is! String) {
        throw ArgumentError('Expected string entries for $key');
      }
      if (!accepts(item)) {
        throw ArgumentError('Unexpected value for $key: $item');
      }
      values.add(item);
    }
    payload[key] = values;
  }

  static void _addKeyedIntMap(
    Map<String, dynamic> payload,
    String key,
    Object? value, {
    required bool Function(String) accepts,
    Set<String> fillMissing = const {},
  }) {
    if (value is! Map) {
      throw ArgumentError('Expected Map for $key');
    }
    final entries = <String, int>{};
    for (final entry in value.entries) {
      final mapKey = entry.key;
      final mapValue = entry.value;
      if (mapKey is! String || mapValue is! int) {
        throw ArgumentError('Invalid $key entry');
      }
      if (!accepts(mapKey)) {
        throw ArgumentError('Unexpected $key entry: $mapKey');
      }
      entries[mapKey] = mapValue;
    }
    // Absent keys are reported as zero so a dashboard can tell "no models" from
    // "this CLI did not know about this count yet".
    for (final requiredKey in fillMissing) {
      entries.putIfAbsent(requiredKey, () => 0);
    }
    payload[key] = entries;
  }

  static void _addTemplateProperties(
    Map<String, dynamic> payload,
    Map<String, Object?> properties,
  ) {
    _addString(
      payload,
      'template',
      properties['template'],
      projectCreatedTemplates,
    );
    _addBool(payload, 'with_flutter', properties['with_flutter']);
    _addBool(payload, 'with_docker', properties['with_docker']);
    _addBool(payload, 'with_auth', properties['with_auth']);
    _addBool(payload, 'with_database', properties['with_database']);
    _addString(
      payload,
      'database_dialect',
      properties['database_dialect'],
      databaseDialects,
    );
    _addBool(payload, 'with_redis', properties['with_redis']);
    _addBool(payload, 'with_website', properties['with_website']);
    _addBool(payload, 'with_webapp', properties['with_webapp']);
    _addStringList(
      payload,
      'ides',
      properties['ides'],
      accepts: projectCreatedIdes.contains,
    );
  }

  /// Copies the per-command histogram, dropping anything that does not look
  /// like a CLI subcommand name.
  ///
  /// Entries are dropped rather than rejected: the histogram is read back from
  /// a metadata file that a newer CLI may have written, and one unrecognized
  /// key must not cost the whole event.
  static void _addCommandInvocations(
    Map<String, dynamic> payload,
    String key,
    Object? value,
  ) {
    if (value is! Map) {
      throw ArgumentError('Expected Map for $key');
    }
    final invocations = <String, int>{};
    for (final entry in value.entries) {
      final command = entry.key;
      final count = entry.value;
      if (command is! String || count is! int) continue;
      if (!commandNamePattern.hasMatch(command)) continue;
      invocations[command] = count;
    }
    payload[key] = invocations;
  }
}
