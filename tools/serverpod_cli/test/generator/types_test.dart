import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:test/test.dart';

void main() {
  var emptyRecordType = RecordType(
    nullabilitySuffix: NullabilitySuffix.none,
    positional: [],
    named: {},
  );

  test(
      'Given "RecordType", when creating "TypeDefinition", then the `className` is set to "Record"',
      () {
    var typeDefinition = TypeDefinition.fromDartType(
      RecordType(
        nullabilitySuffix: NullabilitySuffix.none,
        positional: [],
        named: {},
      ),
    );

    expect(typeDefinition.className, 'Record');
  });

  test(
      'Given "RecordType" with a positional field, when creating "TypeDefinition", then the positional field is stored in `generics` without a `recordFieldName`',
      () {
    var typeDefinition = TypeDefinition.fromDartType(
      RecordType(
        nullabilitySuffix: NullabilitySuffix.none,
        positional: [emptyRecordType],
        named: {},
      ),
    );

    expect(typeDefinition.generics, [
      isA<TypeDefinition>().having(
        (t) => t.recordFieldName,
        'recordFieldName',
        isNull,
      ),
    ]);
  });

  test(
      'Given "RecordType" with a named field, when creating "TypeDefinition", then the positional field is stored in `generics` with its name as `recordFieldName`',
      () {
    var typeDefinition = TypeDefinition.fromDartType(
      RecordType(
        nullabilitySuffix: NullabilitySuffix.none,
        positional: [],
        named: {'subRecord': emptyRecordType},
      ),
    );

    expect(typeDefinition.generics, [
      isA<TypeDefinition>().having(
        (t) => t.recordFieldName,
        'recordFieldName',
        'subRecord',
      ),
    ]);
  });
  test(
      'Given "RecordType" with a positional and a named field, when creating "TypeDefinition", then the fields are stored in `generics` without and with a `recordFieldName` respectively',
      () {
    var typeDefinition = TypeDefinition.fromDartType(
      RecordType(
        nullabilitySuffix: NullabilitySuffix.none,
        positional: [emptyRecordType],
        named: {'subRecord': emptyRecordType},
      ),
    );

    expect(typeDefinition.generics, [
      isA<TypeDefinition>().having(
        (t) => t.recordFieldName,
        'recordFieldName',
        isNull,
      ),
      isA<TypeDefinition>().having(
        (t) => t.recordFieldName,
        'recordFieldName',
        'subRecord',
      ),
    ]);
  });

  test(
      'Given "RecordType" with a positional and a named field containing further records, when creating "TypeDefinition", then the fields are stored in `generics` without and with a `recordFieldName` respectively and each nested field\'s `generics` contains the record information',
      () {
    var childRecordType = RecordType(
      nullabilitySuffix: NullabilitySuffix.none,
      positional: [emptyRecordType],
      named: {'emptyRecord': emptyRecordType},
    );

    var typeDefinition = TypeDefinition.fromDartType(
      RecordType(
        nullabilitySuffix: NullabilitySuffix.none,
        positional: [childRecordType],
        named: {'subRecord': childRecordType},
      ),
    );

    expect(typeDefinition.generics, [
      isA<TypeDefinition>()
          .having(
        (t) => t.recordFieldName,
        'recordFieldName',
        isNull,
      )
          .having(
        (t) => t.generics,
        'generics',
        [
          isA<TypeDefinition>().having(
            (t) => t.recordFieldName,
            'recordFieldName',
            isNull,
          ),
          isA<TypeDefinition>().having(
            (t) => t.recordFieldName,
            'recordFieldName',
            'emptyRecord',
          ),
        ],
      ),
      isA<TypeDefinition>()
          .having(
        (t) => t.recordFieldName,
        'recordFieldName',
        'subRecord',
      )
          .having(
        (t) => t.generics,
        'generics',
        [
          isA<TypeDefinition>().having(
            (t) => t.recordFieldName,
            'recordFieldName',
            isNull,
          ),
          isA<TypeDefinition>().having(
            (t) => t.recordFieldName,
            'recordFieldName',
            'emptyRecord',
          ),
        ],
      ),
    ]);
  });

  test('', () {
    var type = parseType('(int)', extraClasses: []);

    // This is practically wrong, but at least it's not parsed as a record
    // The analyzer will then have to warn about this not being a known type (as you can only use extra `()` on values, not types)
    expect(type.className, '(int)');
  });

  test('', () {
    var type = parseType('(int,)', extraClasses: []);

    expect(type.className, 'Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'int')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isFalse)
    ]);
  });

  test('', () {
    var type = parseType('(int,)?', extraClasses: []);

    expect(type.className, 'Record');
    expect(type.nullable, isTrue);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'int')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isFalse)
    ]);
  });

  test('', () {
    var type = parseType('(int?,)', extraClasses: []);

    expect(type.className, 'Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'int')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isTrue)
    ]);
  });

  test('', () {
    var type = parseType('({String foo})', extraClasses: []);

    expect(type.className, 'Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'String')
          .having((t) => t.recordFieldName, 'recordFieldName', 'foo')
          .having((t) => t.nullable, 'nullable', isFalse)
    ]);
  });

  test('', () {
    var type = parseType('({String? foo,})', extraClasses: []);

    expect(type.className, 'Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'String')
          .having((t) => t.recordFieldName, 'recordFieldName', 'foo')
          .having((t) => t.nullable, 'nullable', isTrue)
    ]);
  });

  test('', () {
    var type = parseType('({List< String >? namedList,})', extraClasses: []);

    expect(type.className, 'Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'List')
          .having((t) => t.recordFieldName, 'recordFieldName', 'namedList')
          .having((t) => t.nullable, 'nullable', isTrue)
          .having(
        (t) => t.generics,
        'generics',
        [
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'String'),
        ],
      ),
    ]);
  });

  test('', () {
    var type = parseType('((String, int),)?', extraClasses: []);

    expect(type.className, 'Record');
    expect(type.nullable, isTrue);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'Record')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isFalse)
          .having(
        (t) => t.generics,
        'generics',
        [
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'String'),
          isA<TypeDefinition>().having((t) => t.className, 'className', 'int'),
        ],
      ),
    ]);
  });

  test('namedPositional', () {
    var type = parseType('(String namedPositional,)', extraClasses: []);

    expect(type.className, 'Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'String')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isFalse),
    ]);
  });

  test('namedPositional', () {
    var type = parseType('(Map<String, int> positionalMap,)', extraClasses: []);

    expect(type.className, 'Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'Map')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isFalse)
          .having(
        (t) => t.generics,
        'generics',
        [
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'String'),
          isA<TypeDefinition>().having((t) => t.className, 'className', 'int'),
        ],
      ),
    ]);
  });

  test('namedPositional', () {
    var type = parseType(
      '( List < Set < String > > listOfString,)',
      extraClasses: [],
    );

    expect(type.className, 'Record');
    expect(type.nullable, isFalse);
    expect(
      type.generics,
      [
        isA<TypeDefinition>()
            .having((t) => t.className, 'className', 'List')
            .having(
          (t) => t.generics,
          'generics',
          [
            isA<TypeDefinition>()
                .having((t) => t.className, 'className', 'Set')
                .having(
              (t) => t.generics,
              'generics',
              [
                isA<TypeDefinition>()
                    .having((t) => t.className, 'className', 'String'),
              ],
            ),
          ],
        ),
      ],
    );
  });
  test('namedPositional', () {
    // Technically even `String ?foo` would be valid Dart
    var type =
        parseType('( List < bool > ? optionalListOfBool, )', extraClasses: []);

    expect(type.className, 'Record');
    expect(type.nullable, isFalse);
    expect(
      type.generics,
      [
        isA<TypeDefinition>()
            .having((t) => t.className, 'className', 'List')
            .having((t) => t.recordFieldName, 'recordFieldName', isNull)
            .having((t) => t.nullable, 'nullable', isTrue)
            .having(
          (t) => t.generics,
          'generics',
          [
            isA<TypeDefinition>()
                .having((t) => t.className, 'className', 'bool'),
          ],
        ),
      ],
    );
  });

  test('namedPositional (generic positional no name)', () {
    var type = parseType('(Map<String, bool?>,)', extraClasses: []);

    expect(type.className, 'Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'Map')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isFalse)
          .having(
        (t) => t.generics,
        'generics',
        [
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'String'),
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'bool')
              .having((t) => t.nullable, 'nullable', isTrue),
        ],
      ),
    ]);
  });

  // Support `(String x,)` (e.g. giving a name "hint" to the positional field)
  //         another case would be `(  List  < String >  listOfString,)`
  // or        (String foo, int)

  // (int, {}) should error (due to empty named block)
}
