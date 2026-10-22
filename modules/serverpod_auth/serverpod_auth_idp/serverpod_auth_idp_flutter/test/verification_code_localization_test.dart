import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';

void main() {
  testWidgets(
    'Given no localization provider, '
    'when a resend button is displayed without a label, '
    'then it retains the default English text.',
    (tester) async {
      final button = ResendCodeButton(
        onResendPressed: () async {},
        countdownDuration: Duration.zero,
      );

      await tester.pumpWidget(_app(button));

      expect(find.text("Didn't receive? Send a new code"), findsOneWidget);
    },
  );

  testWidgets(
    'Given shared verification code texts and an active resend countdown, '
    'when the countdown finishes, '
    'then the localized label remains visible without the countdown.',
    (tester) async {
      await tester.pumpWidget(
        _app(
          SignInLocalizationProvider(
            verificationCodeTexts: const VerificationCodeTexts(
              resendCode: 'Send again',
            ),
            child: ResendCodeButton(
              onResendPressed: () async {},
              countdownDuration: const Duration(seconds: 2),
            ),
          ),
        ),
      );
      expect(find.text('Send again (2)'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Send again'), findsOneWidget);
      expect(find.text('Send again (2)'), findsNothing);
    },
  );

  testWidgets(
    'Given shared verification code texts and an explicit resend label, '
    'when the resend button is displayed, '
    'then the explicit label takes precedence.',
    (tester) async {
      final button = ResendCodeButton(
        onResendPressed: () async {},
        countdownDuration: Duration.zero,
        label: 'Send another email',
      );

      await tester.pumpWidget(
        _app(
          SignInLocalizationProvider(
            verificationCodeTexts: const VerificationCodeTexts(
              resendCode: 'Shared resend',
            ),
            child: button,
          ),
        ),
      );

      expect(find.text('Send another email'), findsOneWidget);
      expect(find.text('Shared resend'), findsNothing);
    },
  );

  testWidgets(
    'Given a resend button using the default localization, '
    'when the shared verification code texts change, '
    'then the existing button displays the updated text.',
    (tester) async {
      final button = ResendCodeButton(
        onResendPressed: () async {},
        countdownDuration: Duration.zero,
      );
      await tester.pumpWidget(
        _app(SignInLocalizationProvider(child: button)),
      );
      expect(find.text("Didn't receive? Send a new code"), findsOneWidget);

      await tester.pumpWidget(
        _app(
          SignInLocalizationProvider(
            verificationCodeTexts: VerificationCodeTexts.defaults.copyWith(
              resendCode: 'Enviar outro código',
            ),
            child: button,
          ),
        ),
      );

      expect(find.text('Enviar outro código'), findsOneWidget);
      expect(find.text("Didn't receive? Send a new code"), findsNothing);
    },
  );
}

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));
