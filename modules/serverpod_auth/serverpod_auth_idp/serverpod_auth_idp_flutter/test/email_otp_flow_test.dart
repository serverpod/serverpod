import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as idp;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/src/email/forms/shared/shared_password_reset_forms.dart';
import 'package:serverpod_auth_idp_flutter/src/email/forms/shared/shared_verification_form.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';

void main() {
  const email = 'user@serverpod.dev';
  const otpCode = '123456';
  const strongPassword = 'StrongPassword123!';

  Future<void> pumpWidget(
    WidgetTester tester,
    Widget child, {
    double width = 320,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SignInLocalizationProvider(
            // The test font renders text wider than real fonts, so keep the
            // longer texts short for the forms to fit.
            email: EmailSignInTexts.defaults.copyWith(
              alreadyHaveAnAccount: 'Member?',
            ),
            emailWithOtp: EmailWithOtpSignInTexts.defaults.copyWith(
              verifyTitle: 'Code',
              verificationMessage: 'Enter code',
            ),
            passwordRequirementTexts: const PasswordRequirementTexts(
              minLengthTemplate: 'Min {length}',
              maxLengthTemplate: 'Max {length}',
              containsLowercase: 'Lowercase',
              containsUppercase: 'Uppercase',
              containsNumber: 'Number',
              containsSpecialCharacter: 'Special',
            ),
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> requestCode(
    WidgetTester tester,
    EmailOtpAuthController controller,
  ) async {
    controller.emailController.text = email;
    // Let the email validation debounce run.
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text(EmailWithOtpSignInTexts.defaults.sendCode));
    await tester.pumpAndSettle();
  }

  Future<void> submitCode(
    WidgetTester tester,
    EmailOtpAuthController controller,
  ) async {
    // Entering the full code submits it automatically.
    controller.verificationCodeController.text = otpCode;
    await tester.pumpAndSettle();
  }

  test(
    'Given both a client and a controller, '
    'when creating an EmailOtpSignInWidget, '
    'then it throws an AssertionError.',
    () {
      final client = _TestClient();
      final controller = EmailOtpAuthController(client: client);
      addTearDown(controller.dispose);

      expect(
        () => EmailOtpSignInWidget(client: client, controller: controller),
        throwsA(isA<AssertionError>()),
      );
    },
  );

  testWidgets(
    'Given an EmailOtpSignInWidget allowing password sign-in, '
    'when it is shown, '
    'then the passwordless start screen shows the send code action, with '
    'the password option collapsed.',
    (tester) async {
      final controller = EmailOtpAuthController(
        client: _TestClient(),
        allowPasswordSignIn: true,
      );
      addTearDown(controller.dispose);
      await pumpWidget(tester, EmailOtpSignInWidget(controller: controller));

      expect(find.byType(OtpStartForm), findsOneWidget);
      expect(find.byType(PasswordField), findsNothing);
      expect(
        find.text(EmailWithOtpSignInTexts.defaults.signInWithPassword),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(
          ActionButton,
          EmailWithOtpSignInTexts.defaults.sendCode,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Given custom otp texts in the localization provider, '
    'when the passwordless start screen is shown, '
    'then the custom texts are displayed.',
    (tester) async {
      final controller = EmailOtpAuthController(
        client: _TestClient(),
        allowPasswordSignIn: true,
      );
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              emailWithOtp: EmailWithOtpSignInTexts.defaults.copyWith(
                startTitle: 'W_OTP_TITLE',
                sendCode: 'W_SEND_CODE',
                signInWithPassword: 'W_USE_PASSWORD',
              ),
              child: EmailOtpSignInWidget(controller: controller),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('W_OTP_TITLE'), findsOneWidget);
      expect(find.text('W_SEND_CODE'), findsOneWidget);
      expect(find.text('W_USE_PASSWORD'), findsOneWidget);
    },
  );

  testWidgets(
    'Given a custom resend code text in the passwordless texts, '
    'when the verification screen is shown, '
    'then the resend action uses the custom text.',
    (tester) async {
      final controller = EmailOtpAuthController(client: _TestClient());
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              emailWithOtp: EmailWithOtpSignInTexts.defaults.copyWith(
                verifyTitle: 'Code',
                verificationMessage: 'Enter code',
                resendCode: 'W_RESEND',
              ),
              child: SizedBox(
                width: 320,
                child: EmailOtpSignInWidget(controller: controller),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await requestCode(tester, controller);

      expect(find.textContaining('W_RESEND'), findsOneWidget);
    },
  );

  testWidgets(
    'Given an EmailSignInWidget with default configuration, '
    'when it is shown, '
    'then the password based registration screen is displayed.',
    (tester) async {
      await pumpWidget(
        tester,
        EmailSignInWidget(client: _TestClient()),
        width: 600,
      );

      expect(find.byType(OtpStartForm), findsNothing);
      expect(find.byType(StartRegistrationForm), findsOneWidget);
    },
  );

  testWidgets(
    'Given an EmailOtpSignInWidget with default configuration, '
    'when it is shown, '
    'then no option to sign in with a password is displayed.',
    (tester) async {
      await pumpWidget(tester, EmailOtpSignInWidget(client: _TestClient()));

      expect(find.byType(OtpStartForm), findsOneWidget);
      expect(
        find.text(EmailWithOtpSignInTexts.defaults.signInWithPassword),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Given an EmailOtpSignInWidget created with a controller that allows '
    'password sign-in, '
    'when it is shown, '
    'then the widget follows the controller and offers the password sign-in.',
    (tester) async {
      final controller = EmailOtpAuthController(
        client: _TestClient(),
        allowPasswordSignIn: true,
      );
      addTearDown(controller.dispose);
      await pumpWidget(tester, EmailOtpSignInWidget(controller: controller));

      expect(find.byType(OtpStartForm), findsOneWidget);
      expect(
        find.text(EmailWithOtpSignInTexts.defaults.signInWithPassword),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Given the password reset was opened from the passwordless start screen, '
    'when the user goes back to sign in, '
    'then the passwordless start screen is shown again.',
    (tester) async {
      final controller = EmailOtpAuthController(
        client: _TestClient(),
        allowPasswordSignIn: true,
      );
      addTearDown(controller.dispose);
      await pumpWidget(
        tester,
        EmailOtpSignInWidget(controller: controller),
        width: 600,
      );

      await tester.tap(
        find.text(EmailWithOtpSignInTexts.defaults.signInWithPassword),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(EmailSignInTexts.defaults.forgotPassword));
      await tester.pumpAndSettle();

      expect(find.byType(SharedRequestPasswordResetForm), findsOneWidget);

      await tester.tap(find.text(EmailSignInTexts.defaults.backToSignIn));
      await tester.pumpAndSettle();

      expect(controller.currentScreen, EmailOtpFlowScreen.start);
      expect(find.byType(OtpStartForm), findsOneWidget);
    },
  );

  testWidgets(
    'Given the passwordless start screen, '
    'when the password option is expanded and the user signs in, '
    'then the password login endpoint is used.',
    (tester) async {
      final client = _TestClient();
      var authenticated = false;
      final controller = EmailOtpAuthController(
        client: client,
        allowPasswordSignIn: true,
        onAuthenticated: () => authenticated = true,
      );
      await pumpWidget(
        tester,
        EmailOtpSignInWidget(controller: controller),
      );

      await tester.tap(
        find.text(EmailWithOtpSignInTexts.defaults.signInWithPassword),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PasswordField), findsOneWidget);
      expect(
        find.text(EmailSignInTexts.defaults.forgotPassword),
        findsOneWidget,
      );
      expect(
        find.text(EmailWithOtpSignInTexts.defaults.sendCode),
        findsNothing,
      );
      expect(
        tester.getTopLeft(find.byType(PasswordField)).dy,
        lessThan(tester.getTopLeft(find.byType(ActionButton)).dy),
      );
      expect(
        find.text(EmailWithOtpSignInTexts.defaults.signInWithCode),
        findsOneWidget,
      );

      controller.emailController.text = email;
      controller.passwordController.text = strongPassword;
      await tester.pump(const Duration(milliseconds: 600));
      await tester.tap(
        find.widgetWithText(ActionButton, EmailSignInTexts.defaults.signIn),
      );
      await tester.pumpAndSettle();

      expect(client.email.calls, ['login']);
      expect(authenticated, isTrue);
    },
  );

  testWidgets(
    'Given an existing account, '
    'when the user requests and submits a one-time password, '
    'then the user is signed in through finishOtpLogin.',
    (tester) async {
      final client = _TestClient(accountExists: true);
      var authenticated = false;
      final controller = EmailOtpAuthController(
        client: client,
        onAuthenticated: () => authenticated = true,
      );
      await pumpWidget(
        tester,
        EmailOtpSignInWidget(controller: controller),
      );

      await requestCode(tester, controller);

      expect(controller.currentScreen, EmailOtpFlowScreen.verify);
      expect(find.text('Code'), findsOneWidget);

      await submitCode(tester, controller);

      expect(client.email.calls, [
        'startOtpLogin',
        'verifyOtpLoginCode',
        'finishOtpLogin',
      ]);
      expect(client.email.verifiedCode, otpCode);
      expect(authenticated, isTrue);
    },
  );

  testWidgets(
    'Given an existing account and a verified one-time password, '
    'when completing the sign-in fails with a network error and is retried, '
    'then the sign-in completes without verifying the code again.',
    (tester) async {
      final client = _TestClient(accountExists: true);
      client.email.finishOtpLoginFailures.add(
        const ServerpodClientNetworkException('Connection lost'),
      );
      var authenticated = false;
      final controller = EmailOtpAuthController(
        client: client,
        onAuthenticated: () => authenticated = true,
      );
      await pumpWidget(
        tester,
        EmailOtpSignInWidget(controller: controller),
      );

      await requestCode(tester, controller);
      await submitCode(tester, controller);

      expect(controller.state, EmailAuthState.error);
      expect(authenticated, isFalse);

      // The controller re-enables the action shortly after a network error.
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(
        find.widgetWithText(
          ActionButton,
          EmailWithOtpSignInTexts.defaults.verifyAction,
        ),
      );
      await tester.pumpAndSettle();

      expect(client.email.calls, [
        'startOtpLogin',
        'verifyOtpLoginCode',
        'finishOtpLogin',
        'finishOtpLogin',
      ]);
      expect(authenticated, isTrue);
    },
  );

  testWidgets(
    'Given an existing account and a verified one-time password, '
    'when the server rejects the completion of the sign-in, '
    'then the user is asked to request a new code, which signs in after '
    'verifying it.',
    (tester) async {
      final client = _TestClient(accountExists: true);
      client.email.finishOtpLoginFailures.add(
        idp.EmailAccountRequestException(
          reason: idp.EmailAccountRequestExceptionReason.invalid,
        ),
      );
      Object? reportedError;
      final controller = EmailOtpAuthController(
        client: client,
        onError: (error) => reportedError = error,
      );
      await pumpWidget(
        tester,
        EmailOtpSignInWidget(controller: controller),
      );

      await requestCode(tester, controller);
      await submitCode(tester, controller);

      expect(controller.state, EmailAuthState.error);
      expect(reportedError.toString(), contains('request a new code'));

      await controller.resendVerificationCode();
      await tester.pumpAndSettle();
      await submitCode(tester, controller);

      expect(client.email.calls.sublist(3), [
        'startOtpLogin',
        'verifyOtpLoginCode',
        'finishOtpLogin',
      ]);
      expect(controller.state, EmailAuthState.authenticated);
    },
  );

  testWidgets(
    'Given an EmailOtpSignInWidget with a client, '
    'when allowPasswordSignIn is not set, '
    'then the start screen does not offer the password sign-in.',
    (tester) async {
      await pumpWidget(tester, EmailOtpSignInWidget(client: _TestClient()));

      expect(
        find.text(EmailWithOtpSignInTexts.defaults.signInWithPassword),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Given an EmailOtpSignInWidget with a client and allowPasswordSignIn, '
    'when it is shown, '
    'then the start screen offers the password sign-in.',
    (tester) async {
      await pumpWidget(
        tester,
        EmailOtpSignInWidget(client: _TestClient(), allowPasswordSignIn: true),
      );

      expect(
        find.text(EmailWithOtpSignInTexts.defaults.signInWithPassword),
        findsOneWidget,
      );
    },
  );

  test(
    'Given an EmailOtpAuthController with the default email validation, '
    'when validating emails, '
    'then email aliases are accepted and invalid emails are rejected.',
    () {
      final controller = EmailOtpAuthController(client: _TestClient());
      addTearDown(controller.dispose);

      expect(
        () => controller.emailValidation('user+alias@serverpod.dev'),
        returnsNormally,
      );
      expect(
        () => controller.emailValidation('not-an-email'),
        throwsA(isA<InvalidEmailException>()),
      );
    },
  );

  testWidgets(
    'Given a narrow EmailOtpSignInWidget and a long verification message, '
    'when a code is requested, '
    'then the verification screen keeps the action in place without '
    'overflowing.',
    (tester) async {
      final controller = EmailOtpAuthController(
        client: _TestClient(accountExists: true),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              emailWithOtp: EmailWithOtpSignInTexts.defaults.copyWith(
                verifyTitle: 'Code',
                verificationMessage: 'Enter the code we sent you. ' * 4,
              ),
              child: SizedBox(
                width: 280,
                child: EmailOtpSignInWidget(controller: controller),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await requestCode(tester, controller);

      final formRect = tester.getRect(find.byType(SharedVerificationForm));
      final buttonRect = tester.getRect(
        find.widgetWithText(
          ActionButton,
          EmailWithOtpSignInTexts.defaults.verifyAction,
        ),
      );
      expect(buttonRect.bottom, lessThanOrEqualTo(formRect.bottom));
      expect(formRect.height, 330);
    },
  );

  testWidgets(
    'Given the code of a previous sign-in in the clipboard, '
    'when the app is resumed on the verification screen of a new sign-in, '
    'then that code is not filled in, while a newly copied code is filled in '
    'and submitted.',
    (tester) async {
      const previousCode = '654321';
      const newCode = '234567';
      String? clipboardText;
      final messenger = tester.binding.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.getData' && clipboardText != null) {
          return <String, dynamic>{'text': clipboardText};
        }
        return null;
      });
      addTearDown(
        () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
      );

      Future<void> resumeApp() async {
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.inactive,
        );
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pumpAndSettle();
      }

      final previousClient = _TestClient(accountExists: true);
      final previousController = EmailOtpAuthController(
        client: previousClient,
      );
      await pumpWidget(
        tester,
        EmailOtpSignInWidget(controller: previousController),
      );
      await requestCode(tester, previousController);
      clipboardText = previousCode;
      await resumeApp();
      expect(previousClient.email.verifiedCode, previousCode);
      expect(previousController.state, EmailAuthState.authenticated);

      final client = _TestClient(accountExists: true);
      final controller = EmailOtpAuthController(client: client);
      await pumpWidget(
        tester,
        EmailOtpSignInWidget(key: UniqueKey(), controller: controller),
      );
      await requestCode(tester, controller);

      await resumeApp();

      expect(controller.verificationCodeController.text, isEmpty);
      expect(client.email.calls, ['startOtpLogin']);

      clipboardText = newCode;
      await resumeApp();

      expect(client.email.verifiedCode, newCode);
      expect(controller.state, EmailAuthState.authenticated);
    },
  );

  testWidgets(
    'Given a client for a server that only exposes the password based email '
    'endpoint, '
    'when rendering the SignInWidget, '
    'then the email sign-in uses the password based flow.',
    (tester) async {
      await pumpWidget(
        tester,
        SignInWidget(client: _TestClient(exposesOtp: false)),
        width: 600,
      );

      expect(find.byType(OtpStartForm), findsNothing);
      expect(find.byType(StartRegistrationForm), findsOneWidget);
    },
  );

  testWidgets(
    'Given a client for a server that exposes the passwordless email '
    'endpoint, '
    'when rendering the SignInWidget with callbacks, '
    'then the email sign-in uses the passwordless flow with those callbacks.',
    (tester) async {
      void onAuthenticated() {}
      void onError(Object error) {}
      await pumpWidget(
        tester,
        SignInWidget(
          client: _TestClient(),
          onAuthenticated: onAuthenticated,
          onError: onError,
        ),
      );

      expect(find.byType(OtpStartForm), findsOneWidget);
      final otpWidget = tester.widget<EmailOtpSignInWidget>(
        find.byType(EmailOtpSignInWidget),
      );
      expect(otpWidget.onAuthenticated, onAuthenticated);
      expect(otpWidget.onError, onError);
    },
  );

  testWidgets(
    'Given a client for a server that exposes the passwordless email '
    'endpoint, '
    'when rendering the SignInWidget with an emailSignInWidget, '
    'then the provided password based widget is used.',
    (tester) async {
      final client = _TestClient();
      await pumpWidget(
        tester,
        SignInWidget(
          client: client,
          emailSignInWidget: EmailSignInWidget(client: client),
        ),
        width: 600,
      );

      expect(find.byType(OtpStartForm), findsNothing);
      expect(find.byType(StartRegistrationForm), findsOneWidget);
    },
  );

  test(
    'Given a server only exposing the password based email endpoint, '
    'when requesting a one-time password, '
    'then the controller fails with a StateError.',
    () async {
      final controller = EmailOtpAuthController(
        client: _TestClient(exposesOtp: false),
      );
      addTearDown(controller.dispose);
      controller.emailController.text = 'user@serverpod.dev';

      await controller.startOtpLogin();

      expect(controller.state, EmailAuthState.error);
      expect(controller.error, isA<StateError>());
    },
  );

  group('Given no account exists for the email', () {
    testWidgets(
      'when the one-time password is submitted, '
      'then the account creation screen requires accepting the terms '
      'and creates the account without password.',
      (tester) async {
        final client = _TestClient(accountExists: false);
        var authenticated = false;
        final controller = EmailOtpAuthController(
          client: client,
          onAuthenticated: () => authenticated = true,
        );
        await pumpWidget(
          tester,
          EmailOtpSignInWidget(
            controller: controller,
            onTermsAndConditionsPressed: () {},
          ),
        );

        await requestCode(tester, controller);
        await submitCode(tester, controller);

        expect(
          controller.currentScreen,
          EmailOtpFlowScreen.completeRegistration,
        );
        expect(find.byType(OtpCompleteRegistrationForm), findsOneWidget);
        expect(
          find.text(EmailWithOtpSignInTexts.defaults.addPassword),
          findsOneWidget,
        );
        expect(find.byType(PasswordField), findsNothing);

        final createAccountButton = find.widgetWithText(
          ActionButton,
          EmailWithOtpSignInTexts.defaults.createAccount,
        );
        expect(
          tester.widget<ActionButton>(createAccountButton).onPressed,
          isNull,
        );

        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
        await tester.tap(createAccountButton);
        await tester.pumpAndSettle();

        expect(client.email.calls.last, 'finishOtpRegistration');
        expect(client.email.registrationPassword, isNull);
        expect(authenticated, isTrue);
      },
    );

    testWidgets(
      'when the user sets a password on the account creation screen, '
      'then the action stays in place and the password is sent with the '
      'registration.',
      (tester) async {
        final client = _TestClient(accountExists: false);
        final controller = EmailOtpAuthController(
          client: client,
          // Requirements are covered by their own tests and do not fit the
          // test font.
          passwordRequirements: [],
        );
        await pumpWidget(
          tester,
          EmailOtpSignInWidget(controller: controller),
        );

        await requestCode(tester, controller);
        await submitCode(tester, controller);

        final createAccountButton = find.widgetWithText(
          ActionButton,
          EmailWithOtpSignInTexts.defaults.createAccount,
        );
        final buttonTopBefore = tester.getTopLeft(createAccountButton).dy;

        await tester.tap(
          find.text(EmailWithOtpSignInTexts.defaults.addPassword),
        );
        await tester.pumpAndSettle();
        expect(find.byType(PasswordField), findsOneWidget);
        expect(tester.getTopLeft(createAccountButton).dy, buttonTopBefore);

        controller.passwordController.text = strongPassword;
        await tester.pumpAndSettle();
        await tester.tap(
          find.widgetWithText(
            ActionButton,
            EmailWithOtpSignInTexts.defaults.createAccount,
          ),
        );
        await tester.pumpAndSettle();

        expect(client.email.calls.last, 'finishOtpRegistration');
        expect(client.email.registrationPassword, strongPassword);
      },
    );

    testWidgets(
      'when the user sets a password meeting the default requirements, '
      'then the create account action stays fully visible below them.',
      (tester) async {
        final client = _TestClient(accountExists: false);
        final controller = EmailOtpAuthController(client: client);
        await pumpWidget(
          tester,
          EmailOtpSignInWidget(controller: controller),
          width: 400,
        );

        await requestCode(tester, controller);
        await submitCode(tester, controller);
        await tester.tap(
          find.text(EmailWithOtpSignInTexts.defaults.addPassword),
        );
        await tester.pumpAndSettle();
        controller.passwordController.text = strongPassword;
        await tester.pumpAndSettle();

        final formRect = tester.getRect(
          find.byType(OtpCompleteRegistrationForm),
        );
        final buttonRect = tester.getRect(
          find.widgetWithText(
            ActionButton,
            EmailWithOtpSignInTexts.defaults.createAccount,
          ),
        );
        expect(find.byType(PasswordRequirements), findsOneWidget);
        expect(buttonRect.bottom, lessThanOrEqualTo(formRect.bottom));
      },
    );

    testWidgets(
      'when the user adds and then removes the password on the account '
      'creation screen, '
      'then the account is created without the password.',
      (tester) async {
        final client = _TestClient(accountExists: false);
        final controller = EmailOtpAuthController(
          client: client,
          passwordRequirements: [],
        );
        await pumpWidget(
          tester,
          EmailOtpSignInWidget(controller: controller),
        );

        await requestCode(tester, controller);
        await submitCode(tester, controller);

        await tester.tap(
          find.text(EmailWithOtpSignInTexts.defaults.addPassword),
        );
        await tester.pumpAndSettle();
        controller.passwordController.text = strongPassword;
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(EmailWithOtpSignInTexts.defaults.removePassword),
        );
        await tester.pumpAndSettle();

        expect(find.byType(PasswordField), findsNothing);

        await tester.tap(
          find.widgetWithText(
            ActionButton,
            EmailWithOtpSignInTexts.defaults.createAccount,
          ),
        );
        await tester.pumpAndSettle();

        expect(client.email.calls.last, 'finishOtpRegistration');
        expect(client.email.registrationPassword, isNull);
      },
    );

    testWidgets(
      'when the server does not allow passwords, '
      'then the account creation screen has no password field.',
      (tester) async {
        final client = _TestClient(accountExists: false, allowPassword: false);
        final controller = EmailOtpAuthController(
          client: client,
        );
        await pumpWidget(
          tester,
          EmailOtpSignInWidget(controller: controller),
        );

        await requestCode(tester, controller);
        await submitCode(tester, controller);

        expect(find.byType(OtpCompleteRegistrationForm), findsOneWidget);
        expect(
          find.text(EmailWithOtpSignInTexts.defaults.addPassword),
          findsNothing,
        );
        expect(find.byType(PasswordField), findsNothing);
      },
    );
  });
}

class _TestClient extends ServerpodClientShared {
  _TestClient({
    bool accountExists = true,
    bool allowPassword = true,
    this.exposesOtp = true,
  }) : super(
         'http://localhost:8080/',
         _TestSerializationManager(),
         streamingConnectionTimeout: null,
         connectionTimeout: null,
       ) {
    final caller = Caller(this);
    email = _TestEmailIdp(
      caller,
      accountExists: accountExists,
      allowPassword: allowPassword,
    );
    authKeyProvider = FlutterAuthSessionManager(
      caller: caller,
      storage: _InMemoryStorage(),
    );
  }

  /// Whether the server exposes the passwordless email endpoint, or only the
  /// password based one.
  final bool exposesOtp;

  late final _TestEmailIdp email;

  late final _passwordOnlyEmail = _TestPasswordOnlyEmailIdp(Caller(this));

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
    'emailIdp': exposesOtp ? email : _passwordOnlyEmail,
  };

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {};

  @override
  Future<T> callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args, {
    bool authenticated = true,
  }) async {
    throw UnimplementedError('Not used by this test.');
  }

  @override
  dynamic callStreamingServerEndpoint<T, G>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
    Map<String, Stream> streams, {
    bool authenticated = true,
  }) {
    throw UnimplementedError('Not used by this test.');
  }
}

class _TestEmailIdp extends idp.EndpointEmailOtpIdpBase {
  _TestEmailIdp(
    super.caller, {
    required this.accountExists,
    required this.allowPassword,
  });

  final bool accountExists;
  final bool allowPassword;
  final List<String> calls = [];

  /// Exceptions thrown by the next calls to [finishOtpLogin], in order.
  final List<Exception> finishOtpLoginFailures = [];
  String? verifiedCode;
  String? registrationPassword;

  static final _requestId = const Uuid().v7obj();
  static const _token = 'otp-token';

  AuthSuccess get _authSuccess => AuthSuccess(
    authStrategy: AuthStrategy.session.name,
    token: 'session-key',
    authUserId: const Uuid().v7obj(),
    scopeNames: {},
  );

  @override
  String get name => 'emailIdp';

  @override
  Future<AuthSuccess> login({
    required String email,
    required String password,
  }) async {
    calls.add('login');
    return _authSuccess;
  }

  @override
  Future<UuidValue> startOtpLogin({required String email}) async {
    calls.add('startOtpLogin');
    return _requestId;
  }

  @override
  Future<idp.EmailAccountOtpVerificationResult> verifyOtpLoginCode({
    required UuidValue otpLoginRequestId,
    required String verificationCode,
  }) async {
    calls.add('verifyOtpLoginCode');
    _check(otpLoginRequestId == _requestId);
    // Like the server, each requested code can only be verified once.
    _check(
      calls.where((c) => c == 'verifyOtpLoginCode').length <=
          calls.where((c) => c == 'startOtpLogin').length,
    );
    verifiedCode = verificationCode;
    return idp.EmailAccountOtpVerificationResult(
      token: _token,
      accountExists: accountExists,
      allowPassword: allowPassword,
    );
  }

  @override
  Future<AuthSuccess> finishOtpLogin({required String otpLoginToken}) async {
    calls.add('finishOtpLogin');
    _check(otpLoginToken == _token);
    if (finishOtpLoginFailures.isNotEmpty) {
      throw finishOtpLoginFailures.removeAt(0);
    }
    return _authSuccess;
  }

  @override
  Future<AuthSuccess> finishOtpRegistration({
    required String otpLoginToken,
    String? password,
  }) async {
    calls.add('finishOtpRegistration');
    _check(otpLoginToken == _token);
    registrationPassword = password;
    return _authSuccess;
  }

  /// Fails the call instead of using `expect`, which conflicts with the
  /// tester's guarded functions while the call runs.
  void _check(bool condition) {
    if (!condition) throw StateError('Unexpected argument.');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('Not used by this test.');
}

class _InMemoryStorage implements ClientAuthSuccessStorage {
  AuthSuccess? _data;

  @override
  Future<void> set(AuthSuccess? data) async => _data = data;

  @override
  Future<AuthSuccess?> get() async => _data;
}

class _TestSerializationManager extends SerializationManager {}

class _TestPasswordOnlyEmailIdp extends idp.EndpointEmailIdpBase {
  _TestPasswordOnlyEmailIdp(super.caller);

  @override
  String get name => 'emailIdp';

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('Not used by this test.');
}
