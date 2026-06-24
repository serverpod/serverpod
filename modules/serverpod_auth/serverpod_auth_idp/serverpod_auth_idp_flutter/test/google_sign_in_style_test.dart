import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

void main() {
  group('Given GoogleSignInStyle.fromConfiguration', () {
    test('when no border radius is given then the shape determines it', () {
      final style = GoogleSignInStyle.fromConfiguration(
        theme: GSIButtonTheme.outline,
        shape: GSIButtonShape.rectangular,
        size: GSIButtonSize.large,
        width: 240,
      );

      expect(style.borderRadius, BorderRadius.circular(4));
    });

    test(
      'when a border radius override is given then it wins over the shape',
      () {
        final style = GoogleSignInStyle.fromConfiguration(
          theme: GSIButtonTheme.outline,
          // Pill would normally resolve to height/2; the override must win so the
          // native button can render shapes the web GSIButtonShape lacks.
          shape: GSIButtonShape.pill,
          size: GSIButtonSize.large,
          width: 240,
          borderRadius: BorderRadius.circular(8),
        );

        expect(style.borderRadius, BorderRadius.circular(8));
      },
    );
  });
}
