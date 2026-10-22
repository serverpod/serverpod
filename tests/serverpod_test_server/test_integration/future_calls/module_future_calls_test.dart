import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/serverpod.dart'
    show ServerpodInternalMethods;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    show ServerpodTestModuleFutureCallsGetter;
import 'package:serverpod_test_module_server/src/future_calls/test_generated_call.dart'
    as module;
import 'package:serverpod_test_module_server/src/generated/future_calls_generated_models/test_generated_call_hello_model.dart'
    as module_model;
import 'package:serverpod_test_server/src/generated/endpoints.dart'
    show ServerpodFutureCallsGetter;
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod_test_shared_module_server/serverpod_test_shared_module_server.dart'
    show ServerpodTestSharedModuleFutureCallsGetter;
import 'package:serverpod_test_shared_module_server/src/future_calls/test_generated_call.dart'
    as shared_module;
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/serverpod_config_builder.dart';

void main() {
  withServerpod(
    'Given a host and two modules with identically named future calls,',
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, _) {
      late Session session;

      setUpAll(() {
        session = sessionBuilder.build();
        addTearDown(() async {
          await FutureCallEntry.db.deleteWhere(
            session,
            where: (t) => t.identifier.equals('module-future-calls-test'),
          );
          await session.close();
        });

        module.TestGeneratedCall.receivedNames.clear();
        shared_module.TestGeneratedCall.receivedNames.clear();
      });

      group('when scheduling and executing all three future calls,', () {
        late List<FutureCallEntry> scheduled;
        late List<FutureCallEntry> remaining;

        setUpAll(() async {
          final pod = session.serverpod;
          final time = DateTime.now().toUtc();

          await pod.futureCalls
              .callAtTime(time, identifier: 'module-future-calls-test')
              .testGeneratedCall
              .hello('host');
          await pod.serverpodTestModuleFutureCalls
              .callAtTime(time, identifier: 'module-future-calls-test')
              .testGeneratedCall
              .hello('module');
          await pod.serverpodTestSharedModuleFutureCalls
              .callWithDelay(
                Duration.zero,
                identifier: 'module-future-calls-test',
              )
              .testGeneratedCall
              .hello('shared module');

          scheduled = await FutureCallEntry.db.find(
            session,
            where: (t) => t.identifier.equals('module-future-calls-test'),
          );

          await pod.futureCallManager!.runScheduledFutureCalls();

          remaining = await FutureCallEntry.db.find(
            session,
            where: (t) => t.identifier.equals('module-future-calls-test'),
          );
        });

        test(
          'then each package schedules its own handler on the host server.',
          () {
            expect(
              scheduled.map((entry) => (entry.name, entry.serverId)),
              unorderedEquals([
                (
                  'TestGeneratedCallHelloFutureCall',
                  session.serverpod.serverId,
                ),
                (
                  'serverpod_test_module.TestGeneratedCallHelloFutureCall',
                  session.serverpod.serverId,
                ),
                (
                  'serverpod_test_shared_module.TestGeneratedCallHelloFutureCall',
                  session.serverpod.serverId,
                ),
              ]),
            );
          },
        );

        test('then each module receives its own deserialized arguments.', () {
          expect(module.TestGeneratedCall.receivedNames, ['module']);
          expect(shared_module.TestGeneratedCall.receivedNames, [
            'shared module',
          ]);
        });

        test('then all three scheduled calls are consumed.', () {
          expect(remaining, isEmpty);
        });
      });
    },
  );

  group('Given a persisted call in nested modules sharing a dependency,', () {
    late Serverpod pod;
    late Session session;

    setUp(() async {
      pod = IntegrationTestServer.create(
        config: ServerpodConfigBuilder()
            .withDatabaseBuilder((database) => database.withHost('postgres'))
            .withFutureCallExecutionEnabled(false)
            .build(),
      );
      addTearDown(() => pod.shutdown(exitProcess: false));

      final moduleEndpoints = pod.endpoints.modules['serverpod_test_module']!;
      final sharedEndpoints =
          pod.endpoints.modules['serverpod_test_shared_module']!;

      // The containing module has no future calls. Its dependency is also
      // exposed directly by the host, as with transitive module dependencies.
      moduleEndpoints.modules['serverpod_test_shared_module'] = sharedEndpoints;
      pod.endpoints.modules
        ..clear()
        ..addAll({
          'container': _ModuleContainer({
            'serverpod_test_module': moduleEndpoints,
          }),
          'serverpod_test_shared_module': sharedEndpoints,
        });

      module.TestGeneratedCall.receivedNames.clear();
      shared_module.TestGeneratedCall.receivedNames.clear();

      await pod.ensureDatabase();
      session = await pod.createSession();
      addTearDown(() => session.close());
      addTearDown(() async {
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (t) => t.identifier.equals('persisted-module-call'),
        );
      });

      await FutureCallEntry.db.insertRow(
        session,
        FutureCallEntry(
          name: 'serverpod_test_module.TestGeneratedCallHelloFutureCall',
          serializedObject: module_model.TestGeneratedCallHelloModel(
            name: 'persisted',
          ).toString(),
          time: DateTime.now().toUtc(),
          serverId: pod.serverId,
          identifier: 'persisted-module-call',
        ),
      );
    });

    test(
      'when starting the host and processing due calls, '
      'then the nested handler executes without duplicate registrations.',
      () async {
        await pod.start(runInGuardedZone: false);
        await pod.futureCallManager!.runScheduledFutureCalls();

        expect(module.TestGeneratedCall.receivedNames, ['persisted']);
        expect(shared_module.TestGeneratedCall.receivedNames, isEmpty);
      },
    );
  });
}

class _ModuleContainer extends EndpointDispatch {
  _ModuleContainer(Map<String, EndpointDispatch> dependencies) {
    modules.addAll(dependencies);
  }

  @override
  void initializeEndpoints(Server server) {}
}
