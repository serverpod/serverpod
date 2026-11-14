import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

/// An environment the API is reachable in, written to the `servers` of the
/// OpenAPI specification.
class OpenApiServer {
  /// The name of the environment, usually a run mode such as `staging`.
  final String name;

  /// The base URL of the API, without a trailing slash.
  final String url;

  /// The base URL of the Insights server, without a trailing slash.
  final String? insightsUrl;

  /// A description of the environment.
  final String? description;

  /// Credentials for trying the API in this environment, keyed by the name of
  /// the security scheme they belong to. The values are written as they are
  /// configured.
  final Map<String, Object?> testCredentials;

  const OpenApiServer({
    required this.name,
    required this.url,
    this.insightsUrl,
    this.description,
    this.testCredentials = const {},
  });
}

/// Settings for OpenAPI generation, read from the `openapi` key of
/// `config/generator.yaml`.
///
/// ```yaml
/// openapi:
///   enabled: true
///   title: My API
///   version: 1.0.0
///   securitySchemes:
///     serverpodAuth:
///       type: http
///       scheme: bearer
///   environments:
///     development:
///       description: Local development
///       apiServer:
///         publicScheme: http
///         publicHost: localhost
///         publicPort: 8080
///       insightsServer:
///         publicScheme: http
///         publicHost: localhost
///         publicPort: 8081
///       testCredentials:
///         serverpodAuth:
///           token: a-test-token
///     sandbox:
///       apiServer:
///         publicScheme: https
///         publicHost: sandbox.example.com
/// ```
///
/// Each key under `environments` is a run mode of your choosing. The
/// `apiServer` and `insightsServer` sections have the same shape as in
/// `config/<run mode>.yaml`.
class OpenApiConfig {
  /// Whether an OpenAPI specification is generated. Off by default.
  final bool enabled;

  /// The `info.title` of the spec. Defaults to the project name.
  final String? title;

  /// The `info.version` of the spec.
  final String version;

  /// Security scheme objects keyed by name, emitted verbatim under
  /// `components.securitySchemes`.
  final Map<String, Map<String, Object?>> securitySchemes;

  /// The environments the API is reachable in, in the order they are listed.
  final List<OpenApiServer> servers;

  const OpenApiConfig({
    this.enabled = false,
    this.title,
    this.version = '1.0.0',
    this.securitySchemes = const {},
    this.servers = const [],
  });

  /// Parses the `openapi` section. Returns a disabled config when [yaml] is
  /// null, and throws a [SourceSpanFormatException] on malformed input.
  factory OpenApiConfig.fromYaml(Object? yaml) {
    if (yaml == null) return const OpenApiConfig();
    if (yaml is! YamlMap) {
      throw SourceSpanFormatException(
        "The 'openapi' config must be a map.",
        yaml is YamlNode ? yaml.span : null,
      );
    }

    var schemes = <String, Map<String, Object?>>{};
    var rawSchemes = yaml['securitySchemes'];
    if (rawSchemes != null) {
      if (rawSchemes is! YamlMap) {
        throw SourceSpanFormatException(
          "The 'securitySchemes' config must be a map.",
          rawSchemes is YamlNode ? rawSchemes.span : null,
        );
      }
      for (var entry in rawSchemes.entries) {
        var value = entry.value;
        if (value is! YamlMap || value['type'] is! String) {
          throw SourceSpanFormatException(
            "Security scheme '${entry.key}' must be a map with a 'type'.",
            value is YamlNode ? value.span : null,
          );
        }
        schemes['${entry.key}'] = _toPlain(value) as Map<String, Object?>;
      }
    }

    return OpenApiConfig(
      enabled: yaml['enabled'] == true,
      title: yaml['title'] as String?,
      version: (yaml['version'] ?? '1.0.0').toString(),
      securitySchemes: schemes,
      servers: _parseServers(yaml['environments'], schemes.keys),
    );
  }

  static const _environmentKeys = {
    'description',
    'apiServer',
    'insightsServer',
    'testCredentials',
  };

  static List<OpenApiServer> _parseServers(
    Object? environments,
    Iterable<String> schemeNames,
  ) {
    if (environments == null) return const [];
    if (environments is! YamlMap) {
      throw SourceSpanFormatException(
        "The 'environments' config must be a map.",
        environments is YamlNode ? environments.span : null,
      );
    }

    var servers = <OpenApiServer>[];
    for (var entry in environments.nodes.entries) {
      var name = '${(entry.key as YamlNode).value}';
      var node = entry.value;
      if (node is! YamlMap) {
        throw SourceSpanFormatException(
          "Environment '$name' must be a map with an 'apiServer'.",
          node.span,
        );
      }

      for (var key in node.nodes.keys.cast<YamlNode>()) {
        if (!_environmentKeys.contains(key.value)) {
          throw SourceSpanFormatException(
            "Unknown key '${key.value}' in environment '$name'. "
            'Supported keys: ${_environmentKeys.join(', ')}.',
            key.span,
          );
        }
      }

      var apiServer = node.nodes['apiServer'];
      if (apiServer == null) {
        throw SourceSpanFormatException(
          "Environment '$name' has no 'apiServer'. Set publicScheme, "
          'publicHost and publicPort.',
          node.span,
        );
      }

      var insightsServer = node.nodes['insightsServer'];
      var description = node['description'];
      if (description != null && description is! String) {
        throw SourceSpanFormatException(
          "'description' of environment '$name' must be a string.",
          node.nodes['description']!.span,
        );
      }

      servers.add(
        OpenApiServer(
          name: name,
          url: _publicUrlOf(apiServer, 'apiServer', name),
          insightsUrl: insightsServer == null
              ? null
              : _publicUrlOf(insightsServer, 'insightsServer', name),
          description: description as String? ?? _capitalize(name),
          testCredentials: _parseCredentials(
            node.nodes['testCredentials'],
            schemeNames.toSet(),
          ),
        ),
      );
    }

    return servers;
  }

  /// The public base URL described by an `apiServer` or `insightsServer`
  /// section. The port is left out when it is the default of the scheme.
  static String _publicUrlOf(YamlNode? node, String section, String name) {
    if (node is! YamlMap) {
      throw SourceSpanFormatException(
        "'$section' of environment '$name' must be a map.",
        node?.span,
      );
    }

    var scheme = node['publicScheme'];
    if (scheme != 'http' && scheme != 'https') {
      throw SourceSpanFormatException(
        "'$section' of environment '$name' needs a 'publicScheme' of http or "
        'https.',
        node.span,
      );
    }

    var host = node['publicHost'];
    if (host is! String || host.isEmpty) {
      throw SourceSpanFormatException(
        "'$section' of environment '$name' needs a 'publicHost'.",
        node.span,
      );
    }

    var port = node['publicPort'];
    if (port != null && port is! int) {
      throw SourceSpanFormatException(
        "'publicPort' of '$section' in environment '$name' must be an "
        'integer.',
        node.nodes['publicPort']!.span,
      );
    }

    var isDefaultPort =
        port == null ||
        (scheme == 'http' && port == 80) ||
        (scheme == 'https' && port == 443);
    return isDefaultPort ? '$scheme://$host' : '$scheme://$host:$port';
  }

  static Map<String, Object?> _parseCredentials(
    YamlNode? node,
    Set<String> schemeNames,
  ) {
    if (node == null || node.value == null) return const {};
    if (node is! YamlMap) {
      throw SourceSpanFormatException(
        "'testCredentials' must be a map from security scheme names to "
        'credentials.',
        node.span,
      );
    }

    var credentials = <String, Object?>{};
    for (var entry in node.nodes.entries) {
      var key = entry.key as YamlNode;
      if (!schemeNames.contains('${key.value}')) {
        throw SourceSpanFormatException(
          "'${key.value}' is not a security scheme declared under "
          "'securitySchemes'.",
          key.span,
        );
      }
      credentials['${key.value}'] = _toPlain(entry.value);
    }

    return credentials;
  }

  static String _capitalize(String name) =>
      name.isEmpty ? name : '${name[0].toUpperCase()}${name.substring(1)}';

  static Object? _toPlain(Object? node) {
    // A YamlMap or YamlList is its own `value`, so only scalars are unwrapped.
    if (node is YamlScalar) return node.value;
    if (node is Map) {
      return {
        for (var e in node.entries) '${_toPlain(e.key)}': _toPlain(e.value),
      };
    }
    if (node is List) return [for (var e in node) _toPlain(e)];
    return node;
  }
}
