import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_flutter/src/localhost.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test(
    'Given target platform is android when reading localhost then 10.0.2.2 is returned',
    () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      expect(localhost, '10.0.2.2');
    },
  );

  final nonAndroidPlatforms = TargetPlatform.values.toList()
    ..removeWhere((platform) => platform == TargetPlatform.android);

  for (final testPlatform in nonAndroidPlatforms) {
    test(
      'Given non-android target platform "${testPlatform.name}" when reading localhost then localhost is returned',
      () {
        debugDefaultTargetPlatformOverride = testPlatform;

        expect(localhost, 'localhost');
      },
    );
  }
}
