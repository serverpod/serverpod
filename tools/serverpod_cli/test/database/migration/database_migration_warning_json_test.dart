import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given a DatabaseMigrationWarning JSON with a misspelled key,', () {
    // Migration.json files use the misspelled "destrucive" key for backwards
    // compatibility. The model reads from this key.
    final json = {
      'type': 'tableDropped',
      'message': 'Table "example" will be dropped.',
      'table': 'example',
      'columns': <String>[],
      'destrucive': true,
    };

    test(
      'when parsing JSON with "destrucive" key then "destructive" field is set correctly.',
      () {
        final warning = DatabaseMigrationWarning.fromJson(json);

        expect(warning.destructive, isTrue);
        expect(warning.type, DatabaseMigrationWarningType.tableDropped);
        expect(warning.message, 'Table "example" will be dropped.');
        expect(warning.table, 'example');
      },
    );

    test(
      'when serializing to JSON then uses "destrucive" key for backwards compatibility.',
      () {
        final warning = DatabaseMigrationWarning(
          type: DatabaseMigrationWarningType.columnDropped,
          message: 'Column "embedding" will be dropped.',
          table: 'documents',
          columns: ['embedding'],
          destructive: true,
        );

        final json = warning.toJson();

        expect(json.containsKey('destrucive'), isTrue);
        expect(json['destrucive'], isTrue);
        expect(json.containsKey('destructive'), isFalse);
      },
    );
  });
}
