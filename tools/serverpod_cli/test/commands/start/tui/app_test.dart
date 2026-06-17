import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/start/tui/tab_model.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_shared/log.dart';
import 'package:test/test.dart';

Future<void> _sendCtrlC(NoctermTester tester) {
  return tester.sendKeyEvent(
    const KeyboardEvent(
      logicalKey: LogicalKey.keyC,
      modifiers: ModifierKeys(ctrl: true),
    ),
  );
}

Future<void> _sendKey(NoctermTester tester, LogicalKey key) {
  return tester.sendKeyEvent(KeyboardEvent(logicalKey: key));
}

Future<void> _sendCtrlR(NoctermTester tester) {
  return tester.sendKeyEvent(
    const KeyboardEvent(
      logicalKey: LogicalKey.keyR,
      modifiers: ModifierKeys(ctrl: true),
    ),
  );
}

Future<void> _sendShiftR(NoctermTester tester) {
  return tester.sendKeyEvent(
    const KeyboardEvent(
      logicalKey: LogicalKey.keyR,
      modifiers: ModifierKeys(shift: true),
    ),
  );
}

void main() {
  late NoctermTester tester;
  late ServerWatchState state;
  late StartAppStateHolder holder;

  setUp(() async {
    state = ServerWatchState();
    holder = StartAppStateHolder(state);
    tester = await NoctermTester.create(size: const Size(80, 24));
    await tester.pumpComponent(
      ServerpodWatchApp(holder: holder, onReady: (_) {}),
    );
  });

  tearDown(() async {
    tester.dispose();
    await holder.dispose();
  });

  group('Given a running TUI start app with onQuit callback wired', () {
    late int quitCalls;

    setUp(() {
      quitCalls = 0;
      holder.onQuit = () => quitCalls++;
    });

    test(
      'when Ctrl-C is pressed twice without a selection then onQuit is invoked',
      () async {
        await _sendCtrlC(tester);
        await _sendCtrlC(tester);

        expect(quitCalls, 1);
      },
    );
  });

  group('Given a structured log tab with a stack-traced error entry', () {
    setUp(() {
      state.logHistory.add(
        LogEntry(
          time: DateTime(2026),
          level: LogLevel.error,
          message: 'boom',
          scope: LogScope.root('server'),
          error: 'Exception: boom',
          stackTrace: StackTrace.fromString('#0 a\n#1 b'),
        ),
      );
    });

    test('when e is pressed then stack traces expand and collapse', () async {
      expect(state.expandStackTraces, isFalse);

      await _sendKey(tester, LogicalKey.keyE);
      expect(state.expandStackTraces, isTrue);

      await _sendKey(tester, LogicalKey.keyE);
      expect(state.expandStackTraces, isFalse);
    });

    test(
      'when e is pressed on an app log tab then traces do not toggle',
      () async {
        state.getOrCreateAppLogTab(appId: 'app', label: 'App');
        state.tabs.focusedAreaIndex = 1;

        await _sendKey(tester, LogicalKey.keyE);

        expect(state.expandStackTraces, isFalse);
      },
    );

    test('when backtick is pressed then the raw server logs open', () async {
      expect(state.showRawServerLogs, isFalse);

      await _sendKey(tester, LogicalKey.backquote);
      expect(state.showRawServerLogs, isTrue);

      await _sendKey(tester, LogicalKey.backquote);
      expect(state.showRawServerLogs, isFalse);
    });

    test('when period is pressed then the raw server logs open', () async {
      expect(state.showRawServerLogs, isFalse);

      await _sendKey(tester, LogicalKey.period);
      expect(state.showRawServerLogs, isTrue);

      await _sendKey(tester, LogicalKey.period);
      expect(state.showRawServerLogs, isFalse);
    });
  });

  group('Given the raw server logs overlay is open', () {
    setUp(() {
      state.showRawServerLogs = true;
    });

    test('when Esc is pressed then it closes', () async {
      await _sendKey(tester, LogicalKey.escape);

      expect(state.showRawServerLogs, isFalse);
    });

    test('when period is pressed then it closes', () async {
      await _sendKey(tester, LogicalKey.period);

      expect(state.showRawServerLogs, isFalse);
    });
  });

  group('Given a running TUI start app with a Flutter app running', () {
    late int restartCalls;

    setUp(() {
      restartCalls = 0;
      holder.onRestartFlutterApp = () => restartCalls++;
      state.canLaunchApps = true;
      state.launchableApps = [
        const FlutterAppConfig(
          id: 'app',
          name: 'App',
          relativePathParts: ['..', 'app'],
          serverPackageDirectoryPathParts: [],
        ),
      ];
      state.getOrCreateAppLogTab(appId: 'app', label: 'App');
    });

    test(
      'when Ctrl+R is pressed then the Flutter app restart is invoked',
      () async {
        await _sendCtrlR(tester);

        expect(restartCalls, 1);
      },
    );

    test(
      'when Ctrl+R is pressed then it does not fall through to hot reload',
      () async {
        var reloadCalls = 0;
        holder.onHotReload = () => reloadCalls++;
        state.serverReady = true;
        state.showSplash = false;

        await _sendCtrlR(tester);

        expect(reloadCalls, 0);
      },
    );
  });

  group(
    'Given a running TUI start app where the Flutter app has not launched yet but a restart is available',
    () {
      late int restartCalls;

      setUp(() {
        restartCalls = 0;
        holder.onRestartFlutterApp = () => restartCalls++;
        state.canLaunchApps = true;
        state.launchableApps = [
          const FlutterAppConfig(
            id: 'app',
            name: 'App',
            relativePathParts: ['..', 'app'],
            serverPackageDirectoryPathParts: [],
          ),
        ];
      });

      test(
        'when Ctrl+R is pressed then the Flutter app launch is invoked',
        () async {
          await _sendCtrlR(tester);

          expect(restartCalls, 1);
        },
      );
    },
  );

  group('Given a running TUI start app with no Flutter package', () {
    late int restartCalls;

    setUp(() {
      restartCalls = 0;
      holder.onRestartFlutterApp = () => restartCalls++;
      state.canLaunchApps = false;
    });

    test(
      'when Ctrl+R is pressed then the Flutter app restart is not invoked',
      () async {
        await _sendCtrlR(tester);

        expect(restartCalls, 0);
      },
    );
  });

  group('Given a ready TUI start app in watch mode', () {
    late int reloadCalls;
    late int restartCalls;

    setUp(() async {
      reloadCalls = 0;
      restartCalls = 0;
      // Hot reload and hot restart callbacks wired so the button is enabled.
      holder.onHotReload = () => reloadCalls++;
      holder.onHotRestart = () => restartCalls++;
      state.watchModeEnabled = true;
      state.serverReady = true;
      state.showSplash = false;
      // Rebuild so the button bar picks up the enabled state.
      holder.widgetState?.rebuild();
      await tester.pump();
    });

    test(
      'when R is pressed then hot restart is invoked instead of hot reload',
      () async {
        await _sendKey(tester, LogicalKey.keyR);

        expect(restartCalls, 1);
        expect(reloadCalls, 0);
      },
    );

    test('when Shift+R is pressed then hot restart is invoked', () async {
      await _sendShiftR(tester);

      expect(restartCalls, 1);
      expect(reloadCalls, 0);
    });
  });

  group('Given a ready TUI start app without watch mode', () {
    late int reloadCalls;
    late int restartCalls;

    setUp(() async {
      reloadCalls = 0;
      restartCalls = 0;
      // Hot reload and hot restart callbacks wired so the button is enabled.
      holder.onHotReload = () => reloadCalls++;
      holder.onHotRestart = () => restartCalls++;
      state.serverReady = true;
      state.showSplash = false;
      // Rebuild so the button bar picks up the enabled state.
      holder.widgetState?.rebuild();
      await tester.pump();
    });

    test(
      'when R is pressed then hot reload is invoked instead of hot restart',
      () async {
        await _sendKey(tester, LogicalKey.keyR);

        expect(reloadCalls, 1);
        expect(restartCalls, 0);
      },
    );

    test('when Shift+R is pressed then hot restart is invoked', () async {
      await _sendShiftR(tester);

      expect(restartCalls, 1);
      expect(reloadCalls, 0);
    });
  });

  group('Given a running TUI start app with the help overlay open', () {
    setUp(() {
      state.showHelp = true;
    });

    test(
      'when Ctrl-C is pressed then it bubbles past the help-mode key absorber and exit is armed',
      () async {
        await _sendCtrlC(tester);

        expect(state.ctrlCHint, 'Press Ctrl-C again to exit');
      },
    );
  });

  group('Given a running TUI start app with multiple launchable apps', () {
    setUp(() {
      state.canLaunchApps = true;
      state.launchableApps = [
        const FlutterAppConfig(
          id: 'a',
          name: 'Admin',
          relativePathParts: ['..', 'admin'],
          serverPackageDirectoryPathParts: [],
        ),
        const FlutterAppConfig(
          id: 'b',
          name: 'Customer',
          relativePathParts: ['..', 'customer'],
          serverPackageDirectoryPathParts: [],
        ),
      ];
      state.isAppRunning = (id) => id == 'a';
    });

    test(
      'when Ctrl+R is pressed then the launch panel opens',
      () async {
        await _sendCtrlR(tester);

        expect(state.showLaunchPanel, isTrue);
      },
    );

    test(
      'when Ctrl+R is pressed twice then the launch panel closes',
      () async {
        await _sendCtrlR(tester);
        await _sendCtrlR(tester);

        expect(state.showLaunchPanel, isFalse);
      },
    );

    test(
      'when Esc is pressed with the panel open then it closes',
      () async {
        state.showLaunchPanel = true;
        await _sendKey(tester, LogicalKey.escape);

        expect(state.showLaunchPanel, isFalse);
      },
    );

    test(
      'when digit 1 is pressed with the panel open then onLaunchApp is called',
      () async {
        var launchIndex = -1;
        holder.onLaunchApp = (index) => launchIndex = index;
        state.showLaunchPanel = true;

        await _sendKey(tester, LogicalKey.digit1);

        expect(launchIndex, 0);
        expect(state.showLaunchPanel, isFalse);
      },
    );

    test(
      'when no app tab is open then the panel cursor starts at the first app',
      () async {
        state.launchPanelIndex = 1;

        await _sendCtrlR(tester);

        expect(state.showLaunchPanel, isTrue);
        expect(state.launchPanelIndex, 0);
      },
    );

    test(
      'when an app tab is active then the panel cursor starts on it',
      () async {
        // Open the second app's tab and make it the active one.
        final customer = state.getOrCreateAppLogTab(
          appId: 'b',
          label: 'Customer',
        );
        state.tabs.focusTab(customer);
        state.launchPanelIndex = 0;

        await _sendCtrlR(tester);

        expect(state.showLaunchPanel, isTrue);
        expect(state.launchPanelIndex, 1);
      },
    );

    test(
      'when arrow keys are pressed then the cursor moves and wraps',
      () async {
        state.showLaunchPanel = true;
        state.launchPanelIndex = 0;

        await _sendKey(tester, LogicalKey.arrowDown);
        expect(state.launchPanelIndex, 1);

        await _sendKey(tester, LogicalKey.arrowDown);
        expect(state.launchPanelIndex, 0); // wraps past the last app

        await _sendKey(tester, LogicalKey.arrowUp);
        expect(state.launchPanelIndex, 1); // wraps before the first app
      },
    );

    test('when Enter is pressed then the focused app is launched', () async {
      var launchIndex = -1;
      holder.onLaunchApp = (index) => launchIndex = index;
      state.showLaunchPanel = true;
      state.launchPanelIndex = 1;

      await _sendKey(tester, LogicalKey.enter);

      expect(launchIndex, 1);
      expect(state.showLaunchPanel, isFalse);
    });
  });

  group('Given a running TUI start app with exactly one launchable app', () {
    late int restartCalls;

    setUp(() {
      restartCalls = 0;
      holder.onRestartFlutterApp = () => restartCalls++;
      state.canLaunchApps = true;
      state.launchableApps = [
        const FlutterAppConfig(
          id: 'a',
          name: 'Admin',
          relativePathParts: ['..', 'admin'],
          serverPackageDirectoryPathParts: [],
        ),
      ];
    });

    test(
      'when Ctrl+R is pressed then the launch panel does not open',
      () async {
        await _sendCtrlR(tester);

        expect(state.showLaunchPanel, isFalse);
        expect(restartCalls, 1);
      },
    );
  });

  group('Given a wide TUI with multiple app tabs open', () {
    late AppLogTab admin;
    late AppLogTab portal;

    setUp(() async {
      tester.dispose();
      await holder.dispose();

      state = ServerWatchState();
      holder = StartAppStateHolder(state);
      admin = state.getOrCreateAppLogTab(appId: 'admin', label: 'Admin');
      portal = state.getOrCreateAppLogTab(appId: 'portal', label: 'Portal');
      state.tabs.focusTab(admin);
      state.contentWidth = 200;

      tester = await NoctermTester.create(size: const Size(200, 30));
      await tester.pumpComponent(
        ServerpodWatchApp(holder: holder, onReady: (_) {}),
      );
      await tester.pump();
    });

    test(
      'when Tab is pressed from the server tab then the first app tab is focused',
      () async {
        state.tabs.focusedAreaIndex = 0;

        await _sendKey(tester, LogicalKey.tab);

        expect(state.tabs.focusedTab, admin);
      },
    );

    test(
      'when Tab is pressed from an app tab then the next app tab is focused',
      () async {
        state.tabs.focusTab(admin);

        await _sendKey(tester, LogicalKey.tab);

        expect(state.tabs.focusedTab, portal);
      },
    );

    test(
      'when digit 1 is pressed then the server tab is focused',
      () async {
        state.tabs.focusTab(portal);

        await _sendKey(tester, LogicalKey.digit1);

        expect(state.tabs.focusedTab, state.serverLogTab);
      },
    );

    test(
      'when digit 3 is pressed then the second app tab is focused',
      () async {
        state.tabs.focusTab(admin);

        await _sendKey(tester, LogicalKey.digit3);

        expect(state.tabs.focusedTab, portal);
      },
    );
  });

  group('Given a narrow TUI with multiple tabs open', () {
    setUp(() async {
      tester.dispose();
      await holder.dispose();

      state = ServerWatchState();
      holder = StartAppStateHolder(state);
      state.getOrCreateAppLogTab(appId: 'admin', label: 'Admin');
      state.contentWidth = 100;

      tester = await NoctermTester.create(size: const Size(100, 24));
      await tester.pumpComponent(
        ServerpodWatchApp(holder: holder, onReady: (_) {}),
      );
      await tester.pump();
    });

    test(
      'when Tab is pressed from the server tab then the first app tab is focused',
      () async {
        state.tabs.focusTab(state.serverLogTab);

        await _sendKey(tester, LogicalKey.tab);

        expect(state.tabs.focusedTab?.label, 'Admin');
      },
    );
  });
}
