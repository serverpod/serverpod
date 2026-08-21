import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

import '../server/test_helpers/empty_endpoints.dart';

void main() {
  const environmentCacheControlTestName =
      'Given a static cache control environment variable and no Dart factory, '
      'when a static file is requested, '
      'then the environment cache control is applied.';
  test(environmentCacheControlTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: environmentCacheControlTestName,
      value: 'public, max-age=60, s-maxage=86400',
    )) {
      return;
    }

    final (:pod, :tempDir) = await _createStaticFileServer();
    addTearDown(() async {
      await pod.shutdown(exitProcess: false);
      await tempDir.delete(recursive: true);
    });

    pod.webServer.addRoute(
      StaticRoute.directory(tempDir),
      '/static',
    );
    await pod.start();

    final response = await http.get(
      Uri.parse('http://localhost:${pod.webServer.port}/static/test.txt'),
    );

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], contains('public'));
    expect(response.headers['cache-control'], contains('max-age=60'));
    expect(response.headers['cache-control'], contains('s-maxage=86400'));
  });

  const dartCacheControlTestName =
      'Given a static cache control environment variable and a Dart factory, '
      'when a static file is requested, '
      'then the Dart cache control takes precedence.';
  test(dartCacheControlTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: dartCacheControlTestName,
      value: 'max-age=not-a-number',
    )) {
      return;
    }

    final (:pod, :tempDir) = await _createStaticFileServer();
    addTearDown(() async {
      await pod.shutdown(exitProcess: false);
      await tempDir.delete(recursive: true);
    });

    pod.webServer.addRoute(
      StaticRoute.directory(
        tempDir,
        cacheControlFactory: StaticRoute.noStore(),
      ),
      '/static',
    );
    await pod.start();

    final response = await http.get(
      Uri.parse('http://localhost:${pod.webServer.port}/static/test.txt'),
    );

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], contains('no-store'));
    expect(response.headers['cache-control'], isNot(contains('public')));
  });

  const invalidEnvironmentCacheControlTestName =
      'Given an invalid static cache control environment variable and no Dart factory, '
      'when StaticRoute.directory is created, '
      'then a FormatException is thrown.';
  test(invalidEnvironmentCacheControlTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: invalidEnvironmentCacheControlTestName,
      value: 'invalid-directive',
    )) {
      return;
    }

    final tempDir = await Directory.systemTemp.createTemp(
      'static_route_cache_control_test_',
    );
    addTearDown(() => tempDir.delete(recursive: true));

    expect(() => StaticRoute.directory(tempDir), throwsFormatException);
  });
}

Future<({Serverpod pod, Directory tempDir})> _createStaticFileServer() async {
  final tempDir = await Directory.systemTemp.createTemp(
    'static_route_cache_control_test_',
  );
  await File(p.join(tempDir.path, 'test.txt')).writeAsString('Hello, World!');

  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  final pod = Serverpod(
    [],
    internal.Protocol(),
    EmptyEndpoints(),
    config: ServerpodConfig(
      apiServer: portZeroConfig,
      webServer: portZeroConfig,
    ),
  );

  return (pod: pod, tempDir: tempDir);
}

Future<bool> _rerunWithCacheControlEnvironment({
  required String testName,
  required String value,
}) async {
  const cacheControlEnvVarName = 'SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL';

  if (Platform.environment[cacheControlEnvVarName] == value) {
    return false;
  }

  final result = await Process.run(
    Platform.resolvedExecutable,
    [
      'test',
      '--plain-name',
      testName,
      'test/web_server/static_route_cache_control_test.dart',
    ],
    workingDirectory: Directory.current.path,
    environment: {cacheControlEnvVarName: value},
  );

  expect(
    result.exitCode,
    0,
    reason:
        'Nested test failed.\nstdout:\n${result.stdout}\nstderr:\n${result.stderr}',
  );
  return true;
}
