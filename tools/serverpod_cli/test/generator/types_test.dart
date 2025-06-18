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

    expect(typeDefinition.className, '_Record');
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

  test(
      'Given a field type in parentheses, when it is parsed, then it is used as `className` verbatim',
      () {
    var type = parseType('(int)', extraClasses: []);

    // This is practically wrong, but at least it's not parsed as a record
    // The analyzer will then have to warn about this not being a known type (as you can only use extra `()` on values, not types)
    expect(type.className, '(int)');
  });

  test(
      'Given a record-ish looking input of `(,)`, when it is parsed, then it is used as `className` verbatim',
      () {
    var type = parseType('(,)', extraClasses: []);

    // This is practically wrong, but at least it's not parsed as a record
    // The analyzer will then warn about this not being a known type, just like it does for `(int)` above
    expect(type.className, '(,)');
  });

  test(
      'Given a record-ish looking input of `()`, when it is parsed, then it is used as `className` verbatim',
      () {
    var type = parseType('()', extraClasses: []);

    // This is practically wrong, but at least it's not parsed as a record
    // The analyzer will then warn about this not being a known type, just like it does for `(int)` above
    expect(type.className, '()');
  });

  test(
      'Given a field type of a record holding a single positional field, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType('(int,)', extraClasses: []);

    expect(type.className, '_Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'int')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isFalse)
    ]);
  });

  test(
      'Given a field type of an optional record holding a single positional field, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType('(int,)?', extraClasses: []);

    expect(type.className, '_Record');
    expect(type.nullable, isTrue);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'int')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isFalse)
    ]);
  });

  test(
      'Given a field type of a record holding a single nullable positional field, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType('(int?,)', extraClasses: []);

    expect(type.className, '_Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'int')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isTrue)
    ]);
  });

  test(
      'Given a field type of a record holding a single named field, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType('({String foo})', extraClasses: []);

    expect(type.className, '_Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'String')
          .having((t) => t.recordFieldName, 'recordFieldName', 'foo')
          .having((t) => t.nullable, 'nullable', isFalse)
    ]);
  });

  test(
      'Given a field type of a record holding a named nullable field, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType('({String? foo,})', extraClasses: []);

    expect(type.className, '_Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'String')
          .having((t) => t.recordFieldName, 'recordFieldName', 'foo')
          .having((t) => t.nullable, 'nullable', isTrue)
    ]);
  });

  test(
      'Given a field type of a record holding a named nullable field with extra whitespace in the definition, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType('({List< String >? namedList,})', extraClasses: []);

    expect(type.className, '_Record');
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

  test(
      'Given a field type of a record holding a nested record as a positional field in the definition, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType('((String, int),)?', extraClasses: []);

    expect(type.className, '_Record');
    expect(type.nullable, isTrue);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', '_Record')
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

  test(
      'Given a field type of a record holding a positional field with a "hint name" in the definition, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType('(String namedPositional,)', extraClasses: []);

    expect(type.className, '_Record');
    expect(type.nullable, isFalse);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', 'String')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isFalse),
    ]);
  });

  test(
      'Given a field type of a record holding a positional field with generic parameters and a "hint name" in the definition, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType('(Map<String, int> positionalMap,)', extraClasses: []);

    expect(type.className, '_Record');
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

  test(
      'Given a field type of a record holding a positional field with generic parameters and a "hint name" and extra whitespace in the definition, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType(
      '( List < Set < String > > listOfString,)',
      extraClasses: [],
    );

    expect(type.className, '_Record');
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
  test(
      'Given a field type of a record holding a nullable positional field with generic parameters, a "hint name", and extra whitespace in the definition in the definition, when it is parsed, then the correct type definition is returned.',
      () {
    // Technically even `String ?foo` would be valid Dart, though it's currently not supported in the "split parser"
    var type =
        parseType('( List < bool > ? optionalListOfBool, )', extraClasses: []);

    expect(type.className, '_Record');
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

  test(
      'Given a field type of a record holding a positional field with generic parameters on the type definition, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType('(Map<String, bool?>,)', extraClasses: []);

    expect(type.className, '_Record');
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

  test(
      'Given a field type of a record holding positional and named fields with nested record types on the type definition, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType(
      '((int, String?) nestedPositionalRecord, {(bool, Duration?) namedNestedRecord})?',
      extraClasses: [],
    );

    expect(type.className, '_Record');
    expect(type.nullable, isTrue);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', '_Record')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isFalse)
          .having(
        (t) => t.generics,
        'generics',
        [
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'int')
              .having((t) => t.nullable, 'nullable', isFalse),
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'String')
              .having((t) => t.nullable, 'nullable', isTrue),
        ],
      ),
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', '_Record')
          .having(
            (t) => t.recordFieldName,
            'recordFieldName',
            'namedNestedRecord',
          )
          .having((t) => t.nullable, 'nullable', isFalse)
          .having(
        (t) => t.generics,
        'generics',
        [
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'bool')
              .having((t) => t.nullable, 'nullable', isFalse),
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'Duration')
              .having((t) => t.nullable, 'nullable', isTrue),
        ],
      ),
    ]);
  });

  test(
      'Given a field type of a record holding positional and named field with nested generics in record types on the type definition, when it is parsed, then the correct type definition is returned.',
      () {
    var type = parseType(
      '((List<(SimpleData,)>,) nestedRecordWithList, {(SimpleData, Map<String, SimpleData>) namedNestedRecord})?',
      extraClasses: [],
    );

    expect(type.className, '_Record');
    expect(type.nullable, isTrue);
    expect(type.generics, [
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', '_Record')
          .having((t) => t.recordFieldName, 'recordFieldName', isNull)
          .having((t) => t.nullable, 'nullable', isFalse)
          .having(
        (t) => t.generics,
        'generics',
        [
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'List')
              .having((t) => t.nullable, 'nullable', isFalse)
              .having(
            (t) => t.generics,
            'generics',
            [
              isA<TypeDefinition>()
                  .having((t) => t.className, 'className', '_Record')
                  .having((t) => t.nullable, 'nullable', isFalse)
                  .having(
                (t) => t.generics,
                'generics',
                [
                  isA<TypeDefinition>()
                      .having((t) => t.className, 'className', 'SimpleData')
                      .having((t) => t.nullable, 'nullable', isFalse)
                      .having(
                        (t) => t.recordFieldName,
                        'recordFieldName',
                        isNull,
                      ),
                ],
              ),
            ],
          ),
        ],
      ),
      isA<TypeDefinition>()
          .having((t) => t.className, 'className', '_Record')
          .having(
            (t) => t.recordFieldName,
            'recordFieldName',
            'namedNestedRecord',
          )
          .having((t) => t.nullable, 'nullable', isFalse)
          .having(
        (t) => t.generics,
        'generics',
        [
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'SimpleData')
              .having((t) => t.nullable, 'nullable', isFalse),
          isA<TypeDefinition>()
              .having((t) => t.className, 'className', 'Map')
              .having((t) => t.nullable, 'nullable', isFalse)
              .having(
            (t) => t.generics,
            'generics',
            [
              isA<TypeDefinition>()
                  .having((t) => t.className, 'className', 'String')
                  .having((t) => t.nullable, 'nullable', isFalse),
              isA<TypeDefinition>()
                  .having((t) => t.className, 'className', 'SimpleData')
                  .having((t) => t.nullable, 'nullable', isFalse),
            ],
          ),
        ],
      ),
    ]);
  });

  test(
    'Given a field type of a vector when it is parsed then the correct type definition is returned.',
    () {
      var type = parseType('Vector(512)?', extraClasses: []);
      expect(type.className, 'Vector');
      expect(type.nullable, isTrue);
      expect(type.vectorDimension, 512);
    },
  );

  test(
    'Given a field type of a half vector when it is parsed then the correct type definition is returned.',
    () {
      var type = parseType('HalfVector(256)', extraClasses: []);
      expect(type.className, 'HalfVector');
      expect(type.nullable, isFalse);
      expect(type.vectorDimension, 256);
    },
  );

  test(
    'Given a field type of a sparse vector when it is parsed then the correct type definition is returned.',
    () {
      var type = parseType('SparseVector(1024)?', extraClasses: []);
      expect(type.className, 'SparseVector');
      expect(type.nullable, isTrue);
      expect(type.vectorDimension, 1024);
    },
  );

  test(
    'Given a field type of a bit vector when it is parsed then the correct type definition is returned.',
    () {
      var type = parseType('Bit(64)', extraClasses: []);
      expect(type.className, 'Bit');
      expect(type.nullable, isFalse);
      expect(type.vectorDimension, 64);
    },
  );
}
