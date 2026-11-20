import 'dart:convert';

import 'package:serverpod/protocol.dart' as internal;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_database/serverpod_database.dart' as database;
import 'package:serverpod_test_client/serverpod_test_client.dart' as client;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as module;
import 'package:serverpod_test_server/src/generated/protocol.dart' as server;
import 'package:test/test.dart';

void main() {
  test(
    'Given a shared database model envelope with an unqualified class name, '
    'when the internal protocol decodes it, '
    'then it decodes the shared model directly.',
    () {
      final model = database.BulkQueryColumnDescription(
        name: 'value',
      );
      final envelope = {
        'className': 'BulkQueryColumnDescription',
        'data': model.toJson(),
      };

      final decoded = internal.Protocol().deserializeByClassName(envelope);

      expect(decoded, isA<database.BulkQueryColumnDescription>());
      expect(
        (decoded as database.BulkQueryColumnDescription).toJson(),
        model.toJson(),
      );
    },
  );

  test(
    'Given a shared database model envelope with its existing package-prefixed alias, '
    'when the internal protocol decodes it, '
    'then it continues to decode the shared model.',
    () {
      final model = database.BulkQueryColumnDescription(
        name: 'value',
      );
      final envelope = {
        'className': 'serverpod_database.BulkQueryColumnDescription',
        'data': model.toJson(),
      };

      final decoded = internal.Protocol().deserializeByClassName(envelope);

      expect(decoded, isA<database.BulkQueryColumnDescription>());
      expect(
        (decoded as database.BulkQueryColumnDescription).toJson(),
        model.toJson(),
      );
    },
  );

  group(
    'Given a module model containing an internal model in a dynamic field,',
    () {
      late Map<String, dynamic> payload;
      late String before;

      setUpAll(() {
        final model = module.DynamicOnModule(
          name: 'entry',
          data: internal.DistributedCacheEntry(data: 'cached value'),
        );
        payload = jsonDecode(jsonEncode(model)) as Map<String, dynamic>;
        before = jsonEncode(payload);
      });

      group('when decoding its JSON twice,', () {
        late module.DynamicOnModule first;
        late module.DynamicOnModule second;
        late String after;

        setUpAll(() {
          first = module.DynamicOnModule.fromJson(payload);
          second = module.DynamicOnModule.fromJson(payload);
          after = jsonEncode(payload);
        });

        test('then both decodes preserve the nested internal model.', () {
          expect(first.data, isA<internal.DistributedCacheEntry>());
          expect(second.data, isA<internal.DistributedCacheEntry>());
          expect(
            (first.data as internal.DistributedCacheEntry).data,
            'cached value',
          );
          expect(
            (second.data as internal.DistributedCacheEntry).data,
            'cached value',
          );
        });

        test('then the source JSON remains unchanged.', () {
          expect(after, before);
        });
      });
    },
  );

  test(
    'Given different generated serialization protocols, '
    'when Dart infers the type of their collection, '
    'then the existing serialization API stays available.',
    () {
      final protocols = [client.Protocol(), server.Protocol()];

      final names = protocols
          .map((protocol) => protocol.getModuleName())
          .toList();

      expect(names, ['serverpod_test', 'serverpod_test']);
    },
  );

  test(
    'Given different generated database protocols, '
    'when Dart infers the type of their collection, '
    'then the existing database API stays available.',
    () {
      final protocols = [server.Protocol(), module.Protocol()];

      final definitions = protocols
          .map((protocol) => protocol.getTargetTableDefinitions())
          .toList();

      expect(definitions, hasLength(2));
      expect(definitions.first, isNotEmpty);
      expect(definitions.last, isEmpty);
    },
  );

  test(
    'Given an unqualified module subtype discriminator and a broad requested type, '
    'when the project decodes the payload, '
    'then the existing module class-name fallback resolves the subtype.',
    () {
      final payload = {
        '__className__': 'ModulePolymorphicChild',
        'parent': 'base',
        'child': 'child',
      };

      final result = server.Protocol().deserialize<Object>(payload);

      expect(
        result,
        isA<module.ModulePolymorphicChild>()
            .having((value) => value.parent, 'parent', 'base')
            .having((value) => value.child, 'child', 'child'),
      );
    },
  );

  test(
    'Given an ORM-shaped module row without a discriminator, '
    'when the project decodes it using an explicit type, '
    'then module fields and its nested record are preserved.',
    () {
      final payload = {
        'name': 'entry',
        'data': 7,
        'record': {
          'p': [true],
        },
      };

      final result = server.Protocol().deserialize<Object>(
        payload,
        module.ModuleClass,
      );

      expect(
        result,
        isA<module.ModuleClass>()
            .having((value) => value.name, 'name', 'entry')
            .having((value) => value.data, 'data', 7)
            .having((value) => value.record, 'record', (true,)),
      );
    },
  );

  test(
    'Given successive rows of the same module type, '
    'when a valid row follows a malformed row, '
    'then routing preserves the error and decodes the new values.',
    () {
      final protocol = server.Protocol();
      final first = protocol.deserialize<module.ModuleClass>({
        'name': 'first',
        'data': 1,
      });
      Object? failure;

      try {
        protocol.deserialize<module.ModuleClass>({'name': 'malformed'});
      } catch (error) {
        failure = error;
      }
      final last = protocol.deserialize<module.ModuleClass>({
        'name': 'last',
        'data': 2,
      });

      expect(failure, isA<TypeError>());
      expect(first.name, 'first');
      expect(first.data, 1);
      expect(last.name, 'last');
      expect(last.data, 2);
      expect(identical(first, last), isFalse);
    },
  );

  test(
    'Given a nullable module model without a class discriminator, '
    'when the project decodes a null value, '
    'then the declared nullable handler returns null.',
    () {
      final protocol = server.Protocol();

      final result = protocol.deserialize<module.ModuleClass?>(null);

      expect(result, isNull);
    },
  );

  test(
    'Given a project with regenerated module dependencies, '
    'when looking up a module-owned model, '
    'then unrelated generated modules are excluded from typed dispatch.',
    () {
      final protocol = server.Protocol();
      final metadata =
          (protocol as ProtocolDeserializationProvider).deserializationMetadata;

      final candidates = metadata.modulesForType(module.ModuleClass);

      expect(candidates, [module.Protocol()]);
      expect(metadata.modules.length, greaterThan(candidates.length));
    },
  );
}
