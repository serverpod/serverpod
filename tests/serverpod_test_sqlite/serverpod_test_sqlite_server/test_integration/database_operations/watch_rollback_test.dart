import 'dart:async';

import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a SQLite withServerpod group with default rollback, ',
    (sessionBuilder, endpoints) {
      test(
        'when watching a typed query, '
        'then an InvalidConfigurationException is thrown.',
        () {
          final session = sessionBuilder.build();
          expect(
            () => session.db.watch<SimpleData>(),
            throwsA(isA<InvalidConfigurationException>()),
          );
        },
      );

      test(
        'when watching a raw SQL query, '
        'then an InvalidConfigurationException is thrown.',
        () {
          final session = sessionBuilder.build();
          expect(
            () => session.db.unsafeWatch('SELECT 1;'),
            throwsA(isA<InvalidConfigurationException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a SQLite withServerpod group with rollback disabled, ',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, endpoints) {
      test(
        'when watching a typed query, '
        'then the stream emits the current rows.',
        () async {
          final session = sessionBuilder.build();
          final iterator = StreamIterator(session.db.watch<SimpleData>());
          addTearDown(iterator.cancel);

          expect(await iterator.moveNext(), isTrue);
          expect(iterator.current, isEmpty);
        },
      );
    },
  );
}
