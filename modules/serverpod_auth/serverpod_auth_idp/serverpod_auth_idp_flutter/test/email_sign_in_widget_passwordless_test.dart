import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as idp;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';

import 'email_auth_test_utils.dart';

/// Wraps the child in a layout that fits the fixed height forms when rendered
/// with the wide glyphs of the test font.
Widget _host(Widget child, {SignInLocalizationProvider? localization}) {
  return MaterialApp(
    home: Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: localization ?? SignInLocalizationProvider(child: child),
          ),
        ),
      ),
    ),
  );
}

Finder _continueButton() => find.widgetWithText(ElevatedButton, 'Send code');

Future<void> _enterEmail(WidgetTester tester, String email) async {
  await tester.enterText(find.byType(TextField), email);
  // The controller debounces the email validation before updating the UI.
  await tester.pump(const Duration(milliseconds: 600));
}

Future<void> _startLogin(WidgetTester tester) async {
  await _enterEmail(tester, 'user@example.com');
  await tester.tap(_continueButton());
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.textScaleFactorTestValue = 0.8;
    addTearDown(binding.platformDispatcher.clearTextScaleFactorTestValue);
  });

  testWidgets(
    'Given the widget, '
    'when it is built, '
    'then the email entry form is shown with a disabled continue button.',
    (tester) async {
      final client = EmailTestClient();
      await tester.pumpWidget(
        _host(
          EmailSignInWidget(
            client: client,
            loginMethods: EmailLoginMethods.passwordless,
          ),
        ),
      );

      expect(find.text('Continue with email'), findsOneWidget);
      expect(find.byType(EmailTextField), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(_continueButton()).onPressed,
        isNull,
      );
    },
  );

  testWidgets(
    'Given an email address, '
    'when the continue button is tapped, '
    'then a code is requested and the verification form is shown.',
    (tester) async {
      final client = EmailTestClient();
      await tester.pumpWidget(
        _host(
          EmailSignInWidget(
            client: client,
            loginMethods: EmailLoginMethods.passwordless,
          ),
        ),
      );

      await _startLogin(tester);

      expect(client.email!.startedEmails, ['user@example.com']);
      expect(find.text('Enter your code'), findsOneWidget);
      expect(find.byType(VerificationForm), findsOneWidget);
      expect(find.byType(ResendCodeButton), findsOneWidget);
    },
  );

  testWidgets(
    'Given the verification form, '
    'when the 6 digit code is entered, '
    'then the login is finished and onAuthenticated is called.',
    (tester) async {
      final client = EmailTestClient();
      var authenticated = 0;
      await tester.pumpWidget(
        _host(
          EmailSignInWidget(
            client: client,
            loginMethods: EmailLoginMethods.passwordless,
            onAuthenticated: () => authenticated++,
          ),
        ),
      );
      await _startLogin(tester);

      await tester.enterText(find.byType(EditableText).first, '123456');
      await tester.pumpAndSettle();

      final finished = client.email!.finishedRequests.single;
      expect(finished.code, '123456');
      expect(finished.id, client.email!.nextRequestId);
      expect(authenticated, 1);
    },
  );

  testWidgets(
    'Given the verification form, '
    'when a letter is typed in the code input, '
    'then it is filtered out as the default code has digits only.',
    (tester) async {
      final client = EmailTestClient();
      await tester.pumpWidget(
        _host(
          EmailSignInWidget(
            client: client,
            loginMethods: EmailLoginMethods.passwordless,
          ),
        ),
      );
      await _startLogin(tester);

      await tester.enterText(find.byType(EditableText).first, 'ab12');
      await tester.pump();

      expect(find.byType(VerificationCodeInput), findsOneWidget);
      final input = tester.widget<VerificationCodeInput>(
        find.byType(VerificationCodeInput),
      );
      expect(input.verificationCodeController.text, '12');
      expect(input.length, 6);
    },
  );

  testWidgets(
    'Given the verification form, '
    'when the use a different email button is tapped, '
    'then the email entry form is shown again.',
    (tester) async {
      final client = EmailTestClient();
      await tester.pumpWidget(
        _host(
          EmailSignInWidget(
            client: client,
            loginMethods: EmailLoginMethods.passwordless,
          ),
        ),
      );
      await _startLogin(tester);

      await tester.tap(find.text('Use a different email'));
      await tester.pumpAndSettle();

      expect(find.text('Continue with email'), findsOneWidget);
      expect(find.byType(VerificationForm), findsNothing);
    },
  );

  testWidgets(
    'Given a wrong code, '
    'when the server rejects it, '
    'then onError receives a user facing message and the form stays.',
    (tester) async {
      final client = EmailTestClient();
      final errors = <Object>[];
      await tester.pumpWidget(
        _host(
          EmailSignInWidget(
            client: client,
            loginMethods: EmailLoginMethods.passwordless,
            onError: errors.add,
          ),
        ),
      );
      await _startLogin(tester);
      client.email!.finishError = idp.EmailPasswordlessLoginException(
        reason: idp.EmailPasswordlessLoginExceptionReason.invalid,
      );

      await tester.enterText(find.byType(EditableText).first, '111111');
      await tester.pumpAndSettle();

      expect(errors, hasLength(1));
      expect(errors.single.toString(), contains('Invalid verification code'));
      expect(find.byType(VerificationForm), findsOneWidget);
    },
  );

  testWidgets(
    'Given an external controller, '
    'when the widget is disposed, '
    'then the controller is not disposed with it.',
    (tester) async {
      final controller = EmailAuthController(
        client: EmailTestClient(),
        startScreen: EmailFlowScreen.passwordlessStart,
      );
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(EmailSignInWidget(controller: controller)),
      );

      await tester.pumpWidget(const SizedBox());

      expect(() => controller.addListener(() {}), returnsNormally);
    },
  );

  group('Given a consent notice', () {
    testWidgets(
      'when the widget has a consentNotice, '
      'then it is shown on the email entry form and does not block continuing.',
      (tester) async {
        final client = EmailTestClient();
        await tester.pumpWidget(
          _host(
            EmailSignInWidget(
              client: client,
              loginMethods: EmailLoginMethods.passwordless,
              consentNotice: const Text('By continuing you agree to the terms'),
            ),
          ),
        );

        expect(
          find.text('By continuing you agree to the terms'),
          findsOneWidget,
        );
        await _enterEmail(tester, 'user@example.com');
        expect(
          tester.widget<ElevatedButton>(_continueButton()).onPressed,
          isNotNull,
        );
      },
    );

    testWidgets(
      'when the widget has terms callbacks, '
      'then the checkbox must be checked before continuing.',
      (tester) async {
        final client = EmailTestClient();
        await tester.pumpWidget(
          _host(
            EmailSignInWidget(
              client: client,
              loginMethods: EmailLoginMethods.passwordless,
              onTermsAndConditionsPressed: () {},
              onPrivacyPolicyPressed: () {},
            ),
          ),
        );
        await _enterEmail(tester, 'user@example.com');
        expect(
          tester.widget<ElevatedButton>(_continueButton()).onPressed,
          isNull,
        );

        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        expect(
          tester.widget<ElevatedButton>(_continueButton()).onPressed,
          isNotNull,
        );
      },
    );

    testWidgets(
      'when the widget has both a consentNotice and terms callbacks, '
      'then only the consentNotice is shown.',
      (tester) async {
        final client = EmailTestClient();
        await tester.pumpWidget(
          _host(
            EmailSignInWidget(
              client: client,
              loginMethods: EmailLoginMethods.passwordless,
              consentNotice: const Text('Notice'),
              onTermsAndConditionsPressed: () {},
            ),
          ),
        );

        expect(find.text('Notice'), findsOneWidget);
        expect(find.byType(Checkbox), findsNothing);
      },
    );
  });

  testWidgets(
    'Given a localization provider with custom passwordless texts, '
    'when the widget is built, '
    'then the custom texts are shown.',
    (tester) async {
      final client = EmailTestClient();
      await tester.pumpWidget(
        _host(
          const SizedBox(),
          localization: SignInLocalizationProvider(
            email: EmailSignInTexts.defaults.copyWith(
              passwordlessTitle: 'W_TITLE',
              passwordlessContinueAction: 'W_CONTINUE',
            ),
            child: EmailSignInWidget(
              client: client,
              loginMethods: EmailLoginMethods.passwordless,
            ),
          ),
        ),
      );

      expect(find.text('W_TITLE'), findsOneWidget);
      expect(find.text('W_CONTINUE'), findsOneWidget);
    },
  );

  testWidgets(
    'Given an email and password flow, '
    'when the verification form is built, '
    'then it still shows the back to sign in button.',
    (tester) async {
      final controller = EmailAuthController(
        client: EmailTestClient(),
        startScreen: EmailFlowScreen.verifyRegistration,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        _host(
          VerificationForm(
            title: 'T',
            messageText: 'Message',
            controller: controller,
            onCompleted: () {},
            verificationCodeConfig: const VerificationCodeConfig(),
          ),
        ),
      );

      expect(find.text('Back to sign in'), findsOneWidget);
    },
  );
  for (final (name, config) in <(String, VerificationCodeConfig?)>[
    ('the default config', null),
    ('a config without a pattern', const VerificationCodeConfig(length: 6)),
    ('numbersOnly', VerificationCodeConfig.numbersOnly(length: 6)),
  ]) {
    testWidgets(
      'Given $name, '
      'when a code with zeros is typed, '
      'then the controller receives it intact.',
      (tester) async {
        final client = EmailTestClient();
        final controller = EmailAuthController(
          client: client,
          startScreen: EmailFlowScreen.passwordlessStart,
        );
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          _host(
            EmailSignInWidget(
              controller: controller,
              passwordlessVerificationCodeConfig: config,
            ),
          ),
        );
        await _startLogin(tester);

        await tester.enterText(find.byType(EditableText).first, '012340');
        await tester.pumpAndSettle();

        expect(controller.verificationCodeController.text, '012340');
        expect(client.email!.finishedRequests.single.code, '012340');
      },
    );
  }

  testWidgets(
    'Given a config whose pattern does not allow zeros, '
    'when the widget is built, '
    'then a debug message warns about it.',
    (tester) async {
      final messages = <String>[];
      final originalDebugPrint = debugPrint;
      debugPrint = (message, {wrapWidth}) => messages.add(message ?? '');
      try {
        await tester.pumpWidget(
          _host(
            EmailSignInWidget(
              client: EmailTestClient(),
              loginMethods: EmailLoginMethods.passwordless,
              passwordlessVerificationCodeConfig: VerificationCodeConfig(
                length: 6,
                allowedCharactersPattern: RegExp(r'[1-9]'),
              ),
            ),
          ),
        );
      } finally {
        debugPrint = originalDebugPrint;
      }

      expect(
        messages.where((m) => m.contains('does not allow "0"')),
        hasLength(1),
      );
    },
  );

  testWidgets(
    'Given the server refuses a new code within its resend cooldown, '
    'when the code is resent, '
    'then the verification form shows the localized cooldown message.',
    (tester) async {
      final client = EmailTestClient();
      final controller = EmailAuthController(
        client: client,
        startScreen: EmailFlowScreen.passwordlessStart,
      );
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          const SizedBox(),
          localization: SignInLocalizationProvider(
            email: EmailSignInTexts.defaults.copyWith(
              passwordlessResendCooldownMessage: 'W_COOLDOWN',
            ),
            child: EmailSignInWidget(controller: controller),
          ),
        ),
      );
      await _startLogin(tester);
      expect(find.text('W_COOLDOWN'), findsNothing);

      client.email!.startError = idp.EmailPasswordlessLoginException(
        reason: idp.EmailPasswordlessLoginExceptionReason.resendCooldown,
      );
      await controller.resendVerificationCode();
      await tester.pumpAndSettle();

      expect(find.text('W_COOLDOWN'), findsOneWidget);
      expect(find.byType(VerificationForm), findsOneWidget);
    },
  );

  testWidgets(
    'Given the server refuses a code for another email within its cooldown, '
    'when the continue button is tapped, '
    'then the email form stays and shows the localized cooldown message.',
    (tester) async {
      final client = EmailTestClient();
      client.email!.startError = idp.EmailPasswordlessLoginException(
        reason: idp.EmailPasswordlessLoginExceptionReason.resendCooldown,
      );
      await tester.pumpWidget(
        _host(
          const SizedBox(),
          localization: SignInLocalizationProvider(
            email: EmailSignInTexts.defaults.copyWith(
              passwordlessResendCooldownMessage: 'W_COOLDOWN',
            ),
            child: EmailSignInWidget(
              client: client,
              loginMethods: EmailLoginMethods.passwordless,
            ),
          ),
        ),
      );

      await _startLogin(tester);

      expect(find.text('W_COOLDOWN'), findsOneWidget);
      expect(find.text('Continue with email'), findsOneWidget);
    },
  );

  group('Given the login methods', () {
    testWidgets(
      'when the default password method is used on the login screen, '
      'then no link to sign in with a code is shown.',
      (tester) async {
        await tester.pumpWidget(
          _host(
            EmailSignInWidget(
              client: EmailTestClient(),
              startScreen: EmailFlowScreen.login,
            ),
          ),
        );

        expect(find.text('Sign In with email'), findsOneWidget);
        expect(find.text('Sign in with a code instead'), findsNothing);
      },
    );

    testWidgets(
      'when both methods are enabled, '
      'then the login screen links to the passwordless login and back.',
      (tester) async {
        await tester.pumpWidget(
          _host(
            EmailSignInWidget(
              client: EmailTestClient(),
              startScreen: EmailFlowScreen.login,
              loginMethods: EmailLoginMethods.both,
            ),
          ),
        );

        await tester.tap(find.text('Sign in with a code instead'));
        await tester.pumpAndSettle();
        expect(find.text('Continue with email'), findsOneWidget);

        await tester.tap(find.text('Use password instead'));
        await tester.pumpAndSettle();
        expect(find.text('Sign In with email'), findsOneWidget);
      },
    );

    testWidgets(
      'when both methods are enabled, '
      'then the passwordless login works from the login screen.',
      (tester) async {
        final client = EmailTestClient();
        var authenticated = 0;
        await tester.pumpWidget(
          _host(
            EmailSignInWidget(
              client: client,
              startScreen: EmailFlowScreen.login,
              loginMethods: EmailLoginMethods.both,
              onAuthenticated: () => authenticated++,
            ),
          ),
        );
        await tester.tap(find.text('Sign in with a code instead'));
        await tester.pumpAndSettle();

        await _startLogin(tester);
        await tester.enterText(find.byType(EditableText).first, '123456');
        await tester.pumpAndSettle();

        expect(client.email!.finishedRequests.single.code, '123456');
        expect(authenticated, 1);
      },
    );

    testWidgets(
      'when only the passwordless method is enabled, '
      'then the passwordless login is shown without links to the password '
      'flows, even with another start screen.',
      (tester) async {
        await tester.pumpWidget(
          _host(
            EmailSignInWidget(
              client: EmailTestClient(),
              startScreen: EmailFlowScreen.login,
              loginMethods: EmailLoginMethods.passwordless,
            ),
          ),
        );

        expect(find.text('Continue with email'), findsOneWidget);
        expect(find.text('Use password instead'), findsNothing);
        expect(find.text('Sign up'), findsNothing);
        expect(find.text('Forgot password?'), findsNothing);
      },
    );

    testWidgets(
      'when custom link texts are provided, '
      'then they are shown.',
      (tester) async {
        await tester.pumpWidget(
          _host(
            const SizedBox(),
            localization: SignInLocalizationProvider(
              email: EmailSignInTexts.defaults.copyWith(
                signInWithCode: 'W_WITH_CODE',
                usePasswordInstead: 'W_USE_PASSWORD',
              ),
              child: EmailSignInWidget(
                client: EmailTestClient(),
                startScreen: EmailFlowScreen.login,
                loginMethods: EmailLoginMethods.both,
              ),
            ),
          ),
        );

        await tester.tap(find.text('W_WITH_CODE'));
        await tester.pumpAndSettle();

        expect(find.text('W_USE_PASSWORD'), findsOneWidget);
      },
    );
  });
}
