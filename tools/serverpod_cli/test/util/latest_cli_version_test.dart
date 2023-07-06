import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/downloads/resource_manager_constants.dart';
import 'package:serverpod_cli/src/util/latest_cli_version.dart';
import 'package:test/test.dart';

import 'latest_cli_version_test.mocks.dart';

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

@GenerateMocks([http.Client])
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
      LocalStorageService(optionalLocalStoragePath: testStorageFolderPath);

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
    var storedArtefact = LatestCliVersionArtefact(version, validUntil);

    await resourceManager.storeLatestCliVersion(storedArtefact,
        localStoragePath: testStorageFolderPath);
    var file = File(p.join(
        testStorageFolderPath, ResourceManagerConstants.latestVersionFilePath));

    expect(file.existsSync(), isTrue);
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
        var client = MockClient();
        when(client.get(Uri.parse(LatestCliVersionConstants.pubDevUri)))
            .thenAnswer(
          (_) async => http.Response(_getPubDevResponse(pubDevVersion), 200),
        );

        var fetchedVersion = await tryFetchLatestValidCliVersion(
            localStorageService: testStorageService,
            pubDevService: getTestPubDevService(client));

        expect(fetchedVersion, isNotNull);
        expect(fetchedVersion, pubDevVersion);
      });

      test('when failed to fetch latest version from pub.dev.', () async {
        var client = MockClient();
        when(client.get(
          Uri.parse(LatestCliVersionConstants.pubDevUri),
        )).thenAnswer(
          (_) async => http.Response('', 404),
        );

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
        var client = MockClient();
        when(client.get(Uri.parse(LatestCliVersionConstants.pubDevUri)))
            .thenAnswer((_) async {
          await Future.delayed(timeout * 10);
          return http.Response(_getPubDevResponse(fetchedVersion), 200);
        });

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
      var client = MockClient();
      when(client.get(Uri.parse(LatestCliVersionConstants.pubDevUri)))
          .thenAnswer((_) async =>
              http.Response(_getPubDevResponse(versionForTest), 200));

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
      var client = MockClient();
      when(client.get(Uri.parse(LatestCliVersionConstants.pubDevUri)))
          .thenAnswer((_) async => http.Response('', 404));

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
