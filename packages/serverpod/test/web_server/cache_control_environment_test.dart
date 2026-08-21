import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

const _testFilePath = 'test/web_server/cache_control_environment_test.dart';
const _staticCacheControlVariable = 'SERVERPOD_WEB_SERVER_STATIC_CACHE_CONTROL';
const _spaCacheControlVariable = 'SERVERPOD_WEB_SERVER_SPA_CACHE_CONTROL';

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}

void main() {
  const staticDirectoryTestName =
      'Given a StaticRoute.directory without a Dart factory and a static cache control environment variable, '
      'when a file is requested, '
      'then the environment cache control is applied.';
  test(staticDirectoryTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: staticDirectoryTestName,
      variable: _staticCacheControlVariable,
      value: 'public, max-age=60, s-maxage=86400',
    )) {
      return;
    }

    final server = await _createFileServer();
    server.pod.webServer.addRoute(
      StaticRoute.directory(server.directory),
      '/static',
    );
    await server.start();

    final response = await server.get('/static/test.txt');

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], contains('public'));
    expect(response.headers['cache-control'], contains('max-age=60'));
    expect(response.headers['cache-control'], contains('s-maxage=86400'));
  });

  const staticFileTestName =
      'Given a StaticRoute.file without a Dart factory and a static cache control environment variable, '
      'when the file is requested, '
      'then the environment cache control is applied.';
  test(staticFileTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: staticFileTestName,
      variable: _staticCacheControlVariable,
      value: 'public, max-age=60, s-maxage=86400',
    )) {
      return;
    }

    final server = await _createFileServer();
    server.pod.webServer.addRoute(
      StaticRoute.file(server.file('test.txt')),
      '/file.txt',
    );
    await server.start();

    final response = await server.get('/file.txt');

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], contains('public'));
    expect(response.headers['cache-control'], contains('max-age=60'));
    expect(response.headers['cache-control'], contains('s-maxage=86400'));
  });

  const staticDartFactoryTestName =
      'Given a StaticRoute.directory with a Dart factory and a static cache control environment variable, '
      'when a file is requested, '
      'then the Dart cache control takes precedence.';
  test(staticDartFactoryTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: staticDartFactoryTestName,
      variable: _staticCacheControlVariable,
      value: 'max-age=not-a-number',
    )) {
      return;
    }

    final server = await _createFileServer();
    server.pod.webServer.addRoute(
      StaticRoute.directory(
        server.directory,
        cacheControlFactory: StaticRoute.noStore(),
      ),
      '/static',
    );
    await server.start();

    final response = await server.get('/static/test.txt');

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], contains('no-store'));
    expect(response.headers['cache-control'], isNot(contains('public')));
  });

  const invalidStaticEnvironmentTestName =
      'Given an invalid static cache control environment variable and no Dart factory, '
      'when a StaticRoute.directory is created, '
      'then a FormatException is thrown.';
  test(invalidStaticEnvironmentTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: invalidStaticEnvironmentTestName,
      variable: _staticCacheControlVariable,
      value: 'invalid-directive',
    )) {
      return;
    }

    final directory = await _createTempDirectory();

    expect(() => StaticRoute.directory(directory), throwsFormatException);
  });

  const staticEnvironmentOnSpaAssetTestName =
      'Given a SpaRoute and a static cache control environment variable, '
      'when an asset is requested, '
      'then no cache control is applied.';
  test(staticEnvironmentOnSpaAssetTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: staticEnvironmentOnSpaAssetTestName,
      variable: _staticCacheControlVariable,
      value: 'public, max-age=60, s-maxage=86400',
    )) {
      return;
    }

    final server = await _createFileServer();
    server.pod.webServer.addRoute(
      SpaRoute(server.directory, fallback: server.file('index.html')),
    );
    await server.start();

    final response = await server.get('/test.txt');

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], isNull);
  });

  const staticEnvironmentOnSpaFallbackTestName =
      'Given a SpaRoute and a static cache control environment variable, '
      'when a client side route is requested, '
      'then no cache control is applied.';
  test(staticEnvironmentOnSpaFallbackTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: staticEnvironmentOnSpaFallbackTestName,
      variable: _staticCacheControlVariable,
      value: 'public, max-age=60, s-maxage=86400',
    )) {
      return;
    }

    final server = await _createFileServer();
    server.pod.webServer.addRoute(
      SpaRoute(server.directory, fallback: server.file('index.html')),
    );
    await server.start();

    final response = await server.get('/client/side/route');

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], isNull);
  });

  const staticEnvironmentOnFlutterAssetTestName =
      'Given a FlutterRoute and a static cache control environment variable, '
      'when an asset is requested, '
      'then the Flutter asset cache control default is applied.';
  test(staticEnvironmentOnFlutterAssetTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: staticEnvironmentOnFlutterAssetTestName,
      variable: _staticCacheControlVariable,
      value: 'public, max-age=60, s-maxage=86400',
    )) {
      return;
    }

    final server = await _createFileServer();
    server.pod.webServer.addRoute(FlutterRoute(server.directory));
    await server.start();

    final response = await server.get('/test.txt');

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], contains('public'));
    expect(response.headers['cache-control'], contains('max-age=86400'));
  });

  const spaAssetTestName =
      'Given a SpaRoute without a Dart factory and a SPA cache control environment variable, '
      'when an asset is requested, '
      'then the environment cache control is applied.';
  test(spaAssetTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: spaAssetTestName,
      variable: _spaCacheControlVariable,
      value: 'public, max-age=120',
    )) {
      return;
    }

    final server = await _createFileServer();
    server.pod.webServer.addRoute(
      SpaRoute(server.directory, fallback: server.file('index.html')),
    );
    await server.start();

    final response = await server.get('/test.txt');

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], contains('public'));
    expect(response.headers['cache-control'], contains('max-age=120'));
  });

  const spaFallbackTestName =
      'Given a SpaRoute without a Dart factory and a SPA cache control environment variable, '
      'when a client side route is requested, '
      'then no cache control is applied.';
  test(spaFallbackTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: spaFallbackTestName,
      variable: _spaCacheControlVariable,
      value: 'public, max-age=120',
    )) {
      return;
    }

    final server = await _createFileServer();
    server.pod.webServer.addRoute(
      SpaRoute(server.directory, fallback: server.file('index.html')),
    );
    await server.start();

    final response = await server.get('/client/side/route');

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], isNull);
  });

  const spaDartFactoryTestName =
      'Given a SpaRoute with a Dart factory and a SPA cache control environment variable, '
      'when an asset is requested, '
      'then the Dart cache control takes precedence.';
  test(spaDartFactoryTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: spaDartFactoryTestName,
      variable: _spaCacheControlVariable,
      value: 'max-age=not-a-number',
    )) {
      return;
    }

    final server = await _createFileServer();
    server.pod.webServer.addRoute(
      SpaRoute(
        server.directory,
        fallback: server.file('index.html'),
        cacheControlFactory: StaticRoute.noStore(),
      ),
    );
    await server.start();

    final response = await server.get('/test.txt');

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], contains('no-store'));
  });

  const spaEnvironmentOnStaticFileTestName =
      'Given a StaticRoute.directory and a SPA cache control environment variable, '
      'when a file is requested, '
      'then no cache control is applied.';
  test(spaEnvironmentOnStaticFileTestName, () async {
    if (await _rerunWithCacheControlEnvironment(
      testName: spaEnvironmentOnStaticFileTestName,
      variable: _spaCacheControlVariable,
      value: 'public, max-age=120',
    )) {
      return;
    }

    final server = await _createFileServer();
    server.pod.webServer.addRoute(
      StaticRoute.directory(server.directory),
      '/static',
    );
    await server.start();

    final response = await server.get('/static/test.txt');

    expect(response.statusCode, 200);
    expect(response.headers['cache-control'], isNull);
  });

  test(
    'Given a StaticRoute.file without a Dart factory and no cache control environment variable, '
    'when the file is requested, '
    'then no cache control is applied.',
    () async {
      final server = await _createFileServer();
      server.pod.webServer.addRoute(
        StaticRoute.file(server.file('test.txt')),
        '/file.txt',
      );
      await server.start();

      final response = await server.get('/file.txt');

      expect(response.statusCode, 200);
      expect(response.headers['cache-control'], isNull);
    },
  );

  test(
    'Given a SpaRoute without a Dart factory and no cache control environment variable, '
    'when an asset is requested, '
    'then no cache control is applied.',
    () async {
      final server = await _createFileServer();
      server.pod.webServer.addRoute(
        SpaRoute(server.directory, fallback: server.file('index.html')),
      );
      await server.start();

      final response = await server.get('/test.txt');

      expect(response.statusCode, 200);
      expect(response.headers['cache-control'], isNull);
    },
  );

  test(
    'Given a SpaRoute with a Dart factory and no cache control environment variable, '
    'when a client side route is requested, '
    'then no cache control is applied.',
    () async {
      final server = await _createFileServer();
      server.pod.webServer.addRoute(
        SpaRoute(
          server.directory,
          fallback: server.file('index.html'),
          cacheControlFactory: StaticRoute.publicImmutable(
            maxAge: const Duration(days: 365),
          ),
        ),
      );
      await server.start();

      final response = await server.get('/client/side/route');

      expect(response.statusCode, 200);
      expect(response.headers['cache-control'], isNull);
    },
  );

  test(
    'Given a SpaRoute without a Dart factory and no cache control environment variable, '
    'when a client side route is requested, '
    'then no cache control is applied.',
    () async {
      final server = await _createFileServer();
      server.pod.webServer.addRoute(
        SpaRoute(server.directory, fallback: server.file('index.html')),
      );
      await server.start();

      final response = await server.get('/client/side/route');

      expect(response.statusCode, 200);
      expect(response.headers['cache-control'], isNull);
    },
  );
}

/// A web server serving the files of a temporary directory.
class _FileServer {
  final Serverpod pod;
  final Directory directory;

  _FileServer(this.pod, this.directory);

  File file(String name) => File(p.join(directory.path, name));

  Future<void> start() => pod.start();

  Future<http.Response> get(String path) =>
      http.get(Uri.parse('http://localhost:${pod.webServer.port}$path'));
}

/// Creates a temporary directory, deleted when the running test completes.
Future<Directory> _createTempDirectory() async {
  final directory = await Directory.systemTemp.createTemp(
    'cache_control_environment_test_',
  );
  addTearDown(() => directory.delete(recursive: true));
  return directory;
}

/// Creates a not yet started web server serving `test.txt` and `index.html`
/// from a temporary directory. Both are cleaned up when the test completes.
Future<_FileServer> _createFileServer() async {
  final directory = await _createTempDirectory();
  await File(p.join(directory.path, 'test.txt')).writeAsString('Hello, World!');
  await File(
    p.join(directory.path, 'index.html'),
  ).writeAsString('<html><body>Index</body></html>');

  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  final pod = Serverpod(
    [],
    internal.Protocol(),
    _EmptyEndpoints(),
    config: ServerpodConfig(
      apiServer: portZeroConfig,
      webServer: portZeroConfig,
    ),
  );
  addTearDown(() => pod.shutdown(exitProcess: false));

  return _FileServer(pod, directory);
}

/// Reruns the test named [testName] in a nested `dart test` process that has
/// the [variable] environment variable set to [value], since the environment
/// of a running process cannot be changed.
///
/// Returns `true` when the test ran nested, in which case the calling test
/// should return immediately, and `false` when the environment is already set
/// and the test body should run.
Future<bool> _rerunWithCacheControlEnvironment({
  required String testName,
  required String variable,
  required String value,
}) async {
  if (Platform.environment[variable] == value) {
    return false;
  }

  final result = await Process.run(
    Platform.resolvedExecutable,
    ['test', '--plain-name', testName, _testFilePath],
    workingDirectory: Directory.current.path,
    environment: {variable: value},
  );

  expect(
    result.exitCode,
    0,
    reason:
        'Nested test failed.\nstdout:\n${result.stdout}\nstderr:\n${result.stderr}',
  );
  return true;
}
