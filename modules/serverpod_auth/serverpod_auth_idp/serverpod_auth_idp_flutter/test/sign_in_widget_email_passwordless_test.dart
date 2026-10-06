import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'email_passwordless_test_utils.dart';

Future<void> _pump(WidgetTester tester, SignInWidget widget) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  // The glyphs of the test font are wider than real ones.
  tester.platformDispatcher.textScaleFactorTestValue = 0.6;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
}

void main() {
  group('Given AvailableIdps', () {
    test(
      'when only the passwordless endpoint is registered, '
      'then hasEmailPasswordless is true, hasEmail is false and it is counted.',
      () {
        final idps = PasswordlessTestClient().auth.idp;

        expect(idps.hasEmailPasswordless, isTrue);
        expect(idps.hasEmail, isFalse);
        expect(idps.count, 1);
        expect(idps.hasAny, isTrue);
      },
    );

    test(
      'when only the email endpoint is registered, '
      'then hasEmailPasswordless is false.',
      () {
        final idps = PasswordlessTestClient(
          withPasswordless: false,
          withEmail: true,
        ).auth.idp;

        expect(idps.hasEmailPasswordless, isFalse);
        expect(idps.hasEmail, isTrue);
      },
    );

    test(
      'when both endpoints are registered, '
      'then both are available and counted separately.',
      () {
        final idps = PasswordlessTestClient(withEmail: true).auth.idp;

        expect(idps.hasEmailPasswordless, isTrue);
        expect(idps.hasEmail, isTrue);
        expect(idps.count, 2);
      },
    );
  });

  group('Given a SignInWidget', () {
    testWidgets(
      'when only the passwordless endpoint is registered, '
      'then the passwordless widget is shown.',
      (tester) async {
        await _pump(tester, SignInWidget(client: PasswordlessTestClient()));

        expect(find.byType(EmailPasswordlessSignInWidget), findsOneWidget);
        expect(find.byType(EmailSignInWidget), findsNothing);
      },
    );

    testWidgets(
      'when only the email endpoint is registered, '
      'then the email and password widget is shown.',
      (tester) async {
        await _pump(
          tester,
          SignInWidget(
            client: PasswordlessTestClient(
              withPasswordless: false,
              withEmail: true,
            ),
          ),
        );

        expect(find.byType(EmailSignInWidget), findsOneWidget);
        expect(find.byType(EmailPasswordlessSignInWidget), findsNothing);
      },
    );

    testWidgets(
      'when both endpoints are registered, '
      'then only the email and password widget is shown by default.',
      (tester) async {
        await _pump(
          tester,
          SignInWidget(client: PasswordlessTestClient(withEmail: true)),
        );

        expect(find.byType(EmailSignInWidget), findsOneWidget);
        expect(find.byType(EmailPasswordlessSignInWidget), findsNothing);
      },
    );

    testWidgets(
      'when both endpoints are registered and the email widget is disabled, '
      'then the passwordless widget is shown instead.',
      (tester) async {
        await _pump(
          tester,
          SignInWidget(
            client: PasswordlessTestClient(withEmail: true),
            disableEmailSignInWidget: true,
          ),
        );

        expect(find.byType(EmailPasswordlessSignInWidget), findsOneWidget);
        expect(find.byType(EmailSignInWidget), findsNothing);
      },
    );

    testWidgets(
      'when both endpoints are registered and a custom passwordless widget '
      'is given without a custom email widget, '
      'then the custom passwordless widget is shown instead.',
      (tester) async {
        final client = PasswordlessTestClient(withEmail: true);
        final custom = EmailPasswordlessSignInWidget(
          client: client,
          key: const ValueKey('custom'),
        );

        await _pump(
          tester,
          SignInWidget(client: client, emailPasswordlessSignInWidget: custom),
        );

        expect(find.byKey(const ValueKey('custom')), findsOneWidget);
        expect(find.byType(EmailSignInWidget), findsNothing);
      },
    );

    testWidgets(
      'when the passwordless endpoint is registered and its widget is '
      'disabled, '
      'then no sign-in option is shown.',
      (tester) async {
        await _pump(
          tester,
          SignInWidget(
            client: PasswordlessTestClient(),
            disableEmailPasswordlessSignInWidget: true,
          ),
        );

        expect(find.byType(EmailPasswordlessSignInWidget), findsNothing);
        expect(find.byType(EmailSignInWidget), findsNothing);
      },
    );

    testWidgets(
      'when both endpoints are registered and the passwordless widget is '
      'disabled, '
      'then the email and password widget is shown.',
      (tester) async {
        await _pump(
          tester,
          SignInWidget(
            client: PasswordlessTestClient(withEmail: true),
            disableEmailPasswordlessSignInWidget: true,
          ),
        );

        expect(find.byType(EmailSignInWidget), findsOneWidget);
        expect(find.byType(EmailPasswordlessSignInWidget), findsNothing);
      },
    );
  });
}
