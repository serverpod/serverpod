import 'package:serverpod/serverpod.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

final _firstJsonbList = ['a', 'b', 'c'];
final _emptyJsonbList = <String>[];
final _specialCharactersJsonbList = [
  'plain',
  'with spaces',
  'with "quotes"',
  'with \\ backslash',
  'with \n newline',
  'with unicode \u{1F600}',
];

ObjectWithJsonb _buildRow({
  List<String>? jsonb,
  List<String>? nullableJsonb,
}) {
  return ObjectWithJsonb(
    notJsonb: ['x'],
    jsonb: jsonb ?? ['x'],
    jsonbMap: {'key': 'value'},
    jsonbObject: SimpleData(num: 1),
    jsonbIndexed: ['x'],
    jsonbIndexedGin: ['x'],
    jsonbIndexedGinJsonbPath: ['x'],
    jsonbIndexedImplicitGin: ['x'],
    nullableJsonb: nullableJsonb,
  );
}

late List<ObjectWithJsonb> _insertedRows;

Future<void> _createTestDatabase(Session session) async {
  _insertedRows = await ObjectWithJsonb.db.insert(session, [
    _buildRow(jsonb: _firstJsonbList, nullableJsonb: _firstJsonbList),
    _buildRow(jsonb: _emptyJsonbList),
    _buildRow(nullableJsonb: null),
    _buildRow(nullableJsonb: _emptyJsonbList),
    _buildRow(jsonb: _specialCharactersJsonbList),
  ]);
}

Future<void> _deleteAll(Session session) async {
  await ObjectWithJsonb.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

void main() async {
  var session = await IntegrationTestServer().session();

  setUpAll(() async => await _createTestDatabase(session));
  tearDownAll(() async => await _deleteAll(session));

  group('Given jsonb column in database', () {
    test('when fetching all then all rows are returned.', () async {
      var result = await ObjectWithJsonb.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 5);
    });

    test(
      'when fetching the row inserted with a non-empty list then the jsonb column value is returned unchanged.',
      () async {
        var result = await ObjectWithJsonb.db.findById(
          session,
          _insertedRows[0].id!,
        );

        expect(result?.jsonb, _firstJsonbList);
      },
    );

    test(
      'when fetching the row inserted with an empty list then the jsonb column value is returned as an empty list.',
      () async {
        var result = await ObjectWithJsonb.db.findById(
          session,
          _insertedRows[1].id!,
        );

        expect(result?.jsonb, isEmpty);
      },
    );

    test(
      'when fetching the row inserted with special characters then every value in the list round-trips unchanged.',
      () async {
        var result = await ObjectWithJsonb.db.findById(
          session,
          _insertedRows[4].id!,
        );

        expect(result?.jsonb, _specialCharactersJsonbList);
      },
    );
  });

  group('Given nullable jsonb column in database', () {
    test(
      'when fetching the row inserted with Dart null then the column value is null.',
      () async {
        var result = await ObjectWithJsonb.db.findById(
          session,
          _insertedRows[2].id!,
        );

        expect(result?.nullableJsonb, isNull);
      },
    );

    test(
      'when fetching the row inserted with an empty list then the column value is a non-null empty list.',
      () async {
        var result = await ObjectWithJsonb.db.findById(
          session,
          _insertedRows[3].id!,
        );

        expect(result?.nullableJsonb, isNotNull);
        expect(result?.nullableJsonb, isEmpty);
      },
    );

    test(
      'when fetching the row inserted with a non-empty list then the column value is returned unchanged.',
      () async {
        var result = await ObjectWithJsonb.db.findById(
          session,
          _insertedRows[0].id!,
        );

        expect(result?.nullableJsonb, _firstJsonbList);
      },
    );
  });

  group(
    'Given declared ObjectWithJsonbClassLevel class with `serializationDataType` set to jsonb '
    'when analyzing database schema',
    () {
      late List<ColumnDefinition> columns;

      setUpAll(() async {
        var databaseDefinition = await session.db.analyzer.analyze();

        var table = databaseDefinition.tables.firstWhere(
          (table) => table.name == 'object_with_jsonb_class_level',
        );

        columns = table.columns;
      });

      test(
        'then the column without `serializationDataType` set has type jsonb.',
        () {
          final column = columns.firstWhere(
            (idx) => idx.name == 'implicitJsonb',
          );

          expect(column.columnType, ColumnType.jsonb);
        },
      );

      test(
        'then the column with `serializationDataType` set to jsonb has type jsonb.',
        () {
          final column = columns.firstWhere(
            (idx) => idx.name == 'explicitJsonb',
          );

          expect(column.columnType, ColumnType.jsonb);
        },
      );

      test(
        'then the column with `serializationDataType` set to json has type json.',
        () {
          final column = columns.firstWhere(
            (idx) => idx.name == 'json',
          );

          expect(column.columnType, ColumnType.json);
        },
      );
    },
  );
}
