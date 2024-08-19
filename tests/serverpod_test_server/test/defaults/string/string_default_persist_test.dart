import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  group(
    "Given a class with 'defaultPersist' fields",
    () {
      test(
        'when an object of the class is created, then the "stringDefaultPersist" field should be null',
        () {
          var object = StringDefaultPersist();
          expect(object.stringDefaultPersist, isNull);
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultPersist", then the field value should match the provided value',
        () {
          var object =
              StringDefaultPersist(stringDefaultPersist: 'A specific value');
          expect(object.stringDefaultPersist, equals('A specific value'));
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote", then the field value should match the provided value',
        () {
          var object = StringDefaultPersist(
              stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote:
                  'A \'specific\' value');
          expect(object.stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
              equals('A \'specific\' value'));
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote", then the field value should match the provided value',
        () {
          var object = StringDefaultPersist(
              stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote:
                  'A \'specific\' value');
          expect(object.stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
              equals('A \'specific\' value'));
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote", then the field value should match the provided value',
        () {
          var object = StringDefaultPersist(
              stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote:
                  'A "specific" value');
          expect(object.stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
              equals('A "specific" value'));
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote", then the field value should match the provided value',
        () {
          var object = StringDefaultPersist(
              stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote:
                  'A "specific" value');
          expect(object.stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
              equals('A "specific" value'));
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultPersistSingleQuoteWithOneDoubleQuote", then the field value should match the provided value',
        () {
          var object = StringDefaultPersist(
              stringDefaultPersistSingleQuoteWithOneDoubleQuote:
                  'A "specific" value');
          expect(object.stringDefaultPersistSingleQuoteWithOneDoubleQuote,
              equals('A "specific" value'));
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultPersistSingleQuoteWithTwoDoubleQuote", then the field value should match the provided value',
        () {
          var object = StringDefaultPersist(
              stringDefaultPersistSingleQuoteWithTwoDoubleQuote:
                  'A "specific" value');
          expect(object.stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
              equals('A "specific" value'));
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultPersistDoubleQuoteWithOneSingleQuote", then the field value should match the provided value',
        () {
          var object = StringDefaultPersist(
              stringDefaultPersistDoubleQuoteWithOneSingleQuote:
                  'A \'specific\' value');
          expect(object.stringDefaultPersistDoubleQuoteWithOneSingleQuote,
              equals('A \'specific\' value'));
        },
      );

      test(
        'when an object of the class is created with a specific value for "stringDefaultPersistDoubleQuoteWithTwoSingleQuote", then the field value should match the provided value',
        () {
          var object = StringDefaultPersist(
              stringDefaultPersistDoubleQuoteWithTwoSingleQuote:
                  'A \'specific\' value');
          expect(object.stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
              equals('A \'specific\' value'));
        },
      );
    },
  );
}
