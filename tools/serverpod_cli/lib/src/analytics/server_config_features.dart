import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Capability tags derived from the server's development run-mode config.
///
/// Read straight from `config/development.yaml` rather than through
/// `ServerpodConfig.load`, which also wants `config/passwords.yaml` and throws
/// on partially configured projects. Only the presence of a handful of sections
/// is inspected; no value from the file is ever sent.
class ServerConfigFeatures {
  const ServerConfigFeatures._(this.tags);

  final Set<String> tags;

  static const _empty = ServerConfigFeatures._({});

  /// All tags this reader can produce.
  static const availableTags = {
    'postgres_embedded',
    'redis',
    'web_server',
    'insights_server',
    'future_calls_disabled',
  };

  static ServerConfigFeatures load(String serverDir) {
    final file = File(p.join(serverDir, 'config', 'development.yaml'));
    if (!file.existsSync()) return _empty;

    try {
      final yaml = loadYaml(file.readAsStringSync());
      if (yaml is! YamlMap) return _empty;

      final tags = <String>{};

      // An embedded PostgreSQL is a `database:` with a `dataPath:`; without one
      // the server connects to an external (typically Docker) instance.
      final database = yaml['database'];
      if (database is YamlMap && database['dataPath'] != null) {
        tags.add('postgres_embedded');
      }

      // `redis:` is templated in only when the project opted into Redis, and
      // carries an explicit `enabled` toggle on top of that.
      final redis = yaml['redis'];
      if (redis is YamlMap && redis['enabled'] != false) {
        tags.add('redis');
      }

      if (yaml['webServer'] is YamlMap) tags.add('web_server');
      if (yaml['insightsServer'] is YamlMap) tags.add('insights_server');
      if (yaml['futureCallExecutionEnabled'] == false) {
        tags.add('future_calls_disabled');
      }

      return ServerConfigFeatures._(tags);
    } catch (_) {
      // A malformed config must not cost the whole event.
      return _empty;
    }
  }
}
