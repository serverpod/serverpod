import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/start/tui/tab_model.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart';
import 'package:test/test.dart';

/// The heavy horizontal rule the `TabBar` draws under its labels. A plain
/// title label does not render it, so its presence proves a real tab bar.
const _tabBarRule = '━';

/// Builds a state with a server log line and two companion app tabs (Admin
/// focused), then pumps it at [size].
Future<NoctermTester> _pumpAppsLayout(Size size) async {
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
  state.launchableApps = [
    for (final name in ['Admin', 'Portal'])
      FlutterAppConfig(
        id: name.toLowerCase(),
        name: name,
        relativePathParts: ['..', name.toLowerCase()],
        serverPackageDirectoryPathParts: const [],
      ),
  ];
  final admin = state.getOrCreateAppLogTab(appId: 'admin', label: 'Admin');
  admin.lines.add('admin-log-line');
  admin.logHistory.add(
    LogEntry(
      time: DateTime(2026),
      level: LogLevel.info,
      message: 'admin-log-line',
      scope: LogScope.root('admin'),
    ),
  );
  final portal = state.getOrCreateAppLogTab(
    appId: 'portal',
    label: 'Portal',
  );
  portal.lines.add('portal-log-line');
  portal.logHistory.add(
    LogEntry(
      time: DateTime(2026),
      level: LogLevel.info,
      message: 'portal-log-line',
      scope: LogScope.root('portal'),
    ),
  );
  state.tabs.focusTab(admin);

  return _pump(state, size);
}

/// Builds the launch panel over Admin (running), Portal and Mobile (stopped)
/// with the [focus]th row selected, then pumps it. When [launchingAppId] is
/// given, that app reports as launching.
Future<NoctermTester> _pumpLaunchPanel({
  required int focus,
  String? launchingAppId,
}) async {
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
  if (launchingAppId != null) {
    state.isAppLaunching = (id) => id == launchingAppId;
  }

  return _pump(state, const Size(120, 24));
}

/// Builds a single ready app tab with [device] and [url], then pumps it.
/// When [openUrl] is given, it replaces the holder's browser opener.
Future<NoctermTester> _pumpReadyAppTab({
  String? device,
  String? url,
  Future<bool> Function(Uri url)? openUrl,
}) async {
  final state = ServerWatchState();
  state.showSplash = false;
  state.serverReady = true;
  state.launchableApps = [
    const FlutterAppConfig(
      id: 'app',
      name: 'App',
      relativePathParts: ['..', 'app'],
      serverPackageDirectoryPathParts: [],
    ),
  ];
  final tab = state.getOrCreateAppLogTab(appId: 'app', label: 'App');
  tab.runState = AppRunState.ready;
  tab.device = device;
  tab.url = url;
  state.tabs.focusTab(tab);
  return _pump(state, const Size(200, 30), openUrl: openUrl);
}

/// Pumps [state] at [size] and returns the tester, disposing it on teardown.
/// When [openUrl] is given, it replaces the holder's browser opener.
Future<NoctermTester> _pump(
  ServerWatchState state,
  Size size, {
  Future<bool> Function(Uri url)? openUrl,
}) async {
  final holder = StartAppStateHolder(state);
  if (openUrl != null) holder.openUrl = openUrl;
  final tester = await NoctermTester.create(size: size);
  addTearDown(() async {
    tester.dispose();
    await holder.dispose();
  });
  await tester.pumpComponent(
    ServerpodWatchApp(holder: holder),
  );
  await tester.pump();
  return tester;
}

void main() {
  group(
    'Given a rendered terminal at least as wide as the side-by-side cutoff',
    () {
      late NoctermTester tester;

      setUp(() async {
        tester = await _pumpAppsLayout(const Size(200, 30));
      });

      test('then both panes render with their own tab bars', () {
        final ts = tester.terminalState;

        // Both panes render simultaneously: server content on the left, app
        // content on the right.
        expect(ts.containsText('server-log-line'), isTrue);
        expect(ts.containsText('admin-log-line'), isTrue);
        // Tab bars are rendered (not bare titles), including the apps strip.
        expect(ts.containsText(_tabBarRule), isTrue);
        expect(ts.containsText('Portal'), isTrue);
      });

      test('then an app tab\'s label sits above its log lines', () {
        final ts = tester.terminalState;

        final label = ts.findText('Admin');
        final logLine = ts.findText('admin-log-line');

        expect(label.isNotEmpty, isTrue);
        expect(logLine.isNotEmpty, isTrue);
        // Regression guard: the tab title renders at the top of its pane, never
        // below the log content.
        expect(label.first.y, lessThan(logLine.first.y));
      });

      test('then the pane divider tees into the outer border', () {
        final ts = tester.terminalState;

        // The border rows are where the outer box's corners sit.
        final topBorderRow = ts.findText('╭').first.y;
        final bottomBorderRow = ts.findText('╰').first.y;

        // The divider between the panes merges with the border rows instead
        // of leaving gaps.
        final tee = ts.findText('┬');
        expect(tee.isNotEmpty, isTrue);
        expect(tee.first.y, topBorderRow);
        final bottomTee = ts.findText('┴');
        expect(bottomTee.isNotEmpty, isTrue);
        expect(bottomTee.first.y, bottomBorderRow);
        expect(tee.first.x, bottomTee.first.x);
      });

      test('then the tab bar underline crosses the pane divider', () {
        final ts = tester.terminalState;

        // The pane divider column is where the top border tees.
        final dividerX = ts.findText('┬').first.x;
        // Both panes' tab bars share the underline row.
        final underlineRow = ts.findText(_tabBarRule).first.y;

        // The dividers paint in an underlay before the panes, so the
        // underline joins the pane divider from both sides, forming a
        // cross instead of stopping short on the left.
        expect(ts.getTextAt(dividerX, underlineRow, length: 1), '┿');
        // The underline's outer ends merge into the box border sides.
        expect(ts.getTextAt(0, underlineRow, length: 1), '┝');
        expect(ts.getTextAt(199, underlineRow, length: 1), '┥');
      });

      test('then the app status rule tees into the pane edges', () {
        final ts = tester.terminalState;

        // The focused app tab renders a status rule under its breadcrumb;
        // its left end joins the pane divider and its right end joins the
        // outer border.
        final left = ts.findText('├');
        final right = ts.findText('┤');
        expect(left.isNotEmpty, isTrue);
        expect(right.isNotEmpty, isTrue);
        expect(left.first.y, right.first.y);
      });

      test(
        'when an app tab is clicked then it is selected and the view updates',
        () async {
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
    },
  );

  group('Given a rendered terminal narrower than the side-by-side cutoff', () {
    late NoctermTester tester;

    setUp(() async {
      tester = await _pumpAppsLayout(const Size(100, 24));
    });

    test('then the app status rule tees into the outer border', () {
      final ts = tester.terminalState;

      // In the merged layout the status rule spans the full content width,
      // joining the outer border on both sides.
      final left = ts.findText('├');
      final right = ts.findText('┤');
      expect(left.isNotEmpty, isTrue);
      expect(right.isNotEmpty, isTrue);
      expect(left.first.y, right.first.y);
      expect(left.first.x, 0);
      expect(right.first.x, 99);
    });

    test('then one merged tab bar lists every tab', () {
      final ts = tester.terminalState;

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
    });

    test(
      'when a tab is clicked in the merged strip then it is selected',
      () async {
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

  group('Given the launch panel is open with the running app focused', () {
    late NoctermTester tester;

    setUp(() async {
      // Admin (index 0) is running.
      tester = await _pumpLaunchPanel(focus: 0);
    });

    test('then a stopped, unfocused app is dimmed', () {
      final mobile = tester.terminalState.getStyledText().firstWhere(
        (s) => s.text.contains('Mobile'),
      );
      expect(mobile.style.fontWeight, FontWeight.dim);
    });

    test('then the running marker is colored apart from stopped rows', () {
      final ts = tester.terminalState;
      final marker = ts.getStyledText().firstWhere(
        (s) => s.text.contains('●'),
      );
      final stopped = ts.getStyledText().firstWhere(
        (s) => s.text.contains('Mobile'),
      );
      expect(marker.style.color, isNotNull);
      expect(marker.style.color, isNot(stopped.style.color));
      expect(marker.style.fontWeight, isNot(FontWeight.dim));
    });

    test('then the title reads "Relaunch app"', () {
      // Selecting the focused running app relaunches it.
      expect(tester.terminalState.containsText('Relaunch app'), isTrue);
    });

    test('then the panel border tees into the outer border', () {
      final ts = tester.terminalState;

      final topBorderRow = ts.findText('╭').first.y;
      final bottomBorderRow = ts.findText('╰').first.y;
      // The panel is 30 columns wide plus its border, anchored to the right
      // edge (119), so its left border sits at column 88.
      const panelLeft = 88;

      // The panel's corners land on the outer border and merge into tees
      // instead of overwriting it.
      expect(ts.getTextAt(panelLeft, topBorderRow, length: 1), '┬');
      expect(ts.getTextAt(panelLeft, bottomBorderRow, length: 1), '┴');
      // The rule under the panel title joins the panel's own borders.
      final headerRule = ts.findText('├').first;
      expect(headerRule.x, panelLeft);
      expect(ts.getTextAt(119, headerRule.y, length: 1), '┤');
      // The outer box's corners stay rounded.
      expect(ts.getTextAt(0, topBorderRow, length: 1), '╭');
      expect(ts.getTextAt(119, topBorderRow, length: 1), '╮');
    });

    test('then the title divider matches the panel border color', () {
      final ts = tester.terminalState;

      const panelLeft = 88;
      final headerRule = ts.findText('├').first;

      // The rule's line cells share the border's color instead of falling
      // back to the default (bright) divider color. The reference cell is
      // the panel's own left border, one row below the rule's junction.
      expect(ts.getTextAt(panelLeft + 1, headerRule.y, length: 1), '─');
      final rule = ts.getCellAt(panelLeft + 1, headerRule.y)!.style.color;
      expect(rule, ts.getCellAt(panelLeft, headerRule.y + 1)!.style.color);
    });
  });

  group('Given the launch panel is open with a stopped app focused', () {
    late NoctermTester tester;

    setUp(() async {
      // Portal (index 1) is stopped.
      tester = await _pumpLaunchPanel(focus: 1);
    });

    test(
      'then the focused row is background-highlighted even when stopped',
      () {
        final ts = tester.terminalState;
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

    test('then the title reads "Launch app", not "Relaunch"', () {
      // The "Relaunch" token only appears in the panel title, never the button
      // bar hint, so its absence pins the launch wording.
      expect(tester.terminalState.containsText('Relaunch'), isFalse);
    });
  });

  group('Given the launch panel is open with a launching app focused', () {
    late NoctermTester tester;

    setUp(() async {
      // Portal (index 1) is launching while Admin is running.
      tester = await _pumpLaunchPanel(focus: 1, launchingAppId: 'portal');
    });

    test(
      'then its marker uses the spinner colour, apart from a running app\'s',
      () {
        final ts = tester.terminalState;
        final launchingMarker = ts.getStyledText().firstWhere(
          (s) => s.style.color == ServerpodThemeData.dark.spinner,
        );
        final runningMarker = ts.getStyledText().firstWhere(
          (s) =>
              s.text.contains('●') &&
              s.style.color == ServerpodThemeData.dark.success,
        );

        expect(launchingMarker.style.color, isNot(runningMarker.style.color));
      },
    );
  });

  group('Given a ready Flutter app tab with a configured device', () {
    late NoctermTester tester;

    setUp(() async {
      tester = await _pumpReadyAppTab(device: 'emulator-5554');
    });

    test('then the status line names the device', () {
      expect(
        tester.terminalState.containsText('Running on device emulator-5554'),
        isTrue,
      );
    });
  });

  group('Given a ready Flutter app tab without a configured device', () {
    late NoctermTester tester;

    setUp(() async {
      tester = await _pumpReadyAppTab();
    });

    test('then the status line shows the generic running label', () {
      expect(tester.terminalState.containsText('Running on device'), isTrue);
    });
  });

  group('Given a ready Flutter app tab with a published URL', () {
    late NoctermTester tester;
    late List<Uri> openedUrls;

    setUp(() async {
      openedUrls = [];
      tester = await _pumpReadyAppTab(
        device: 'chrome',
        url: 'http://localhost:8080',
        openUrl: (url) async {
          openedUrls.add(url);
          return true;
        },
      );
    });

    test('then the status line shows the URL, not the device', () {
      expect(
        tester.terminalState.containsText('http://localhost:8080'),
        isTrue,
      );
      expect(tester.terminalState.containsText('Running on device'), isFalse);
    });

    test('then the URL renders underlined', () {
      final urlText = tester.terminalState.getStyledText().firstWhere(
        (s) => s.text.contains('http://localhost:8080'),
      );
      expect(urlText.style.decoration?.hasUnderline, isTrue);
    });

    test('when the URL is clicked then it opens in the browser', () async {
      final url = tester.terminalState.findText('http://localhost:8080').first;

      await tester.tap(url.x, url.y);
      await tester.pump();

      expect(openedUrls, [Uri.parse('http://localhost:8080')]);
    });
  });

  group('Given a structured log with stack-traced error entries', () {
    late ServerWatchState state;
    late NoctermTester tester;

    setUp(() async {
      state = ServerWatchState();
      state.showSplash = false;
      state.serverReady = true;
      for (final (message, trace) in [
        ('boom', '#0 boom-trace'),
        ('kaboom', '#0 other-trace'),
      ]) {
        state.logHistory.add(
          LogEntry(
            time: DateTime(2026),
            level: LogLevel.error,
            message: message,
            scope: LogScope.root('server'),
            error: 'Exception: $message',
            stackTrace: StackTrace.fromString(trace),
          ),
        );
      }

      tester = await _pump(state, const Size(100, 24));
    });

    test('then a collapsed entry shows a styled clickable affordance', () {
      final ts = tester.terminalState;

      expect(ts.containsText('▸ 1-line stack trace E Expand'), isTrue);
      expect(ts.containsText('#0 boom-trace'), isFalse);

      // The `E` key hint follows the action-button convention: the
      // activation key is highlighted apart from the label.
      final key = ts.getStyledText().firstWhere(
        (s) =>
            s.text.trim() == 'E' &&
            s.style.color == ServerpodThemeData.dark.activationKey,
        orElse: () => throw StateError('No styled activation-key E found'),
      );
      expect(key.style.color, ServerpodThemeData.dark.activationKey);
    });

    test(
      'when one entry is clicked then the others stays collapsed',
      () async {
        expect(tester.terminalState.findText('E Expand'), hasLength(2));

        final affordance = tester.terminalState.findText('E Expand').first;
        await tester.tap(affordance.x, affordance.y);
        await tester.pump();

        final ts = tester.terminalState;
        final expandedBoth =
            ts.containsText('#0 boom-trace') &&
            ts.containsText('#0 other-trace');
        expect(expandedBoth, isFalse, reason: 'only one entry may expand');
        expect(
          ts.containsText('#0 boom-trace') || ts.containsText('#0 other-trace'),
          isTrue,
          reason: 'the clicked entry must expand',
        );
        expect(
          ts.findText('E Expand'),
          hasLength(1),
          reason: 'the other entry must keep its collapsed affordance',
        );
      },
    );
  });

  group(
    'Given a scrollback with a stack trace taller than the viewport',
    () {
      late NoctermTester tester;

      LogEntry infoEntry(String message) => LogEntry(
        time: DateTime(2026),
        level: LogLevel.info,
        message: message,
        scope: LogScope.root('server'),
      );

      setUp(() async {
        final state = ServerWatchState();
        state.showSplash = false;
        state.serverReady = true;
        // Old entries above, the error in the middle, newer entries below;
        // the 60-line trace exceeds the 24-row viewport when expanded.
        for (var i = 0; i < 50; i++) {
          state.logHistory.add(infoEntry('older-$i'));
        }
        state.logHistory.add(
          LogEntry(
            time: DateTime(2026),
            level: LogLevel.error,
            message: 'boom',
            scope: LogScope.root('server'),
            error: 'Exception: boom',
            stackTrace: StackTrace.fromString(
              [for (var i = 0; i < 60; i++) '#$i frame-$i'].join('\n'),
            ),
          ),
        );
        for (var i = 0; i < 10; i++) {
          state.logHistory.add(infoEntry('newer-$i'));
        }
        tester = await _pump(state, const Size(100, 24));
      });

      test(
        'when the trace is expanded and collapsed then the clicked entry '
        'stays in view',
        () async {
          final expand = tester.terminalState.findText('E Expand').first;
          await tester.tap(expand.x, expand.y);
          await tester.pump();

          final ts = tester.terminalState;
          expect(
            ts.containsText('E Collapse'),
            isTrue,
            reason:
                'expanding a trace taller than the screen must keep the '
                'clicked affordance in view (pinned to the top)',
          );
          expect(
            ts.containsText('#0 frame-0'),
            isTrue,
            reason: 'the start of the trace must be shown below the entry',
          );
          expect(
            ts.containsText('frame-59'),
            isFalse,
            reason: 'the trace tail cannot fit and must overflow off-screen',
          );

          final collapse = tester.terminalState.findText('E Collapse').first;
          await tester.tap(collapse.x, collapse.y);
          await tester.pump();

          expect(
            tester.terminalState.containsText('E Expand'),
            isTrue,
            reason:
                'collapsing from a scrolled-up position must follow the '
                'entry back into view',
          );
          expect(tester.terminalState.containsText('boom'), isTrue);
        },
      );
    },
  );
}
