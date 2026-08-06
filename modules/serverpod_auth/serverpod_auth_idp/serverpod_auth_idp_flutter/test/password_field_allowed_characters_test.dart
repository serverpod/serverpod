import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/src/common/widgets/password_field.dart';
import 'package:serverpod_auth_idp_flutter/src/common/widgets/password_requirements/requirements.dart';

// OWASP-recommended special characters (printable ASCII).
// See https://owasp.org/www-community/password-special-characters
const _owaspSpecialCharacters = r''' !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~''';

void main() {
  const requirement = ContainsSpecialCharacterPasswordRequirement();

  test(
    'Given every OWASP-recommended special character, '
    'when matched against allowedCharacters, '
    'then each character is allowed.',
    () {
      for (final char in _owaspSpecialCharacters.split('')) {
        expect(
          PasswordRequirement.allowedCharacters.hasMatch(char),
          isTrue,
          reason: 'Expected "$char" to be an allowed password character',
        );
      }
    },
  );

  test(
    'Given a password containing only a single quote as special char, '
    'when validating special character requirements, '
    'then the requirement is satisfied.',
    () {
      expect(requirement.validate("abcABC123'"), isTrue);
    },
  );

  test(
    'Given passwords using newly-accepted OWASP special characters, '
    'when validating special character requirements, '
    'then the requirement is satisfied.',
    () {
      for (final char in ["'", '-', '_', '+', '=', '/', r'\', ';', '~']) {
        expect(
          requirement.validate('abcABC123$char'),
          isTrue,
          reason: '"$char" should count as a special character',
        );
      }
    },
  );

  test(
    'Given an alphanumeric password with no special character, '
    'when validating special character requirements, '
    'then the requirement is not satisfied.',
    () {
      expect(requirement.validate('abcABC123'), isFalse);
    },
  );

  testWidgets(
    'Given a password containing a single quote, '
    'when entered into PasswordField, '
    'then the quote is not silently stripped.',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: PasswordField(controller: controller)),
        ),
      );

      await tester.enterText(find.byType(TextField), "Abcdef1'ghij");

      expect(controller.text, "Abcdef1'ghij");
    },
  );

  testWidgets(
    'Given a password containing every OWASP special character, '
    'when entered into PasswordField, '
    'then all characters are preserved.',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: PasswordField(controller: controller)),
        ),
      );

      const input = 'Aa1$_owaspSpecialCharacters';
      await tester.enterText(find.byType(TextField), input);

      expect(controller.text, input);
    },
  );

  testWidgets(
    'Given a pasted password from a generator including dashes, underscores and single quotes, '
    'when entered into a PasswordField, '
    'then all characters are preserved.',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: PasswordField(controller: controller)),
        ),
      );

      const pasted = "Hunter2'sP@ss-word_ok!";
      await tester.enterText(find.byType(TextField), pasted);

      expect(controller.text, pasted);
    },
  );
}
