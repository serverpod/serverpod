import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/database_result.dart';
import 'package:test/test.dart';

class _CitizenTable extends Table {
  _CitizenTable() : super(tableName: 'citizen') {
    column1 = ColumnString(
      'name',
      this,
    );
    column2 = ColumnInt(
      'companyId',
      this,
    );
  }

  late final ColumnString column1;
  late final ColumnInt column2;

  @override
  List<Column> get columns => [column1, column2];
}

void main() {
  var mockCitizenTable = _CitizenTable();
  var resolvedListRelations = <String, Map<int, List<dynamic>>>{};

  group('Given resolvePrefixedQueryRow', () {
    group('when viewTable is true', () {
      var viewTable = true;
      test(
          'should return assertion error when viewTable is true and rawRow is not [""]',
          () {
        Map<String, Map<String, dynamic>> rawRow = {
          'citizen': {
            'table.column1': 'JohnDoe',
            'table.column2': 101,
          }
        };

        expect(
            () => resolvePrefixedQueryRow(
                  mockCitizenTable,
                  rawRow,
                  resolvedListRelations,
                  viewTable: viewTable,
                ),
            throwsA(isA<AssertionError>()));
      });

      test('should return the data when viewTable is true and rawRow is [""]',
          () {
        var viewTable = true;
        Map<String, Map<String, dynamic>> rawRow = {
          '': {
            'citizen.name': 'JohnDoe',
            'citizen.companyId': 101,
          }
        };

        var res = resolvePrefixedQueryRow(
          mockCitizenTable,
          rawRow,
          resolvedListRelations,
          viewTable: viewTable,
        );

        // Assert
        expect(res, {
          'name': 'JohnDoe',
          'companyId': 101,
        });
      });
    });

    group('when viewTable is false', () {
      var viewTable = false;

      test('should return null when rawRow is empty', () {
        Map<String, Map<String, dynamic>> rawRow = {};

        var result = resolvePrefixedQueryRow(
          mockCitizenTable,
          rawRow,
          resolvedListRelations,
          viewTable: viewTable,
        );

        expect(result, isNull);
      });

      test('should return resolvedTableRow when rawRow is valid', () {
        Map<String, Map<String, dynamic>> rawRow = {
          'citizen': {
            'citizen.name': 'JohnDoe',
            'citizen.companyId': 101,
          }
        };

        var result = resolvePrefixedQueryRow(
          mockCitizenTable,
          rawRow,
          resolvedListRelations,
          viewTable: viewTable,
        );

        expect(result, isNotNull);
        expect(result?['name'], equals('JohnDoe'));
        expect(result?['companyId'], equals(101));
      });

      test('should return resolvedTableRow when rawRow is valid', () {
        Map<String, Map<String, dynamic>> rawRow = {
          'citizen': {
            'citizen.name': 'JohnDoe',
            'citizen.companyId': 101,
          }
        };

        var result = resolvePrefixedQueryRow(
          mockCitizenTable,
          rawRow,
          resolvedListRelations,
          viewTable: false,
        );

        expect(result, isNotNull);
        expect(result?['name'], equals('JohnDoe'));
        expect(result?['companyId'], equals(101));
      });
    });
  });
}
