import 'package:serverpod_test_module_server/serverpod_test_module_server.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given TestToolsEndpoint',
    (sessionBuilder, endpoints) {
      test('when calling returnsString then echoes string', () async {
        final result = await endpoints.testTools.returnsString(
          sessionBuilder,
          "Hello",
        );
        expect(result, 'Hello');
      });

      test('when calling returnsStream then returns a stream', () async {
        final result = await endpoints.testTools
            .returnsStream(sessionBuilder, 3)
            .toList();
        expect(result, [0, 1, 2]);
      });

      test(
        'when calling returnsListFromInputStream then returns a list of the input stream',
        () async {
          final stream = Stream<int>.fromIterable([1, 2, 3, 4, 5]);
          final result = await endpoints.testTools.returnsListFromInputStream(
            sessionBuilder,
            stream,
          );
          expect(result, [1, 2, 3, 4, 5]);
        },
      );

      test(
        'when calling returnsSimpleDataListFromInputStream then returns a list of the input stream',
        () async {
          final stream = Stream<SimpleData>.fromIterable([
            SimpleData(num: 1),
            SimpleData(num: 2),
            SimpleData(num: 3),
          ]);
          final result = await endpoints.testTools
              .returnsSimpleDataListFromInputStream(sessionBuilder, stream);
          expect(result.map((s) => s.num), [1, 2, 3]);
        },
      );

      test(
        'when calling returnsStreamFromInputStream then echoes the input stream back',
        () async {
          final stream = Stream<int>.fromIterable([1, 2, 3, 4, 5]);
          final result = endpoints.testTools.returnsStreamFromInputStream(
            sessionBuilder,
            stream,
          );
          await expectLater(result, emitsInOrder([1, 2, 3, 4, 5]));
        },
      );

      test(
        'when calling returnsSimpleDataStreamFromInputStream then echoes the input stream back',
        () async {
          final stream = Stream<SimpleData>.fromIterable([
            SimpleData(num: 1),
            SimpleData(num: 2),
            SimpleData(num: 3),
          ]);

          final result = await endpoints.testTools
              .returnsSimpleDataStreamFromInputStream(sessionBuilder, stream)
              .toList();
          expect(result.map((s) => s.num), [1, 2, 3]);
        },
      );

      test(
        'when calling postNumberToSharedStream and listenForNumbersOnSharedStream with different sessions then number should be echoed',
        () async {
          var userSession1 = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              '1',
              {},
            ),
          );
          var userSession2 = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              '2',
              {},
            ),
          );

          var stream = endpoints.testTools.listenForNumbersOnSharedStream(
            userSession1,
          );
          await flushEventQueue();

          await endpoints.testTools.postNumberToSharedStream(userSession2, 111);
          await endpoints.testTools.postNumberToSharedStream(userSession2, 222);

          await expectLater(stream.take(2), emitsInOrder([111, 222]));
        },
      );

      test(
        'when calling postNumberToSharedStreamAndReturnStream without listening to the return stream then number should still be posted',
        () async {
          var stream = endpoints.testTools.listenForNumbersOnSharedStream(
            sessionBuilder,
          );

          endpoints.testTools.postNumberToSharedStreamAndReturnStream(
            sessionBuilder,
            111,
          );

          await expectLater(stream.take(1), emitsInOrder([111]));
        },
      );

      test('when calling echoSimpleData then should echo the object', () async {
        final data = SimpleData(num: 1);
        var result = await endpoints.testTools.echoSimpleData(
          sessionBuilder,
          data,
        );
        expect(result.num, 1);
      });

      test(
        'when calling echoSimpleDatas then should echo the object',
        () async {
          final data1 = SimpleData(num: 1);
          final data2 = SimpleData(num: 2);
          var result = await endpoints.testTools.echoSimpleDatas(
            sessionBuilder,
            [data1, data2],
          );
          expect(result[0].num, 1);
          expect(result[1].num, 2);
        },
      );

      test(
        'when calling echoTypes then should return the `Types` model',
        () async {
          final types = Types(
            aRecord: ('hello', optionalUri: Uri.parse('world://')),
          );
          var result = await endpoints.testTools.echoTypes(
            sessionBuilder,
            types,
          );

          expect(
            result.aRecord,
            ('hello', optionalUri: Uri.parse('world://')),
          );
        },
      );

      test(
        'when calling echoTypesList then should return the `Types` models',
        () async {
          final typesList = [
            Types(aRecord: ('hello', optionalUri: null)),
            Types(aRecord: ('world', optionalUri: null)),
          ];
          var result = await endpoints.testTools.echoTypesList(
            sessionBuilder,
            typesList,
          );

          expect(result, hasLength(2));
          expect(result.first.aRecord?.$1, 'hello');
          expect(result.last.aRecord?.$1, 'world');
        },
      );

      test(
        'when calling echoModuleDatatype then should return the model',
        () async {
          final model = ModuleDatatype(
            model: ModuleClass(name: 'hello', data: 1, record: (true,)),
            list: [],
            map: {},
            record: (ModuleClass(name: 'world', data: 2, record: (false,)),),
          );

          var result = await endpoints.testTools.echoModuleDatatype(
            sessionBuilder,
            model,
          );

          expect(
            result.model,
            isA<ModuleClass>()
                .having((m) => m.name, 'name', 'hello')
                .having((m) => m.data, 'data', 1)
                .having((m) => m.record, 'record', (true,)),
          );
          expect(
            result.record?.$1,
            isA<ModuleClass>()
                .having((m) => m.name, 'name', 'world')
                .having((m) => m.data, 'data', 2)
                .having((m) => m.record, 'record', (false,)),
          );
        },
      );

      test(
        'when calling streamModuleDatatype then should return the models',
        () async {
          final initial = ModuleDatatype(
            model: ModuleClass(name: 'hello', data: 1, record: (true,)),
            list: [],
            map: {},
            record: (ModuleClass(name: 'world', data: 2, record: (false,)),),
          );
          final streamed = [
            ModuleDatatype(
              model: ModuleClass(name: 'lorem', data: 3, record: (true,)),
              list: [],
              map: {},
              record: (ModuleClass(name: 'ipsum', data: 4, record: (false,)),),
            ),
          ];

          var result = endpoints.testTools.streamModuleDatatype(
            sessionBuilder,
            initial,
            Stream.fromIterable(streamed),
          );

          expect(
            result,
            emitsInOrder(
              [
                isA<ModuleDatatype>()
                    .having(
                      ((m) => m.model),
                      'model',
                      isA<ModuleClass>()
                          .having((m) => m.name, 'name', 'hello')
                          .having((m) => m.data, 'data', 1)
                          .having((m) => m.record, 'record', (true,)),
                    )
                    .having(
                      ((m) => m.record?.$1),
                      'record.\$1',
                      isA<ModuleClass>()
                          .having((m) => m.name, 'name', 'world')
                          .having((m) => m.data, 'data', 2)
                          .having((m) => m.record, 'record', (false,)),
                    ),
                isA<ModuleDatatype>()
                    .having(
                      ((m) => m.model),
                      'model',
                      isA<ModuleClass>()
                          .having((m) => m.name, 'name', 'lorem')
                          .having((m) => m.data, 'data', 3)
                          .having((m) => m.record, 'record', (true,)),
                    )
                    .having(
                      ((m) => m.record?.$1),
                      'record.\$1',
                      isA<ModuleClass>()
                          .having((m) => m.name, 'name', 'ipsum')
                          .having((m) => m.data, 'data', 4)
                          .having((m) => m.record, 'record', (false,)),
                    ),
              ],
            ),
          );
        },
      );

      test(
        'when calling echoModuleClass then should return the model',
        () async {
          final model = ModuleClass(name: 'hello', data: 1, record: (true,));

          var result = await endpoints.testTools.echoModuleClass(
            sessionBuilder,
            model,
          );

          expect(result.name, 'hello');
          expect(result.data, 1);
          expect(result.record, (true,));
        },
      );

      test(
        'when calling streamModuleClass then should return the models',
        () async {
          final initial = ModuleClass(name: 'hello', data: 1, record: (true,));
          final streamed = [
            ModuleClass(name: 'world', data: 2, record: (false,)),
          ];

          var result = endpoints.testTools.streamModuleClass(
            sessionBuilder,
            initial,
            Stream.fromIterable(streamed),
          );

          expect(
            result,
            emitsInOrder(
              [
                isA<ModuleClass>()
                    .having((m) => m.name, 'name', 'hello')
                    .having((m) => m.data, 'data', 1)
                    .having((m) => m.record, 'record', (true,)),
                isA<ModuleClass>()
                    .having((m) => m.name, 'name', 'world')
                    .having((m) => m.data, 'data', 2)
                    .having((m) => m.record, 'record', (false,)),
              ],
            ),
          );
        },
      );

      test('when calling echoRecord then should return the record', () async {
        final record = ('hello', (2, true));
        var result = await endpoints.testTools.echoRecord(
          sessionBuilder,
          record,
        );
        expect(result, record);
      });

      test('when calling echoRecords then should return the records', () async {
        final records = [
          ('hello', (2, true)),
          ('world', (4, false)),
        ];

        var result = await endpoints.testTools.echoRecords(
          sessionBuilder,
          records,
        );
        expect(result, records);
      });

      test(
        'when calling recordEchoStream then should return the records',
        () async {
          final records =
              <
                (String, (Map<String, int>, {bool flag, SimpleData simpleData}))
              >[
                (
                  'hello',
                  ({'world': 1}, flag: true, simpleData: SimpleData(num: 2)),
                ),
                (
                  'hi',
                  ({'world': 3}, flag: true, simpleData: SimpleData(num: 4)),
                ),
              ];

          var result = endpoints.testTools.recordEchoStream(
            sessionBuilder,
            records.first,
            Stream.fromIterable(records.skip(1)),
          );

          expect(
            result,
            emitsInOrder([
              isA<
                    (
                      String,
                      (Map<String, int>, {bool flag, SimpleData simpleData}),
                    )
                  >()
                  .having(
                    (r) => r.$1,
                    'first positional',
                    'hello',
                  )
                  .having(
                    (r) => r.$2,
                    'second positional',
                    isA<
                          (Map<String, int>, {bool flag, SimpleData simpleData})
                        >()
                        .having(
                          (r) => r.$1,
                          'first positional',
                          {'world': 1},
                        )
                        .having((r) => r.flag, 'flag', isTrue)
                        .having(
                          (r) => r.simpleData,
                          'simpleData',
                          isA<SimpleData>().having(
                            (s) => s.num,
                            'num',
                            2,
                          ),
                        ),
                  ),
              isA<
                    (
                      String,
                      (Map<String, int>, {bool flag, SimpleData simpleData}),
                    )
                  >()
                  .having(
                    (r) => r.$1,
                    'first positional',
                    'hi',
                  )
                  .having(
                    (r) => r.$2,
                    'second positional',
                    isA<
                          (Map<String, int>, {bool flag, SimpleData simpleData})
                        >()
                        .having(
                          (r) => r.$1,
                          'first positional',
                          {'world': 3},
                        )
                        .having((r) => r.flag, 'flag', isTrue)
                        .having(
                          (r) => r.simpleData,
                          'simpleData',
                          isA<SimpleData>().having(
                            (s) => s.num,
                            'num',
                            4,
                          ),
                        ),
                  ),
            ]),
          );
        },
      );

      test(
        'when calling listOfRecordEchoStream then should return the records',
        () async {
          final lists = <List<(String, int)>>[
            [
              ('hello', 1),
              ('world', 2),
            ],
            [
              ('streamed', 3),
              ('value', 4),
            ],
            [
              ('value2', 5),
              ('value3', 6),
            ],
          ];

          var result = endpoints.testTools.listOfRecordEchoStream(
            sessionBuilder,
            lists.first,
            Stream.fromIterable(lists.skip(1)),
          );

          expect(
            result,
            emitsInOrder(lists),
          );
        },
      );

      test(
        'when calling nullableRecordEchoStream then should return the records',
        () async {
          final records =
              <
                (
                  String,
                  (Map<String, int>, {bool flag, SimpleData simpleData}),
                )?
              >[
                null,
                null,
              ];

          var result = endpoints.testTools.nullableRecordEchoStream(
            sessionBuilder,
            records.first,
            Stream.fromIterable(records.skip(1)),
          );

          expect(
            result,
            emitsInOrder([
              isNull,
              isNull,
            ]),
          );
        },
      );

      test(
        'when calling nullableListOfRecordEchoStream then should return the records',
        () async {
          final lists = <List<(String, int)>?>[
            [
              ('hello', 1),
              ('world', 2),
            ],
            null,
            [
              ('streamed', 3),
              ('value', 4),
            ],
            null,
            [
              ('value2', 5),
              ('value3', 6),
            ],
            null,
          ];

          var result = endpoints.testTools.nullableListOfRecordEchoStream(
            sessionBuilder,
            lists.first,
            Stream.fromIterable(lists.skip(1)),
          );

          expect(
            result,
            emitsInOrder(lists),
          );
        },
      );

      test(
        'when calling modelWithRecordsEchoStream then should return the models',
        () async {
          final lists = <TypesRecord?>[
            TypesRecord(anInt: (1,)),
            TypesRecord(aUri: (Uri.parse('http://serverpod.dev'),)),
            null,
            TypesRecord(aSimpleData: (SimpleData(num: 2),)),
          ];

          var result = endpoints.testTools.modelWithRecordsEchoStream(
            sessionBuilder,
            lists.first,
            Stream.fromIterable(lists.skip(1)),
          );

          expect(
            result,
            emitsInOrder(
              [
                isA<TypesRecord>().having((m) => m.anInt, 'anInt', (1,)),
                isA<TypesRecord>().having(
                  (m) => m.aUri?.$1,
                  'aUri',
                  Uri.parse('http://serverpod.dev'),
                ),
                isNull,
                isA<TypesRecord>().having(
                  (m) => m.aSimpleData?.$1,
                  'aSimpleData',
                  isA<SimpleData>().having((s) => s.num, 'num', 2),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
