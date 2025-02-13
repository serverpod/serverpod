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
      'When creating a `TypeDefinition` from a `RecordType` with a positional field, then the fields are stored in `generics`',
      () {
    var typeDefinition = TypeDefinition.fromDartType(
      RecordType(
        nullabilitySuffix: NullabilitySuffix.none,
        positional: [emptyRecordType],
        named: {},
      ),
    );

    expect(typeDefinition.className, 'Record');
    expect(typeDefinition.generics, [
      isA<TypeDefinition>().having(
        (t) => t.recordFieldName,
        'recordFieldName',
        isNull,
      ),
    ]);
  });

  test(
      'When creating a `TypeDefinition` from a `RecordType` with a named field, then the fields are stored in `generics`',
      () {
    var typeDefinition = TypeDefinition.fromDartType(
      RecordType(
        nullabilitySuffix: NullabilitySuffix.none,
        positional: [],
        named: {'subRecord': emptyRecordType},
      ),
    );

    expect(typeDefinition.className, 'Record');
    expect(typeDefinition.generics, [
      isA<TypeDefinition>().having(
        (t) => t.recordFieldName,
        'recordFieldName',
        'subRecord',
      ),
    ]);
  });
  test(
      'When creating a `TypeDefinition` from a `RecordType` with a mixed positional and named fields, then the fields are stored in `generics`',
      () {
    var typeDefinition = TypeDefinition.fromDartType(
      RecordType(
        nullabilitySuffix: NullabilitySuffix.none,
        positional: [emptyRecordType],
        named: {'subRecord': emptyRecordType},
      ),
    );

    expect(typeDefinition.className, 'Record');
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
      'When creating a `TypeDefinition` from a `RecordType` with a mixed positional and named field containing further nested records, then the fields are stored in `generics`',
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

    expect(typeDefinition.className, 'Record');
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
}
