import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/src/google/common/button.dart';
import 'package:serverpod_auth_idp_flutter/src/google/common/style.dart';

void main() {
  group('GoogleSignInWebButton wrappers', () {
    test('resolveWebButtonWrapper maps native wrappers to web wrappers', () {
      expect(
        GoogleSignInBaseButton.resolveWebButtonWrapper(
          GoogleSignInBaseButton.wrapAsOutline,
        ),
        GoogleSignInBaseButton.wrapAsOutlineWeb,
      );
      expect(
        GoogleSignInBaseButton.resolveWebButtonWrapper(
          GoogleSignInBaseButton.wrapAsFilled,
        ),
        GoogleSignInBaseButton.wrapAsFilledWeb,
      );
      expect(
        GoogleSignInBaseButton.resolveWebButtonWrapper(
          GoogleSignInBaseButton.wrapAsElevated,
        ),
        GoogleSignInBaseButton.wrapAsElevatedWeb,
      );
    });

    test('resolveWebButtonWrapper defaults to wrapAsOutlineWeb', () {
      expect(
        GoogleSignInBaseButton.resolveWebButtonWrapper(null),
        GoogleSignInBaseButton.wrapAsOutlineWeb,
      );
    });

    test('resolveWebButtonWrapper passes through custom wrappers', () {
      Widget customWrapper({
        required GoogleSignInStyle style,
        required Widget child,
        required VoidCallback? onPressed,
      }) {
        return child;
      }

      expect(
        GoogleSignInBaseButton.resolveWebButtonWrapper(customWrapper),
        customWrapper,
      );
    });

    testWidgets('web wrappers clip the GIS iframe behind a single border', (
      tester,
    ) async {
      const style = GoogleSignInStyle(
        size: Size(240, 40),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoogleSignInBaseButton.wrapAsOutlineWeb(
              style: style,
              onPressed: null,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsNothing);
      expect(find.byType(FilledButton), findsNothing);
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(DecoratedBox), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(OverflowBox), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
    });
  });
}
