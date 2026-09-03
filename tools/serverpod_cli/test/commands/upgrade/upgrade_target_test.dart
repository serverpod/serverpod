import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade/upgrade_target.dart';
import 'package:test/test.dart';

void main() {
  final stable = Version.parse('3.4.11');
  final newerStable = Version.parse('3.4.12');
  final prerelease = Version.parse('4.0.0-beta.3');
  final newerPrerelease = Version.parse('4.0.0-beta.4');
  final published = [stable, newerStable, prerelease, newerPrerelease];

  group('Given a stable installation,', () {
    test(
      'when resolving the target on the auto channel, '
      'then the newest stable version is selected',
      () {
        final target = resolveUpgradeTarget(
          current: stable,
          published: published,
          channel: UpgradeChannel.forVersion(stable),
        )!;

        expect(target.action, UpgradeAction.install);
        expect(target.version, newerStable);
      },
    );

    test(
      'when resolving the target on the any channel, '
      'then the newest prerelease is selected',
      () {
        final target = resolveUpgradeTarget(
          current: stable,
          published: published,
          channel: UpgradeChannel.any,
        )!;

        expect(target.action, UpgradeAction.install);
        expect(target.version, newerPrerelease);
      },
    );
  });

  group('Given a prerelease installation,', () {
    test(
      'when resolving the target on the auto channel, '
      'then the newest prerelease is selected',
      () {
        final target = resolveUpgradeTarget(
          current: prerelease,
          published: published,
          channel: UpgradeChannel.forVersion(prerelease),
        )!;

        expect(target.action, UpgradeAction.install);
        expect(target.version, newerPrerelease);
      },
    );

    test(
      'when the newest stable version is older than the installed prerelease, '
      'then the downgrade is blocked',
      () {
        final target = resolveUpgradeTarget(
          current: prerelease,
          published: published,
          channel: UpgradeChannel.stable,
        )!;

        expect(target.action, UpgradeAction.downgradeBlocked);
        expect(target.version, newerStable);
      },
    );
  });

  group('Given the installed version is the newest published version,', () {
    test('when resolving the target, then it is reported as up to date', () {
      final target = resolveUpgradeTarget(
        current: newerPrerelease,
        published: published,
        channel: UpgradeChannel.forVersion(newerPrerelease),
      )!;

      expect(target.action, UpgradeAction.upToDate);
      expect(target.version, newerPrerelease);
    });
  });

  group('Given a requested version,', () {
    test(
      'when the requested version is older than the installed one, '
      'then the downgrade is allowed',
      () {
        final target = resolveUpgradeTarget(
          current: newerPrerelease,
          published: published,
          channel: UpgradeChannel.forVersion(newerPrerelease),
          requested: newerStable,
        )!;

        expect(target.action, UpgradeAction.install);
        expect(target.version, newerStable);
      },
    );

    test(
      'when the requested version is a prerelease on a stable channel, '
      'then the prerelease is selected',
      () {
        final target = resolveUpgradeTarget(
          current: stable,
          published: published,
          channel: UpgradeChannel.stable,
          requested: newerPrerelease,
        )!;

        expect(target.action, UpgradeAction.install);
        expect(target.version, newerPrerelease);
      },
    );

    test(
      'when the requested version is not published, '
      'then there is no candidate',
      () {
        final target = resolveUpgradeTarget(
          current: newerPrerelease,
          published: published,
          channel: UpgradeChannel.forVersion(newerPrerelease),
          requested: Version.parse('9.0.0'),
        );

        expect(target, isNull);
      },
    );
  });

  group('Given published versions in publication order,', () {
    test(
      'when a patch release was published after a prerelease, '
      'then the newest version by semver is selected',
      () {
        final target = resolveUpgradeTarget(
          current: stable,
          published: [newerPrerelease, newerStable, stable],
          channel: UpgradeChannel.forVersion(stable),
        )!;

        expect(target.action, UpgradeAction.install);
        expect(target.version, newerStable);
      },
    );
  });

  group('Given no channel was requested,', () {
    test(
      'when the installed version is stable, then stable versions are tracked',
      () {
        expect(UpgradeChannel.forVersion(stable), UpgradeChannel.stable);
      },
    );

    test(
      'when the installed version is a prerelease, '
      'then prereleases are tracked',
      () {
        expect(UpgradeChannel.forVersion(prerelease), UpgradeChannel.any);
      },
    );
  });
}
