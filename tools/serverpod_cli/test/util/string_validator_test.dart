import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:test/test.dart';

void main() {
  group('Project name validator', () {
    test('Valid name', () {
      var validName = 'my_test_project';
      bool isValid = StringValidators.isValidProjectName(validName);
      expect(isValid, true);
    });
    test('Valid name containing number', () {
      var validName = 'my_0test_project';
      bool isValid = StringValidators.isValidProjectName(validName);
      expect(isValid, true);
    });
    test('Valid name ending with number', () {
      var validName = 'my_test_project_0';
      bool isValid = StringValidators.isValidProjectName(validName);
      expect(isValid, true);
    });
    test('Invalid name', () {
      var invalidName = 'my_project_';
      bool isValid = StringValidators.isValidProjectName(invalidName);
      expect(isValid, false);
    });
    test('Invalid name with special char', () {
      var invalidName = 'my_project@1';
      bool isValid = StringValidators.isValidProjectName(invalidName);
      expect(isValid, false);
    });
    test('Invalid name starting with number', () {
      var invalidName = '0_my_project';
      bool isValid = StringValidators.isValidProjectName(invalidName);
      expect(isValid, false);
    });
  });

  group('Tag name validator', () {
    test('Returns true for valid tag names', () {
      expect(StringValidators.isValidTagName('valid-tag-name'), isTrue);
    });

    test('Returns false for tag name with uppercase letters', () {
      expect(StringValidators.isValidTagName('InvalidTagName'), isFalse);
    });

    test('Returns false for tag name with camelcase letters', () {
      expect(StringValidators.isValidTagName('invalidTagName'), isFalse);
    });

    test('Returns false for tag name with underscores', () {
      expect(StringValidators.isValidTagName('Invalid_Tag_Name'), isFalse);
    });

    test('Returns false for tag name with hyphens and uppercase letters', () {
      expect(StringValidators.isValidTagName('Invalid-Tag-Name'), isFalse);
    });
  });
}
