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
}
