import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_flutter/src/localhost.dart';

void main() {
  test('returns 10.0.2.2 on Android apps', () {
    try {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      expect(localhost, '10.0.2.2');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  test('returns localhost on other platforms', () {
    try {
      final nonAndroidPlatforms = TargetPlatform.values.toList()
        ..removeWhere((platform) => platform == TargetPlatform.android);
      for (final testPlatform in nonAndroidPlatforms) {
        debugDefaultTargetPlatformOverride = testPlatform;

        expect(localhost, 'localhost');
      }
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
