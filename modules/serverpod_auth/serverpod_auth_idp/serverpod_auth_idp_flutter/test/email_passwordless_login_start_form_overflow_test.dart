import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'email_auth_test_utils.dart';

const _longNotice =
    'By continuing you agree to the terms of service, the privacy policy, '
    'the acceptable use policy, the data processing agreement and the cookie '
    'policy of this application, and you confirm that you are at least the '
    'minimum age required in your country to create an account. We may send '
    'you service emails about your account that you can not opt out of, and '
    'you can withdraw your consent at any time in the settings.';

Widget _host(Widget child, {required double width}) {
  return MaterialApp(
    home: Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: width,
          child: SignInLocalizationProvider(child: child),
        ),
      ),
    ),
  );
}

void main() {
  // These tests intentionally run at the default text scale of the test
  // environment, in a narrow layout.
  for (final width in [320.0, 360.0]) {
    testWidgets(
      'Given a long consent notice and a $width px wide layout, '
      'when the start form is built, '
      'then nothing overflows and the whole notice can be scrolled to.',
      (tester) async {
        final controller = EmailAuthController(
          client: EmailTestClient(),
          startScreen: EmailFlowScreen.passwordlessStart,
        );
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _host(
            width: width,
            EmailSignInWidget(
              controller: controller,
              consentNotice: const Text(_longNotice),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text(_longNotice, skipOffstage: false), findsOneWidget);

        await tester.scrollUntilVisible(
          find.text(_longNotice),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'Given a long localized description and the terms checkbox, '
    'when the start form is built in a narrow layout, '
    'then nothing overflows.',
    (tester) async {
      final controller = EmailAuthController(
        client: EmailTestClient(),
        startScreen: EmailFlowScreen.passwordlessStart,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _host(
          width: 360,
          SignInLocalizationProvider(
            email: EmailSignInTexts.defaults.copyWith(
              passwordlessDescription: _longNotice,
            ),
            child: EmailSignInWidget(
              controller: controller,
              onTermsAndConditionsPressed: () {},
              onPrivacyPolicyPressed: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );

  for (final width in [270.0, 360.0]) {
    testWidgets(
      'Given both login methods and a $width px wide layout, '
      'when the login form is built, '
      'then nothing overflows and both links are shown.',
      (tester) async {
        // The glyphs of the test font are wider than real ones, so this scale
        // is closer to real text. The links wrap to two lines at this width.
        tester.platformDispatcher.textScaleFactorTestValue = 0.6;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(
          _host(
            width: width,
            EmailSignInWidget(
              client: EmailTestClient(),
              startScreen: EmailFlowScreen.login,
              loginMethods: EmailLoginMethods.both,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Sign in with a code instead'), findsOneWidget);
        expect(find.text('Forgot password?'), findsOneWidget);
      },
    );
  }
}
