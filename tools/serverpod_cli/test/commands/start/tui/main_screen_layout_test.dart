import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart';
import 'package:test/test.dart';

/// The heavy horizontal rule the `TabBar` draws under its labels. A plain
/// title label does not render it, so its presence proves a real tab bar.
const _tabBarRule = '━';

/// Builds a state with a server log line and two companion app tabs (the
/// first focused), then pumps it at [size].
Future<NoctermTester> _pump(Size size) async {
  final state = ServerWatchState();
  state.showSplash = false;
  state.serverReady = true;
  state.logHistory.add(
    LogEntry(
      time: DateTime(2026),
      level: LogLevel.info,
      message: 'server-log-line',
      scope: LogScope.root('server'),
    ),
  );
  final admin = state.getOrCreateAppLogTab(appId: 'admin', label: 'Admin');
  admin.lines.add('admin-log-line');
  state
      .getOrCreateAppLogTab(appId: 'portal', label: 'Portal')
      .lines
      .add('portal-log-line');
  state.tabs.focusTab(admin);

  final holder = StartAppStateHolder(state);
  final tester = await NoctermTester.create(size: size);
  addTearDown(() async {
    tester.dispose();
    await holder.dispose();
  });
  await tester.pumpComponent(
    ServerpodWatchApp(holder: holder, onReady: (_) {}),
  );
  await tester.pump();
  return tester;
}

void main() {
  group('Given a terminal at least as wide as the side-by-side cutoff', () {
    test(
      'when the TUI renders then both panes show with their own tab bars',
      () async {
        final ts = (await _pump(const Size(200, 30))).terminalState;

        // Both panes render simultaneously: server content on the left, app
        // content on the right.
        expect(ts.containsText('server-log-line'), isTrue);
        expect(ts.containsText('admin-log-line'), isTrue);
        // Tab bars are rendered (not bare titles), including the apps strip.
        expect(ts.containsText(_tabBarRule), isTrue);
        expect(ts.containsText('Portal'), isTrue);
      },
    );

    test(
      'when an app tab is shown then its label sits above its log lines',
      () async {
        final ts = (await _pump(const Size(200, 30))).terminalState;

        final label = ts.findText('Admin');
        final logLine = ts.findText('admin-log-line');

        expect(label.isNotEmpty, isTrue);
        expect(logLine.isNotEmpty, isTrue);
        // Regression guard: the tab title renders at the top of its pane, never
        // below the log content.
        expect(label.first.y, lessThan(logLine.first.y));
      },
    );

    test(
      'when an app tab is clicked then it is selected and the view updates',
      () async {
        final tester = await _pump(const Size(200, 30));

        // The Admin tab is selected initially, so only its log shows.
        expect(tester.terminalState.containsText('admin-log-line'), isTrue);
        expect(tester.terminalState.containsText('portal-log-line'), isFalse);

        final portalTab = tester.terminalState.findText('Portal').first;
        await tester.tap(portalTab.x, portalTab.y);
        await tester.pump();

        // Clicking the Portal tab selects it and redraws with its log.
        expect(tester.terminalState.containsText('portal-log-line'), isTrue);
      },
    );
  });

  group('Given a terminal narrower than the side-by-side cutoff', () {
    test(
      'when the TUI renders then one merged tab bar lists every tab',
      () async {
        final ts = (await _pump(const Size(100, 24))).terminalState;

        // A single tab strip merges the server and every app tab, so the
        // Flutter apps stay reachable instead of disappearing.
        expect(ts.containsText(_tabBarRule), isTrue);
        expect(ts.containsText('Server logs'), isTrue);
        expect(ts.containsText('Admin'), isTrue);
        expect(ts.containsText('Portal'), isTrue);

        // Only the focused tab's content shows (single column, one tab at a
        // time): the admin tab is focused, so the server log is not visible.
        expect(ts.containsText('admin-log-line'), isTrue);
        expect(ts.containsText('server-log-line'), isFalse);
      },
    );

    test(
      'when a tab is clicked in the merged strip then it is selected',
      () async {
        final tester = await _pump(const Size(100, 24));

        expect(tester.terminalState.containsText('admin-log-line'), isTrue);
        expect(tester.terminalState.containsText('server-log-line'), isFalse);

        final serverTab = tester.terminalState.findText('Server logs').first;
        await tester.tap(serverTab.x, serverTab.y);
        await tester.pump();

        // Selecting the server tab redraws with the server log.
        expect(tester.terminalState.containsText('server-log-line'), isTrue);
      },
    );
  });

  group('Given the launch panel is open', () {
    /// Pumps the launch panel with one running app (Admin) and two stopped
    /// apps, the [focus]th row selected.
    Future<NoctermTester> panel({required int focus}) async {
      final state = ServerWatchState();
      state.showSplash = false;
      state.canLaunchApps = true;
      state.showLaunchPanel = true;
      state.launchPanelIndex = focus;
      state.launchableApps = [
        for (final name in ['Admin', 'Portal', 'Mobile'])
          FlutterAppConfig(
            id: name.toLowerCase(),
            name: name,
            relativePathParts: ['..', name.toLowerCase()],
            serverPackageDirectoryPathParts: const [],
          ),
      ];
      state.isAppRunning = (id) => id == 'admin';

      final holder = StartAppStateHolder(state);
      final tester = await NoctermTester.create(size: const Size(120, 24));
      addTearDown(() async {
        tester.dispose();
        await holder.dispose();
      });
      await tester.pumpComponent(
        ServerpodWatchApp(holder: holder, onReady: (_) {}),
      );
      await tester.pump();
      return tester;
    }

    test('then a stopped, unfocused app is dimmed', () async {
      final ts = (await panel(focus: 0)).terminalState;
      final mobile = ts.getStyledText().firstWhere(
        (s) => s.text.contains('Mobile'),
      );
      expect(mobile.style.fontWeight, FontWeight.dim);
    });

    test(
      'then the running marker is colored apart from stopped rows',
      () async {
        final ts = (await panel(focus: 0)).terminalState;
        final marker = ts.getStyledText().firstWhere(
          (s) => s.text.contains('●'),
        );
        final stopped = ts.getStyledText().firstWhere(
          (s) => s.text.contains('Mobile'),
        );
        expect(marker.style.color, isNotNull);
        expect(marker.style.color, isNot(stopped.style.color));
        expect(marker.style.fontWeight, isNot(FontWeight.dim));
      },
    );

    test(
      'then the focused row is background-highlighted even when stopped',
      () async {
        // Portal (stopped) is focused; Mobile (stopped) is not.
        final ts = (await panel(focus: 1)).terminalState;
        final portal = ts.getStyledText().firstWhere(
          (s) => s.text.contains('Portal'),
        );
        final mobile = ts.getStyledText().firstWhere(
          (s) => s.text.contains('Mobile'),
        );

        expect(portal.style.fontWeight, isNot(FontWeight.dim));
        // The focused row carries a background distinct from an unfocused row.
        expect(
          portal.style.backgroundColor,
          isNot(mobile.style.backgroundColor),
        );
      },
    );

    test(
      'then the title reads "Relaunch app" when a running app is focused',
      () async {
        // Admin (index 0) is running, so selecting it relaunches.
        final ts = (await panel(focus: 0)).terminalState;
        expect(ts.containsText('Relaunch app'), isTrue);
      },
    );

    test(
      'then the title reads "Launch app" when a stopped app is focused',
      () async {
        // Portal (index 1) is stopped; the title is the launch verb, not relaunch.
        // (The "Relaunch" token only appears in the panel title, never the button
        // bar hint, so its absence pins the launch wording.)
        final ts = (await panel(focus: 1)).terminalState;
        expect(ts.containsText('Relaunch'), isFalse);
      },
    );

    test('then a launching app shows an orange running marker', () async {
      final state = ServerWatchState();
      state.showSplash = false;
      state.canLaunchApps = true;
      state.showLaunchPanel = true;
      state.launchPanelIndex = 1;
      state.launchableApps = [
        for (final name in ['Admin', 'Portal', 'Mobile'])
          FlutterAppConfig(
            id: name.toLowerCase(),
            name: name,
            relativePathParts: ['..', name.toLowerCase()],
            serverPackageDirectoryPathParts: const [],
          ),
      ];
      state.isAppRunning = (id) => id == 'admin';
      state.isAppLaunching = (id) => id == 'portal';

      final holder = StartAppStateHolder(state);
      final tester = await NoctermTester.create(size: const Size(120, 24));
      addTearDown(() async {
        tester.dispose();
        await holder.dispose();
      });
      await tester.pumpComponent(
        ServerpodWatchApp(holder: holder, onReady: (_) {}),
      );
      await tester.pump();

      final ts = tester.terminalState;
      final launchingMarker = ts.getStyledText().firstWhere(
        (s) =>
            s.text.contains('●') &&
            s.style.color == ServerpodThemeData.dark.warningLevel,
      );
      final runningMarker = ts.getStyledText().firstWhere(
        (s) =>
            s.text.contains('●') &&
            s.style.color == ServerpodThemeData.dark.success,
      );

      expect(launchingMarker.style.color, isNot(runningMarker.style.color));
    });
  });
}
