import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/util/package_version.dart';
import 'package:test/test.dart';

void main() {
  var versionForTest = Version(1, 1, 0);

  group('Given version is returned from load', () {
    test(
        'when fetched with "valid until" time in the future then version is returned.',
        () async {
      var packageVersionData = PackageVersionData(
        versionForTest,
        DateTime.now().add(const Duration(hours: 1)),
      );

      var fetchedVersion = await PackageVersion.fetchLatestPackageVersion(
        storePackageVersionData: (PackageVersionData _) async => (),
        loadPackageVersionData: () async => packageVersionData,
        fetchLatestPackageVersion: () async => null,
      );

      expect(fetchedVersion, isNotNull);
      expect(fetchedVersion, versionForTest);
    });

    group('with "valid until" already passed', () {
      test(
          'when successful in fetching latest version from fetch then new version is stored and returned.',
          () async {
        PackageVersionData? storedPackageVersion;
        PackageVersionData packageVersionData = PackageVersionData(
          versionForTest,
          DateTime.now().subtract(
            const Duration(hours: 1),
          ),
        );
        var pubDevVersion = versionForTest.nextMajor;

        var fetchedVersion = await PackageVersion.fetchLatestPackageVersion(
          storePackageVersionData:
              (PackageVersionData versionDataToStore) async =>
                  (storedPackageVersion = versionDataToStore),
          loadPackageVersionData: () async => packageVersionData,
          fetchLatestPackageVersion: () async => pubDevVersion,
        );

        expect(fetchedVersion, isNotNull);
        expect(fetchedVersion, pubDevVersion);
        expect(storedPackageVersion, isNotNull);
        expect(storedPackageVersion?.version, pubDevVersion);
        var timeDifferent = storedPackageVersion?.validUntil.difference(
            DateTime.now()
                .add(PackageVersionConstants.localStorageValidityTime));
        expect(
          timeDifferent,
          lessThan(const Duration(minutes: 1)),
          reason: 'Successfully stored version should have a valid until time '
              'close to the current time plus the validity time.',
        );
      });

      test('when failing to fetch latest then null is returned.', () async {
        PackageVersionData? storedPackageVersion;
        var version = await PackageVersion.fetchLatestPackageVersion(
          storePackageVersionData:
              (PackageVersionData packageVersionData) async =>
                  (storedPackageVersion = packageVersionData),
          loadPackageVersionData: () async => null,
          fetchLatestPackageVersion: () async => null,
        );

        expect(version, isNull);
        expect(storedPackageVersion, isNotNull);
        var timeDifferent = storedPackageVersion?.validUntil.difference(
            DateTime.now()
                .add(PackageVersionConstants.badConnectionRetryTimeout));
        expect(
          timeDifferent,
          lessThan(const Duration(minutes: 1)),
          reason: 'Failed fetch stored version should have a valid until time '
              'close to the current time plus the bad connection retry timeout.',
        );
      });
    });
  });

  group('Given no version is returned from load', () {
    test(
        'when successful in fetching latest version then version is stored and returned.',
        () async {
      PackageVersionData? storedPackageVersion;
      var version = await PackageVersion.fetchLatestPackageVersion(
        storePackageVersionData:
            (PackageVersionData packageVersionData) async =>
                (storedPackageVersion = packageVersionData),
        loadPackageVersionData: () async => null,
        fetchLatestPackageVersion: () async => versionForTest,
      );

      expect(version, isNotNull);
      expect(version, versionForTest);
      expect(storedPackageVersion, isNotNull);
      expect(storedPackageVersion?.version, versionForTest);
      var timeDifferent = storedPackageVersion?.validUntil.difference(
          DateTime.now().add(PackageVersionConstants.localStorageValidityTime));
      expect(
        timeDifferent,
        lessThan(const Duration(minutes: 1)),
        reason: 'Successfully stored version should have a valid until time '
            'close to the current time plus the validity time.',
      );
    });

    test(
        'when failing to fetch latest then timeout is stored and null is returned.',
        () async {
      PackageVersionData? storedPackageVersion;
      var version = await PackageVersion.fetchLatestPackageVersion(
        storePackageVersionData:
            (PackageVersionData packageVersionData) async =>
                (storedPackageVersion = packageVersionData),
        loadPackageVersionData: () async => null,
        fetchLatestPackageVersion: () async => null,
      );

      expect(version, isNull);
      expect(storedPackageVersion, isNotNull);
      var timeDifferent = storedPackageVersion?.validUntil.difference(
          DateTime.now()
              .add(PackageVersionConstants.badConnectionRetryTimeout));
      expect(
        timeDifferent,
        lessThan(const Duration(minutes: 1)),
        reason: 'Failed fetch stored version should have a valid until time '
            'close to the current time plus the bad connection retry timeout.',
      );
    });
  });
}
