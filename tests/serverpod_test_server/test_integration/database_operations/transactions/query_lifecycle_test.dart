import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'PostgreSQL query completion and connection reuse',
    rollbackDatabase: RollbackDatabase.disabled,
    configOverride: (config) => _withMaxConnections(config, 2),
    (sessionBuilder, _) {
      final releaseReservedConnection = Completer<void>();
      Future<void>? reservedConnection;

      setUpAll(() async {
        // Migrations need two connections. Reserve one after startup so that
        // every query under test must reuse the sole remaining connection.
        final connectionReserved = Completer<void>();
        reservedConnection = sessionBuilder.build().db.transaction((_) async {
          connectionReserved.complete();

          await releaseReservedConnection.future;
        });

        await Future.any([connectionReserved.future, reservedConnection!]);
      });

      tearDownAll(() async {
        releaseReservedConnection.complete();

        await reservedConnection;
      });

      group('Given a transaction selecting 512 large rows,', () {
        late Session session;
        late String payload;

        setUpAll(() {
          session = sessionBuilder.build();
          payload = 'x' * 4096;
        });

        group('when the query completes and another query follows,', () {
          late DatabaseResult result;
          late DatabaseResult nextResult;

          setUpAll(() async {
            await session.db.transaction((transaction) async {
              result = await session.db.unsafeQuery(
                'SELECT n, @payload::text AS payload '
                'FROM generate_series(1, 512) AS n ORDER BY n '
                '/* ${'q' * 16384} */',
                parameters: QueryParameters.named({'payload': payload}),
                transaction: transaction,
              );

              nextResult = await session.db.unsafeQuery(
                'SELECT 42',
                transaction: transaction,
              );
            });
          });

          test('then every row and its complete value are returned.', () {
            expect(
              result.map((row) => row.toList()).toList(),
              List.generate(512, (index) => [index + 1, payload]),
            );
            expect(result.affectedRowCount, 512);
          });

          test('then the following query receives its own result.', () {
            expect(nextResult.single.toList(), [42]);
          });
        });
      });

      group('Given a transaction that inserts a row before cancellation,', () {
        late Session session;

        setUpAll(() {
          session = sessionBuilder.build();
        });

        group('when the transaction is explicitly cancelled,', () {
          late int originalBackend;
          late DatabaseResult reusedConnection;
          late int insertedId;

          setUpAll(() async {
            await session.db.transaction((transaction) async {
              final backend = await session.db.unsafeQuery(
                'SELECT pg_backend_pid()',
                transaction: transaction,
              );
              originalBackend = backend.single[0] as int;

              final row = await SimpleData.db.insertRow(
                session,
                SimpleData(num: 11),
                transaction: transaction,
              );
              insertedId = row.id!;

              await transaction.cancel();
            });

            reusedConnection = await session.db.transaction((transaction) {
              return session.db.unsafeQuery(
                'SELECT pg_backend_pid(), count(*) FROM simple_data '
                'WHERE id = @id',
                parameters: QueryParameters.named({'id': insertedId}),
                transaction: transaction,
              );
            });
          });

          test('then the inserted row is rolled back.', () {
            expect(reusedConnection.single[1], 0);
          });

          test('then a new transaction reuses the same backend.', () {
            expect(reusedConnection.single[0], originalBackend);
          });
        });
      });

      group('Given a transaction that inserts a row before a slow query,', () {
        late Session session;

        setUpAll(() {
          session = sessionBuilder.build();
        });

        group('when a query timeout is handled inside the transaction,', () {
          late int originalBackend;
          late int insertedId;
          late DatabaseResult reusedConnection;
          Object? queryError;

          setUpAll(() async {
            try {
              await session.db.transaction((transaction) async {
                final backend = await session.db.unsafeQuery(
                  'SELECT pg_backend_pid()',
                  transaction: transaction,
                );
                originalBackend = backend.single[0] as int;

                final row = await SimpleData.db.insertRow(
                  session,
                  SimpleData(num: 22),
                  transaction: transaction,
                );
                insertedId = row.id!;

                try {
                  await session.db.unsafeQuery(
                    'SELECT pg_sleep(30)',
                    timeoutInSeconds: 1,
                    transaction: transaction,
                  );
                } on DatabaseQueryException catch (error) {
                  queryError = error;
                }
              });
            } catch (error) {
              queryError = error;
            }

            reusedConnection = await session.db.transaction((transaction) {
              return session.db.unsafeQuery(
                'SELECT pg_backend_pid(), count(*) FROM simple_data '
                'WHERE id = @id',
                parameters: QueryParameters.named({'id': insertedId}),
                transaction: transaction,
              );
            });
          });

          test('then PostgreSQL reports query cancellation.', () {
            expect(
              queryError,
              isA<DatabaseQueryException>().having(
                (error) => error.code,
                'SQLSTATE',
                '57014',
              ),
            );
          });

          test('then the inserted row is rolled back.', () {
            expect(reusedConnection.single[1], 0);
          });

          test('then a new transaction reuses the same backend.', () {
            expect(reusedConnection.single[0], originalBackend);
          });
        });
      });
    },
  );

  withServerpod(
    'PostgreSQL transaction lock lifetime',
    rollbackDatabase: RollbackDatabase.disabled,
    configOverride: (config) => _withMaxConnections(config, 2),
    (sessionBuilder, _) {
      group('Given a committed row with value 42,', () {
        late Session session;
        late SimpleData row;

        setUp(() async {
          session = sessionBuilder.build();
          row = await SimpleData.db.insertRow(session, SimpleData(num: 42));
        });

        tearDown(() async {
          await SimpleData.db.deleteRow(session, row);
        });

        group('when an update completes before its transaction commits,', () {
          Object? competingLockError;
          late List<SimpleData> afterCommit;

          setUp(() async {
            competingLockError = null;

            await session.db.transaction((transaction) async {
              await SimpleData.db.updateRow(
                session,
                row.copyWith(num: 99),
                transaction: transaction,
              );

              // A second completed query must not release the update's lock.
              await session.db.unsafeQuery(
                'SELECT 1',
                transaction: transaction,
              );

              try {
                await _lockRow(session, row.id!);
              } catch (error) {
                competingLockError = error;
              }
            });

            afterCommit = await _lockRow(session, row.id!);
          });

          test(
            'then another transaction cannot lock the row before commit.',
            () {
              expect(competingLockError, _lockUnavailable);
            },
          );

          test('then the row can be locked with its committed value.', () {
            expect(afterCommit.single.num, 99);
          });
        });

        group(
          'when an update completes before its transaction rolls back,',
          () {
            Object? competingLockError;
            late List<SimpleData> afterRollback;

            setUp(() async {
              competingLockError = null;

              await session.db.transaction((transaction) async {
                await SimpleData.db.updateRow(
                  session,
                  row.copyWith(num: 99),
                  transaction: transaction,
                );

                await session.db.unsafeQuery(
                  'SELECT 1',
                  transaction: transaction,
                );

                try {
                  await _lockRow(session, row.id!);
                } catch (error) {
                  competingLockError = error;
                }

                await transaction.cancel();
              });

              afterRollback = await _lockRow(session, row.id!);
            });

            test(
              'then another transaction cannot lock the row before rollback.',
              () {
                expect(competingLockError, _lockUnavailable);
              },
            );

            test('then the row can be locked with its original value.', () {
              expect(afterRollback.single.num, 42);
            });
          },
        );
      });
    },
  );
}

final _lockUnavailable = isA<DatabaseQueryException>().having(
  (error) => error.code,
  'SQLSTATE',
  '55P03',
);

Future<List<SimpleData>> _lockRow(Session session, int id) {
  return session.db.transaction((transaction) {
    return SimpleData.db.find(
      session,
      where: (table) => table.id.equals(id),
      lockMode: LockMode.forUpdate,
      lockBehavior: LockBehavior.noWait,
      transaction: transaction,
    );
  });
}

ServerpodConfig _withMaxConnections(ServerpodConfig config, int count) {
  final database = config.database! as PostgresDatabaseConfig;

  return config.copyWith(
    database: PostgresDatabaseConfig(
      host: database.host,
      port: database.port,
      user: database.user,
      password: database.password,
      name: database.name,
      requireSsl: database.requireSsl,
      isUnixSocket: database.isUnixSocket,
      searchPaths: database.searchPaths,
      dataPath: database.dataPath,
      maxConnectionCount: count,
    ),
  );
}
