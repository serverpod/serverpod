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
    test('isValidTagName returns true for valid tag names', () {
      expect(StringValidators.isValidTagName('valid-tag-name'), isTrue);
    });
    test('returns false for invalid tag names', () {
      expect(StringValidators.isValidTagName('InvalidTagName'), isFalse);
      expect(StringValidators.isValidTagName('invalidTagName'), isFalse);
      expect(StringValidators.isValidTagName('Invalid_Tag_Name'), isFalse);
      expect(StringValidators.isValidTagName('Invalid-Tag-Name'), isFalse);
    });
  });
}
