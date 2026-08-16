import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';

void main() {
  testWidgets(
    'Given SignInLocalizationProvider with custom email texts, '
    'when building LoginForm, '
    'then localized labels from email texts are shown.',
    (tester) async {
      final controller = EmailAuthController(client: _TestClient());
      final texts = EmailSignInTexts.defaults.copyWith(
        title: 'W_LOGIN_TITLE',
        forgotPassword: 'W_FORGOT',
        signIn: 'W_SIGN_IN',
        dontHaveAnAccount: 'W_NO_ACCOUNT',
        signUp: 'W_SIGN_UP',
        emailLabel: 'W_EMAIL',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              email: texts,
              child: LoginForm(controller: controller),
            ),
          ),
        ),
      );

      expect(find.text('W_LOGIN_TITLE'), findsOneWidget);
      expect(find.text('W_FORGOT'), findsOneWidget);
      expect(find.text('W_SIGN_IN'), findsOneWidget);
      expect(find.text('W_NO_ACCOUNT'), findsOneWidget);
      expect(find.text('W_SIGN_UP'), findsOneWidget);
      expect(find.text('W_EMAIL'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom email texts, '
    'when building StartRegistrationForm without terms, '
    'then localized labels from email texts are shown.',
    (tester) async {
      final controller = EmailAuthController(client: _TestClient());
      final texts = EmailSignInTexts.defaults.copyWith(
        signUpTitle: 'W_SIGN_UP_TITLE',
        continueAction: 'W_CONTINUE',
        alreadyHaveAnAccount: 'W_HAVE_ACCOUNT',
        signIn: 'W_SIGN_IN',
        emailLabel: 'W_EMAIL',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              email: texts,
              child: StartRegistrationForm(controller: controller),
            ),
          ),
        ),
      );

      expect(find.text('W_SIGN_UP_TITLE'), findsOneWidget);
      expect(find.text('W_CONTINUE'), findsOneWidget);
      expect(find.text('W_HAVE_ACCOUNT'), findsOneWidget);
      expect(find.text('W_SIGN_IN'), findsOneWidget);
      expect(find.text('W_EMAIL'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom email texts, '
    'when reading emailSignInTexts for verification screens, '
    'then verification message, verify action, and back labels match.',
    (tester) async {
      final texts = EmailSignInTexts.defaults.copyWith(
        verifyAccountTitle: 'W_VERIFY_ACCOUNT_TITLE',
        verifyResetCodeTitle: 'W_VERIFY_RESET_TITLE',
        verificationMessage: 'W_VERIFY_MSG',
        verify: 'W_VERIFY',
        backToSignIn: 'W_BACK_SIGN_IN',
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              email: texts,
              child: Builder(
                builder: (context) {
                  final t = context.emailSignInTexts;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.verifyAccountTitle),
                      Text(t.verifyResetCodeTitle),
                      Text(t.verificationMessage),
                      Text(t.verify),
                      Text(t.backToSignIn),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
      expect(find.text('W_VERIFY_ACCOUNT_TITLE'), findsOneWidget);
      expect(find.text('W_VERIFY_RESET_TITLE'), findsOneWidget);
      expect(find.text('W_VERIFY_MSG'), findsOneWidget);
      expect(find.text('W_VERIFY'), findsOneWidget);
      expect(find.text('W_BACK_SIGN_IN'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom email texts, '
    'when building RequestPasswordResetForm, '
    'then reset copy and actions use email texts.',
    (tester) async {
      final controller = EmailAuthController(client: _TestClient());
      final texts = EmailSignInTexts.defaults.copyWith(
        resetPasswordTitle: 'W_RESET_TITLE',
        resetPasswordDescription: 'W_RESET_DESC',
        requestPasswordReset: 'W_REQUEST_RESET',
        dontHaveAnAccount: 'W_NO_ACCOUNT',
        signUp: 'W_SIGN_UP',
        emailLabel: 'W_EMAIL',
        backToSignIn: 'W_BACK_SIGN_IN',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              email: texts,
              child: RequestPasswordResetForm(controller: controller),
            ),
          ),
        ),
      );

      expect(find.text('W_RESET_TITLE'), findsOneWidget);
      expect(find.text('W_RESET_DESC'), findsOneWidget);
      expect(find.text('W_REQUEST_RESET'), findsOneWidget);
      expect(find.text('W_NO_ACCOUNT'), findsOneWidget);
      expect(find.text('W_SIGN_UP'), findsOneWidget);
      expect(find.text('W_EMAIL'), findsOneWidget);
      expect(find.text('W_BACK_SIGN_IN'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom email texts, '
    'when building CompleteRegistrationForm, '
    'then password completion copy uses email texts.',
    (tester) async {
      final controller = EmailAuthController(client: _TestClient());
      final texts = EmailSignInTexts.defaults.copyWith(
        setAccountPasswordTitle: 'W_SET_PW_TITLE',
        passwordLabel: 'W_PW_LABEL',
        signUp: 'W_SIGN_UP_ACTION',
        backToSignUp: 'W_BACK_SIGN_UP',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              email: texts,
              child: CompleteRegistrationForm(controller: controller),
            ),
          ),
        ),
      );

      expect(find.text('W_SET_PW_TITLE'), findsOneWidget);
      expect(find.text('W_PW_LABEL'), findsOneWidget);
      expect(find.text('W_SIGN_UP_ACTION'), findsOneWidget);
      expect(find.text('W_BACK_SIGN_UP'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom email texts, '
    'when building CompletePasswordResetForm, '
    'then new-password copy uses email texts.',
    (tester) async {
      final controller = EmailAuthController(client: _TestClient());
      final texts = EmailSignInTexts.defaults.copyWith(
        setNewPasswordTitle: 'W_NEW_PW_TITLE',
        newPasswordLabel: 'W_NEW_PW_LABEL',
        resetPassword: 'W_RESET_PW_ACTION',
        backToSignIn: 'W_BACK_SIGN_IN',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              email: texts,
              child: CompletePasswordResetForm(controller: controller),
            ),
          ),
        ),
      );

      expect(find.text('W_NEW_PW_TITLE'), findsOneWidget);
      expect(find.text('W_NEW_PW_LABEL'), findsOneWidget);
      expect(find.text('W_RESET_PW_ACTION'), findsOneWidget);
      expect(find.text('W_BACK_SIGN_IN'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom email texts, '
    'when building TermsAndPrivacyText, '
    'then terms and privacy strings use email texts.',
    (tester) async {
      final texts = EmailSignInTexts.defaults.copyWith(
        termsIntro: 'W_TERMS_INTRO',
        termsAndConditions: 'W_TERMS',
        andText: 'W_AND',
        privacyPolicy: 'W_PRIVACY',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              email: texts,
              child: TermsAndPrivacyText(
                onTermsAndConditionsPressed: () {},
                onPrivacyPolicyPressed: () {},
                onCheckboxChanged: (_) {},
                isChecked: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('W_TERMS_INTRO'), findsOneWidget);
      expect(find.text('W_TERMS'), findsOneWidget);
      expect(find.text('W_AND'), findsOneWidget);
      expect(find.text('W_PRIVACY'), findsOneWidget);
    },
  );
}

class _TestClient extends ServerpodClientShared {
  _TestClient()
    : super(
        'http://localhost:8080/',
        _TestSerializationManager(),
        streamingConnectionTimeout: null,
        connectionTimeout: null,
      );

  @override
  Map<String, EndpointRef> get endpointRefLookup => {};

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

class _TestSerializationManager extends SerializationManager {}
