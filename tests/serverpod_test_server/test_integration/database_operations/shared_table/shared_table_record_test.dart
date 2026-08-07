import 'package:serverpod_test_shared/serverpod_test_shared.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given an empty database,',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      test(
        'when inserting a shared table record, '
        'then the record is persisted with shared field types.',
        () async {
          var record = SharedTableRecord(
            name: 'test-record',
            sharedEnum: SharedEnum.two,
            sharedSubclass: SharedSubclass(
              name: 'subclass-name',
              data: 42,
              sharedSubclassField: 'subclass-field',
              sharedEnumField: SharedEnum.one,
            ),
            itemCount: 3,
          );

          var inserted = await SharedTableRecord.db.insertRow(session, record);

          expect(inserted.id, isNotNull);
          expect(inserted.name, 'test-record');
          expect(inserted.sharedEnum, SharedEnum.two);
          expect(
            inserted.sharedSubclass?.sharedSubclassField,
            'subclass-field',
          );
          expect(inserted.itemCount, 3);

          var fetched = await SharedTableRecord.db.findById(
            session,
            inserted.id!,
          );
          expect(fetched, isNotNull);
          expect(fetched!.name, inserted.name);
          expect(fetched.sharedEnum, inserted.sharedEnum);
          expect(
            fetched.sharedSubclass?.toJson(),
            inserted.sharedSubclass?.toJson(),
          );
          expect(fetched.itemCount, inserted.itemCount);
        },
      );

      test(
        'when inserting a shared table record without optional fields, '
        'then default values are applied.',
        () async {
          var record = SharedTableRecord(
            name: 'defaults',
            sharedEnum: SharedEnum.one,
          );

          var inserted = await SharedTableRecord.db.insertRow(session, record);

          expect(inserted.sharedSubclass, isNull);
          expect(inserted.itemCount, 0);
        },
      );
    },
  );

  withServerpod('Given a shared table record exists,', (
    sessionBuilder,
    endpoints,
  ) {
    var session = sessionBuilder.build();
    late SharedTableRecord inserted;

    setUp(() async {
      inserted = await SharedTableRecord.db.insertRow(
        session,
        SharedTableRecord(
          name: 'existing',
          sharedEnum: SharedEnum.three,
          itemCount: 1,
        ),
      );
    });

    test(
      'when updating the record by id, '
      'then the updated values are stored.',
      () async {
        var updated = inserted.copyWith(
          name: 'updated',
          sharedEnum: SharedEnum.two,
          itemCount: 5,
        );

        var result = await SharedTableRecord.db.updateRow(session, updated);

        expect(result.name, 'updated');
        expect(result.sharedEnum, SharedEnum.two);
        expect(result.itemCount, 5);

        var fetched = await SharedTableRecord.db.findById(
          session,
          inserted.id!,
        );
        expect(fetched?.name, 'updated');
        expect(fetched?.sharedEnum, SharedEnum.two);
        expect(fetched?.itemCount, 5);
      },
    );

    test(
      'when deleting the record by id, '
      'then it is removed from the database.',
      () async {
        var deleted = await SharedTableRecord.db.deleteRow(
          session,
          inserted,
        );

        expect(deleted.id, inserted.id);

        var fetched = await SharedTableRecord.db.findById(
          session,
          inserted.id!,
        );
        expect(fetched, isNull);
      },
    );
  });
}
