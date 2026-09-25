import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config_info/config_info.dart';
import 'package:test/test.dart';

import '../test_util/file_system_entity_helpers.dart';

void main() {
  group(
    'Given a server package whose insights server binds 8081 while advertising a proxy on 9091,',
    () {
      late String serverDir;

      setUp(() async {
        serverDir = await _serverDirWithDevelopmentConfig('''
insightsServer:
  port: 8081
  publicHost: localhost
  publicPort: 9091
  publicScheme: http
''');
      });

      test(
        'when a service client is created for the address the pod reported, '
        'then it targets that address instead of the configured port',
        () {
          final client = ConfigInfo(
            'development',
            serverDir: serverDir,
          ).createServiceClientFor('http://localhost:43117');
          addTearDown(client.close);

          expect(client.host, 'http://localhost:43117/');
        },
      );

      test(
        'when the configured insights address is read, '
        'then it uses the advertised public port.',
        () {
          final configInfo = ConfigInfo('development', serverDir: serverDir);

          expect(
            configInfo.configuredInsightsAddress,
            'http://localhost:9091/',
          );
        },
      );
    },
  );

  group(
    'Given a server package whose insights server binds 8081 behind an HTTPS proxy on 443,',
    () {
      late String serverDir;

      setUp(() async {
        serverDir = await _serverDirWithDevelopmentConfig('''
insightsServer:
  port: 8081
  publicHost: insights.example.com
  publicPort: 443
  publicScheme: https
''');
      });

      test(
        'when the configured insights address is read, '
        'then it uses the public scheme, host, and port.',
        () {
          final configInfo = ConfigInfo('development', serverDir: serverDir);

          expect(
            configInfo.configuredInsightsAddress,
            'https://insights.example.com:443/',
          );
        },
      );
    },
  );

  group(
    'Given a server package whose insights server binds a dynamic port while advertising a proxy on 9091,',
    () {
      late String serverDir;

      setUp(() async {
        serverDir = await _serverDirWithDevelopmentConfig('''
insightsServer:
  port: 0
  publicHost: localhost
  publicPort: 9091
  publicScheme: http
''');
      });

      test(
        'when the configured insights address is read, '
        'then it uses the advertised public port.',
        () {
          final configInfo = ConfigInfo('development', serverDir: serverDir);

          expect(
            configInfo.configuredInsightsAddress,
            'http://localhost:9091/',
          );
        },
      );
    },
  );

  group('Given a server package with no insights server configured,', () {
    late String serverDir;

    setUp(() async {
      serverDir = await _serverDirWithDevelopmentConfig('''
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
''');
    });

    test(
      'when the configured insights address is read, '
      'then it fails rather than naming an address',
      () {
        final configInfo = ConfigInfo('development', serverDir: serverDir);

        expect(
          () => configInfo.configuredInsightsAddress,
          throwsA(isA<StateError>()),
        );
      },
    );
  });
}

/// Creates a server directory whose `config/development.yaml` holds [yaml],
/// removed at teardown.
Future<String> _serverDirWithDevelopmentConfig(String yaml) async {
  final dir = await Directory.systemTemp.createTemp('config_info_');
  addTearDown(() => dir.deleteBestEffort(recursive: true));
  File(p.join(dir.path, 'config', 'development.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync(yaml);
  return dir.path;
}
