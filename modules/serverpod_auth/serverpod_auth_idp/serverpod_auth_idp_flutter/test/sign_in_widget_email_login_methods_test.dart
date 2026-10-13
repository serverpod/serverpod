import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'email_auth_test_utils.dart';

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
  group('Given a SignInWidget with the email endpoint', () {
    testWidgets(
      'when no custom email widget is given, '
      'then the email widget is shown with the password login method.',
      (tester) async {
        await _pump(tester, SignInWidget(client: EmailTestClient()));

        final emailWidget = tester.widget<EmailSignInWidget>(
          find.byType(EmailSignInWidget),
        );
        expect(emailWidget.loginMethods, EmailLoginMethods.password);
      },
    );

    testWidgets(
      'when a custom email widget with the passwordless login method is '
      'given, '
      'then the passwordless login is shown.',
      (tester) async {
        final client = EmailTestClient();

        await _pump(
          tester,
          SignInWidget(
            client: client,
            emailSignInWidget: EmailSignInWidget(
              client: client,
              loginMethods: EmailLoginMethods.passwordless,
            ),
          ),
        );

        expect(find.byType(EmailSignInWidget), findsOneWidget);
        expect(find.text('Continue with email'), findsOneWidget);
      },
    );

    testWidgets(
      'when a custom email widget with both login methods is given, '
      'then the login screen links to the passwordless login.',
      (tester) async {
        final client = EmailTestClient();

        await _pump(
          tester,
          SignInWidget(
            client: client,
            emailSignInWidget: EmailSignInWidget(
              client: client,
              startScreen: EmailFlowScreen.login,
              loginMethods: EmailLoginMethods.both,
            ),
          ),
        );

        expect(find.text('Sign in with a code instead'), findsOneWidget);
      },
    );

    testWidgets(
      'when the email widget is disabled, '
      'then no email widget is shown.',
      (tester) async {
        await _pump(
          tester,
          SignInWidget(
            client: EmailTestClient(),
            disableEmailSignInWidget: true,
          ),
        );

        expect(find.byType(EmailSignInWidget), findsNothing);
      },
    );
  });
}
