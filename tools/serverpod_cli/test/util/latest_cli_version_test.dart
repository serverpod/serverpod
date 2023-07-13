import 'dart:io';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/downloads/resource_manager_constants.dart';
import 'package:serverpod_cli/src/util/latest_cli_version.dart';
import 'package:test/test.dart';

String _getPubDevResponse(Version version) {
  return '''
{
    "name": "serverpod_cli",
    "latest": {
        "version": "$version"
    }
}
''';
}

void main() {
  var testStorageFolderPath = p.join(
    'test',
    'util',
    'test_assets',
    'temp_latest_cli_version',
  );

  tearDown(() {
    var directory = Directory(testStorageFolderPath);
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
  });

  var testStorageService =
      CliVersionStorageService(optionalLocalStoragePath: testStorageFolderPath);

  PubDevService getTestPubDevService(
    http.Client testClient, {
    Duration timeout = LatestCliVersionConstants.pubDevConnectionTimeout,
  }) {
    return PubDevService(
      optionalLocalStoragePath: testStorageFolderPath,
      client: testClient,
      timeout: timeout,
    );
  }

  void storeVersionOnDisk(
    Version version,
    DateTime validUntil,
  ) async {
    var storedArtefact = CliVersionData(version, validUntil);

    await resourceManager.storeLatestCliVersion(storedArtefact,
        localStoragePath: testStorageFolderPath);
    var file = File(p.join(
        testStorageFolderPath, ResourceManagerConstants.latestVersionFilePath));

    expect(file.existsSync(), isTrue);
  }

  MockClient createMockClient({
    required String body,
    required int status,
    Duration responseDelay = const Duration(seconds: 0),
  }) {
    return MockClient((request) {
      if (request.method != 'GET') throw NoSuchMethodError;
      return Future<Response>(() async {
        await Future.delayed(responseDelay);
        return http.Response(body, HttpStatus.ok);
      });
    });
  }

  var versionForTest = Version(1, 1, 0);

  group('Stored version on disk', () {
    test('fetched with "valid until" time in the future.', () async {
      storeVersionOnDisk(
          versionForTest, DateTime.now().add(const Duration(hours: 1)));

      var fetchedVersion = await tryFetchLatestValidCliVersion(
          localStorageService: testStorageService);

      expect(fetchedVersion, isNotNull);
      expect(fetchedVersion, versionForTest);
    });

    group('with "valid until" already passed', () {
      setUp(() {
        storeVersionOnDisk(
            versionForTest,
            DateTime.now().subtract(
              const Duration(hours: 1),
            ));
      });

      test('when successful in fetching latest version from pub.dev.',
          () async {
        var pubDevVersion = versionForTest.nextMajor;
        var client = createMockClient(
          body: _getPubDevResponse(pubDevVersion),
          status: HttpStatus.ok,
        );

        var fetchedVersion = await tryFetchLatestValidCliVersion(
            localStorageService: testStorageService,
            pubDevService: getTestPubDevService(client));

        expect(fetchedVersion, isNotNull);
        expect(fetchedVersion, pubDevVersion);
      });

      test('when failed to fetch latest version from pub.dev.', () async {
        var client = createMockClient(body: '', status: HttpStatus.notFound);

        var version = await tryFetchLatestValidCliVersion(
            localStorageService: testStorageService,
            pubDevService: getTestPubDevService(client));

        expect(version, isNull);
      });

      test('when timeout is reached fetching latest version from pub.dev.',
          () async {
        var fetchedVersion = versionForTest.nextMajor;
        var timeout = const Duration(milliseconds: 1);
        storeVersionOnDisk(
            versionForTest, DateTime.now().subtract(const Duration(hours: 1)));
        var client = createMockClient(
          body: _getPubDevResponse(fetchedVersion),
          status: HttpStatus.ok,
          responseDelay:
              timeout * 10, // Messaged is delayed longer than the timeout
        );

        var version = await tryFetchLatestValidCliVersion(
          localStorageService: testStorageService,
          pubDevService: getTestPubDevService(client, timeout: timeout),
        );

        expect(version, isNull);
      });
    });
  });

  group('No file on disk', () {
    test('when successful in fetching latest version from pub.dev.', () async {
      var client = createMockClient(
        body: _getPubDevResponse(versionForTest),
        status: HttpStatus.ok,
      );

      var version = await tryFetchLatestValidCliVersion(
          localStorageService: testStorageService,
          pubDevService: getTestPubDevService(
            client,
          ));

      expect(version, isNotNull);
      expect(version, versionForTest);
      var localStorageFile = File(p.join(testStorageFolderPath,
          ResourceManagerConstants.latestVersionFilePath));
      expect(localStorageFile.existsSync(), isTrue);
    });

    test('when failed to fetch latest version from pub.dev.', () async {
      var client = createMockClient(
        body: '',
        status: HttpStatus.notFound,
      );

      var version = await tryFetchLatestValidCliVersion(
          localStorageService: testStorageService,
          pubDevService: getTestPubDevService(client));

      expect(version, isNull);
      var localStorageFile = File(p.join(testStorageFolderPath,
          ResourceManagerConstants.latestVersionFilePath));
      expect(localStorageFile.existsSync(), isTrue);
    });
  });
}
