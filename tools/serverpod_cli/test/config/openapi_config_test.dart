import 'package:serverpod_cli/src/config/config.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../test_util/builders/generator_config_builder.dart';

OpenApiConfig _parse(String yaml) => OpenApiConfig.fromYaml(loadYaml(yaml));

String _names(OpenApiConfig config) =>
    config.servers.map((s) => s.name).join(',');

void main() {
  group('Given environments', () {
    test('when none are configured, then there are no servers.', () {
      expect(_parse('enabled: true').servers, isEmpty);
    });

    test('then each becomes a server in the order written.', () {
      var config = _parse('''
enabled: true
environments:
  staging:
    apiServer:
      publicScheme: https
      publicHost: api-staging.example.com
      publicPort: 443
  qa:
    apiServer:
      publicScheme: http
      publicHost: localhost
      publicPort: 8080
''');

      expect(_names(config), 'staging,qa');
      expect(config.servers.map((s) => s.url), [
        'https://api-staging.example.com',
        'http://localhost:8080',
      ]);
      expect(config.servers.map((s) => s.description), ['Staging', 'Qa']);
      expect(config.servers.every((s) => s.insightsUrl == null), isTrue);
      expect(config.servers.every((s) => s.testCredentials.isEmpty), isTrue);
    });

    test('with a description, then it replaces the default.', () {
      var config = _parse('''
enabled: true
environments:
  staging:
    description: The pre-release environment
    apiServer:
      publicScheme: https
      publicHost: example.org
''');

      expect(config.servers.single.description, 'The pre-release environment');
    });

    test('with an insightsServer, then its URL is kept.', () {
      var config = _parse('''
enabled: true
environments:
  development:
    apiServer:
      publicScheme: http
      publicHost: localhost
      publicPort: 8080
    insightsServer:
      publicScheme: http
      publicHost: localhost
      publicPort: 8081
''');

      expect(config.servers.single.insightsUrl, 'http://localhost:8081');
    });
  });

  group('Given a public port', () {
    String urlFor(String scheme, Object? port) {
      var config = _parse('''
environments:
  e:
    apiServer:
      publicScheme: $scheme
      publicHost: example.com
${port == null ? '' : '      publicPort: $port'}
''');
      return config.servers.single.url;
    }

    test('then it is included when it is not the default.', () {
      expect(urlFor('http', 8080), 'http://example.com:8080');
    });

    test('then the default port of the scheme is left out.', () {
      expect(urlFor('https', 443), 'https://example.com');
      expect(urlFor('http', 80), 'http://example.com');
      expect(urlFor('https', null), 'https://example.com');
    });

    test('then a https URL on port 80 keeps the port.', () {
      expect(urlFor('https', 80), 'https://example.com:80');
    });
  });

  group('Given test credentials', () {
    const schemes = '''
securitySchemes:
  bearerAuth:
    type: http
    scheme: bearer
  keyAuth:
    type: apiKey
    in: header
    name: X-Key
''';
    const api = '''
    apiServer:
      publicScheme: http
      publicHost: localhost
''';

    test('then they are kept per environment as configured.', () {
      var config = _parse('''
enabled: true
$schemes
environments:
  development:
$api
    testCredentials:
      bearerAuth:
        - name: guest
          token: guest-key
        - name: admin
          token: admin-key
      keyAuth:
        value: abc
  staging:
$api
''');

      expect(config.servers.first.testCredentials, {
        'bearerAuth': [
          {'name': 'guest', 'token': 'guest-key'},
          {'name': 'admin', 'token': 'admin-key'},
        ],
        'keyAuth': {'value': 'abc'},
      });
      expect(config.servers.last.testCredentials, isEmpty);
    });

    test('for an undeclared scheme, then the config is rejected.', () {
      expect(
        () => _parse('''
enabled: true
$schemes
environments:
  development:
$api
    testCredentials:
      nope:
        token: x
'''),
        throwsA(
          isA<SourceSpanFormatException>().having(
            (e) => e.message,
            'message',
            contains("'nope' is not a security scheme"),
          ),
        ),
      );
    });

    test('that is not a map, then the config is rejected.', () {
      expect(
        () => _parse('''
enabled: true
$schemes
environments:
  development:
$api
    testCredentials: just-a-token
'''),
        throwsA(isA<SourceSpanFormatException>()),
      );
    });
  });

  group('Given invalid environments', () {
    void expectRejected(String yaml, Matcher message) {
      expect(
        () => _parse(yaml),
        throwsA(
          isA<SourceSpanFormatException>().having(
            (e) => e.message,
            'message',
            message,
          ),
        ),
      );
    }

    test('without an apiServer.', () {
      expectRejected('''
enabled: true
environments:
  sandbox:
    description: No server
''', contains("Environment 'sandbox' has no 'apiServer'"));
    });

    test('that is empty.', () {
      expectRejected('''
enabled: true
environments:
  sandbox:
''', contains("Environment 'sandbox' must be a map"));
    });

    test('with a scheme that is not http or https.', () {
      expectRejected('''
enabled: true
environments:
  sandbox:
    apiServer:
      publicScheme: ftp
      publicHost: example.com
''', contains("needs a 'publicScheme' of http or https"));
    });

    test('with a missing host.', () {
      expectRejected('''
enabled: true
environments:
  sandbox:
    apiServer:
      publicScheme: https
''', contains("needs a 'publicHost'"));
    });

    test('with a port that is not an integer.', () {
      expectRejected('''
enabled: true
environments:
  sandbox:
    apiServer:
      publicScheme: https
      publicHost: example.com
      publicPort: abc
''', contains("'publicPort' of 'apiServer'"));
    });

    test('with an insightsServer that is incomplete.', () {
      expectRejected('''
enabled: true
environments:
  sandbox:
    apiServer:
      publicScheme: https
      publicHost: example.com
    insightsServer:
      publicScheme: https
''', contains("'insightsServer' of environment 'sandbox' needs"));
    });

    test('with an unknown key.', () {
      expectRejected('''
enabled: true
environments:
  development:
    url: http://localhost:8080
''', contains("Unknown key 'url'"));
    });

    test('that is not a map.', () {
      expectRejected('''
enabled: true
environments:
  - development
''', contains("'environments' config must be a map"));
    });
  });

  group('Given the staleness inputs', () {
    test('then the run mode configs are not included.', () {
      var config = GeneratorConfigBuilder()
          .withOpenApi(const OpenApiConfig(enabled: true))
          .build();

      var paths = config.auxiliaryInputPaths.map(
        (p) => p.split(RegExp(r'[\\/]')).last,
      );
      expect(paths, contains('generator.yaml'));
      expect(paths, isNot(contains('development.yaml')));
    });
  });
}
