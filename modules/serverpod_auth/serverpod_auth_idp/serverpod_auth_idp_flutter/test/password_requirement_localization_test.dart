import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/src/common/widgets/password_requirements/widget.dart';

void main() {
  testWidgets(
    'Given SignInLocalizationProvider with custom min length text, '
    'when building PasswordRequirements, '
    'then the label uses the custom text.',
    (tester) async {
      final passwordReqTexts = PasswordRequirementTexts.defaults.copyWith(
        minLengthTemplate: 'CTX_MIN_{length}',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              passwordRequirementTexts: passwordReqTexts,
              child: PasswordRequirements(
                password: '',
                requirements: [
                  PasswordRequirement.minLength(8),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('CTX_MIN_8'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom max length text, '
    'when building PasswordRequirements, '
    'then the label uses the custom text.',
    (tester) async {
      final passwordReqTexts = PasswordRequirementTexts.defaults.copyWith(
        maxLengthTemplate: 'CTX_MAX_{length}',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              passwordRequirementTexts: passwordReqTexts,
              child: PasswordRequirements(
                password: '',
                requirements: [
                  PasswordRequirement.maxLength(64),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('CTX_MAX_64'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom lowercase text, '
    'when building PasswordRequirements, '
    'then the label uses the custom text.',
    (tester) async {
      final passwordReqTexts = PasswordRequirementTexts.defaults.copyWith(
        containsLowercase: 'CTX_LOWER',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              passwordRequirementTexts: passwordReqTexts,
              child: PasswordRequirements(
                password: '',
                requirements: [
                  PasswordRequirement.containsLowercase(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('CTX_LOWER'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom uppercase text, '
    'when building PasswordRequirements, '
    'then the label uses the custom text.',
    (tester) async {
      final passwordReqTexts = PasswordRequirementTexts.defaults.copyWith(
        containsUppercase: 'CTX_UPPER',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              passwordRequirementTexts: passwordReqTexts,
              child: PasswordRequirements(
                password: '',
                requirements: [
                  PasswordRequirement.containsUppercase(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('CTX_UPPER'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom number text, '
    'when building PasswordRequirements, '
    'then the label uses the custom text.',
    (tester) async {
      final passwordReqTexts = PasswordRequirementTexts.defaults.copyWith(
        containsNumber: 'CTX_NUM',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              passwordRequirementTexts: passwordReqTexts,
              child: PasswordRequirements(
                password: '',
                requirements: [
                  PasswordRequirement.containsNumber(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('CTX_NUM'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom special character text, '
    'when building PasswordRequirements, '
    'then the label uses the custom text.',
    (tester) async {
      final passwordReqTexts = PasswordRequirementTexts.defaults.copyWith(
        containsSpecialCharacter: 'CTX_SPECIAL',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              passwordRequirementTexts: passwordReqTexts,
              child: PasswordRequirements(
                password: '',
                requirements: [
                  PasswordRequirement.containsSpecialCharacter(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('CTX_SPECIAL'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with custom password requirement texts, '
    'when building PasswordRequirements, '
    'then the labels use the custom texts.',
    (tester) async {
      final passwordReqTexts = PasswordRequirementTexts.defaults.copyWith(
        minLengthTemplate: 'W_MIN_{length}_T',
        maxLengthTemplate: 'W_MAX_{length}_T',
        containsLowercase: 'W_LOWER',
        containsUppercase: 'W_UPPER',
        containsNumber: 'W_NUM',
        containsSpecialCharacter: 'W_SPECIAL',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              passwordRequirementTexts: passwordReqTexts,
              child: PasswordRequirements(
                password: '',
                requirements: PasswordRequirement.defaultRequirements,
              ),
            ),
          ),
        ),
      );

      expect(find.text('W_MIN_12_T'), findsOneWidget);
      expect(find.text('W_UPPER'), findsOneWidget);
      expect(find.text('W_LOWER'), findsOneWidget);
      expect(find.text('W_NUM'), findsOneWidget);
      expect(find.text('W_SPECIAL'), findsOneWidget);
    },
  );
}
