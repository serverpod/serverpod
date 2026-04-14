import 'package:serverpod/serverpod.dart';
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

late int _nonEmptyRowId;
late int _emptyRowId;
late int _nullNullableRowId;
late int _emptyNullableRowId;
late int _specialCharactersRowId;

Future<void> _createTestDatabase(Session session) async {
  var rows = await ObjectWithJsonb.db.insert(session, [
    ObjectWithJsonb(
      notJsonb: ['x'],
      jsonb: _firstJsonbList,
      jsonbIndexed: ['x'],
      jsonbIndexedGin: ['x'],
      jsonbIndexedGinJsonbPath: ['x'],
      nullableJsonb: _firstJsonbList,
    ),
    ObjectWithJsonb(
      notJsonb: ['x'],
      jsonb: _emptyJsonbList,
      jsonbIndexed: ['x'],
      jsonbIndexedGin: ['x'],
      jsonbIndexedGinJsonbPath: ['x'],
    ),
    ObjectWithJsonb(
      notJsonb: ['x'],
      jsonb: ['x'],
      jsonbIndexed: ['x'],
      jsonbIndexedGin: ['x'],
      jsonbIndexedGinJsonbPath: ['x'],
      nullableJsonb: null,
    ),
    ObjectWithJsonb(
      notJsonb: ['x'],
      jsonb: ['x'],
      jsonbIndexed: ['x'],
      jsonbIndexedGin: ['x'],
      jsonbIndexedGinJsonbPath: ['x'],
      nullableJsonb: _emptyJsonbList,
    ),
    ObjectWithJsonb(
      notJsonb: ['x'],
      jsonb: _specialCharactersJsonbList,
      jsonbIndexed: ['x'],
      jsonbIndexedGin: ['x'],
      jsonbIndexedGinJsonbPath: ['x'],
    ),
  ]);

  _nonEmptyRowId = rows[0].id!;
  _emptyRowId = rows[1].id!;
  _nullNullableRowId = rows[2].id!;
  _emptyNullableRowId = rows[3].id!;
  _specialCharactersRowId = rows[4].id!;
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
          _nonEmptyRowId,
        );

        expect(result?.jsonb, _firstJsonbList);
      },
    );

    test(
      'when fetching the row inserted with an empty list then the jsonb column value is returned as an empty list.',
      () async {
        var result = await ObjectWithJsonb.db.findById(session, _emptyRowId);

        expect(result?.jsonb, isEmpty);
      },
    );

    test(
      'when fetching the row inserted with special characters then every value in the list round-trips unchanged.',
      () async {
        var result = await ObjectWithJsonb.db.findById(
          session,
          _specialCharactersRowId,
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
          _nullNullableRowId,
        );

        expect(result?.nullableJsonb, isNull);
      },
    );

    test(
      'when fetching the row inserted with an empty list then the column value is a non-null empty list.',
      () async {
        var result = await ObjectWithJsonb.db.findById(
          session,
          _emptyNullableRowId,
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
          _nonEmptyRowId,
        );

        expect(result?.nullableJsonb, _firstJsonbList);
      },
    );
  });
}
