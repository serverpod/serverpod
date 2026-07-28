import 'protocol_feature_analyzer.dart';

/// Runtime allowlist for PostHog event payloads.
class AnalyticsPayloadBuilder {
  /// Schema version for `cli.*` events. Independent of the CLI version — bump
  /// only when an event's shape changes (property added / removed / retyped),
  /// so dashboards can tell "absent because old CLI" from "absent because
  /// removed".
  static const schemaVersion = 1;

  static const projectCreatedMethods = {'create', 'quickstart'};
  static const projectCreatedTemplates = {'mini', 'server', 'module'};
  static const flutterDeviceCategories = {
    'chrome',
    'web-server',
    'mobile',
    'desktop',
    'headless',
  };
  static const generateCountKeys = {
    'model_count',
    'endpoint_count',
    'enum_count',
    'relation_count',
    'future_call_count',
    'module_count',
  };
  static const trackedCommands = {
    'generate',
    'create-migration',
    'create-repair-migration',
    'start',
    'create',
    'quickstart',
    'migrate',
    'run',
    'upgrade',
    'version',
    'mcp',
    'language-server',
    'analyze-pubspecs',
    'generate-pubspecs',
  };

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
        _addBool(payload, 'force', properties['force']);
      case 'cli.generate':
        _addStringList(
          payload,
          'features',
          properties['features'],
          allowed: protocolFeatureTags,
        );
        _addStringList(
          payload,
          'serverpod_modules',
          properties['serverpod_modules'],
          allowed: officialServerpodModules,
        );
        _addCountMap(payload, 'counts', properties['counts']);
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
        _addOptionalString(
          payload,
          'flutter_device_category',
          properties['flutter_device_category'],
          flutterDeviceCategories,
        );
        _addBool(payload, 'docker_flag', properties['docker_flag']);
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

  static void _addOptionalString(
    Map<String, dynamic> payload,
    String key,
    Object? value,
    Set<String> allowed,
  ) {
    if (value == null) return;
    _addString(payload, key, value, allowed);
  }

  static void _addStringList(
    Map<String, dynamic> payload,
    String key,
    Object? value, {
    Set<String>? allowed,
  }) {
    if (value is! List) {
      throw ArgumentError('Expected List for $key');
    }
    final values = <String>[];
    for (final item in value) {
      if (item is! String) {
        throw ArgumentError('Expected string entries for $key');
      }
      if (allowed != null && !allowed.contains(item)) {
        throw ArgumentError('Unexpected value for $key: $item');
      }
      values.add(item);
    }
    payload[key] = values;
  }

  static void _addCountMap(
    Map<String, dynamic> payload,
    String key,
    Object? value,
  ) {
    if (value is! Map) {
      throw ArgumentError('Expected Map for $key');
    }
    final counts = <String, int>{};
    for (final entry in value.entries) {
      if (entry.key is! String || entry.value is! int) {
        throw ArgumentError('Invalid counts map entry');
      }
      final mapKey = entry.key as String;
      if (!generateCountKeys.contains(mapKey)) {
        throw ArgumentError('Unexpected counts key: $mapKey');
      }
      counts[mapKey] = entry.value as int;
    }
    for (final requiredKey in generateCountKeys) {
      counts.putIfAbsent(requiredKey, () => 0);
    }
    payload[key] = counts;
  }

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
      if (entry.key is! String || entry.value is! int) {
        throw ArgumentError('Invalid command_invocations entry');
      }
      final command = entry.key as String;
      if (!trackedCommands.contains(command)) {
        throw ArgumentError('Unexpected command in invocations: $command');
      }
      invocations[command] = entry.value as int;
    }
    payload[key] = invocations;
  }
}
