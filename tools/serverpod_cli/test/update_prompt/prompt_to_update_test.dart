import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade/upgrade_target.dart';
import 'package:serverpod_cli/src/update_prompt/prompt_to_update.dart';
import 'package:test/test.dart';

void main() {
  group('Given a prerelease installation and a newer stable release,', () {
    test(
      'when the prompt names a version, '
      'then upgrading installs the version it named',
      () {
        final current = Version.parse('4.0.0-rc.1');
        final newestStable = Version.parse('4.0.0');
        final newestPrerelease = Version.parse('4.1.0-beta.1');
        final published = [
          Version.parse('3.4.12'),
          newestStable,
          newestPrerelease,
        ];

        final prompted = latestVersionToPrompt(current, published);

        final target = resolveUpgradeTarget(
          current: current,
          published: published,
          channel: UpgradeChannel.forVersion(current),
        )!;

        expect(prompted, target.version);
        expect(prompted, newestPrerelease);
        expect(current < prompted!, isTrue);
      },
    );
  });
}
