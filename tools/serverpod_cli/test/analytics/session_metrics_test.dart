import 'package:serverpod_cli/src/analytics/session_metrics.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given representative Flutter device identifiers, '
    'when they are categorized for analytics, '
    'then every device category and platform tag is produced.',
    () {
      final cases = <({String? device, String category, String platform})>[
        (device: null, category: 'default', platform: 'default'),
        (device: 'ios', category: 'mobile', platform: 'ios'),
        (device: 'ipad-pro', category: 'mobile', platform: 'ipad'),
        (device: 'android-emulator', category: 'mobile', platform: 'android'),
        (device: 'macos', category: 'desktop', platform: 'macos'),
        (device: 'windows', category: 'desktop', platform: 'windows'),
        (device: 'linux', category: 'desktop', platform: 'linux'),
        (device: 'chrome', category: 'web', platform: 'chrome'),
        (device: 'edge', category: 'web', platform: 'edge'),
        (device: 'web-server', category: 'web', platform: 'web-server'),
        (device: 'headless-runner', category: 'headless', platform: 'other'),
        (device: 'custom-device', category: 'other', platform: 'other'),
      ];

      final categories = <String>{};
      final platforms = <String>{};

      for (final entry in cases) {
        final buckets = categorizeFlutterDevice(entry.device);
        expect(
          (category: buckets.category, platform: buckets.platform),
          (category: entry.category, platform: entry.platform),
          reason: 'Unexpected buckets for device "${entry.device}".',
        );
        categories.add(buckets.category);
        platforms.add(buckets.platform);
      }

      expect(categories, flutterDeviceCategories);
      expect(platforms, flutterDevicePlatforms);
    },
  );
}
