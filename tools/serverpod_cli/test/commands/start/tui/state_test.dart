import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/start/tui/tab_model.dart';
import 'package:serverpod_tui/serverpod_tui.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a ServerWatchState with configured apps '
    'when created '
    'then defaults are correct',
    () {
      final state = ServerWatchState();

      expect(state.logHistory, isEmpty);
      expect(state.rawLines, isEmpty);
      expect(state.activeOperations, isEmpty);
      expect(state.tabs.focusedAreaIndex, 0);
      expect(state.tabs.areaOf(kMainArea).tabs, hasLength(1));
      expect(state.actionBusy, isFalse);
      expect(state.serverReady, isFalse);
      expect(state.showSplash, isTrue);
      expect(state.showHelp, isFalse);
    },
  );

  group('Given a ServerWatchState with entries in every log buffer', () {
    late ServerWatchState state;
    late AppLogTab appTab;

    setUp(() {
      state = ServerWatchState();
      appTab = state.getOrCreateAppLogTab(appId: 'app', label: 'App');
      state.logHistory.add('server entry');
      state.rawLines.add('raw server line');
      appTab.lines.add('raw flutter line');
    });

    test('when clearLogs is called then every log buffer is emptied', () {
      state.clearLogs();

      expect(state.logHistory, isEmpty);
      expect(state.rawLines, isEmpty);
      expect(appTab.lines, isEmpty);
    });
  });

  group(
    'Given a ServerWatchState with in-progress operations and log entries',
    () {
      late ServerWatchState state;
      late TrackedOperation operation;
      late AppLogTab appTab;

      setUp(() {
        state = ServerWatchState();
        operation = TrackedOperation(id: 'hot-reload', label: 'Hot reload');
        state.activeOperations[operation.id] = operation;
        appTab = state.getOrCreateAppLogTab(appId: 'app', label: 'App');
        state.logHistory.add('server entry');
        state.rawLines.add('raw server line');
        appTab.lines.add('raw flutter line');
      });

      test('when clearLogs is called then activeOperations are preserved', () {
        state.clearLogs();

        expect(state.activeOperations, hasLength(1));
        expect(state.activeOperations[operation.id], same(operation));
      });
    },
  );

  test(
    'Given a ServerWatchState without configured apps '
    'when created '
    'then only the main area exists',
    () {
      final state = ServerWatchState(hasConfiguredApps: false);

      expect(state.tabs.areas, hasLength(1));
      expect(state.tabs.areas.single.id, kMainArea);
    },
  );

  group('Given a ServerWatchState with two companion app tabs', () {
    late ServerWatchState state;
    late AppLogTab admin;
    late AppLogTab portal;

    setUp(() {
      state = ServerWatchState();
      admin = state.getOrCreateAppLogTab(appId: 'admin', label: 'Admin');
      portal = state.getOrCreateAppLogTab(appId: 'portal', label: 'Portal');
    });

    test(
      'when a log line is appended to each app '
      'then each tab keeps only its own lines',
      () {
        admin.lines.add('admin stdout');
        portal.lines.add('portal stderr');

        expect(state.appLogTabFor('admin')!.lines, ['admin stdout']);
        expect(state.appLogTabFor('portal')!.lines, ['portal stderr']);
      },
    );
  });
}
