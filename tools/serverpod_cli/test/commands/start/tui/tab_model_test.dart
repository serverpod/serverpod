import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/start/tui/tab_model.dart';
import 'package:test/test.dart';

void main() {
  group('Given a TabModel with empty main and apps areas', () {
    late TabModel model;
    late TabArea mainArea;
    late TabArea appsArea;

    setUp(() {
      mainArea = TabArea(id: kMainArea);
      appsArea = TabArea(id: kAppsArea);
      model = TabModel([mainArea, appsArea]);
    });

    test(
      'when addTab is called then the tab is routed to its areaId',
      () {
        final serverTab = ServerLogTab();
        final appTab = AppLogTab(appId: 'admin', label: 'Admin');

        model.addTab(serverTab);
        model.addTab(appTab);

        expect(mainArea.tabs, [serverTab]);
        expect(appsArea.tabs, [appTab]);
      },
    );

    test(
      'when addTab targets an unknown areaId then StateError is thrown',
      () {
        final unknownTab = _UnknownAreaTab();

        expect(() => model.addTab(unknownTab), throwsStateError);
      },
    );
  });

  group('Given a TabModel with a server tab and two app tabs', () {
    late TabModel model;
    late TabArea mainArea;
    late TabArea appsArea;
    late AppLogTab appA;
    late AppLogTab appB;

    setUp(() {
      mainArea = TabArea(id: kMainArea);
      appsArea = TabArea(id: kAppsArea);
      model = TabModel([mainArea, appsArea]);
      appA = AppLogTab(appId: 'a', label: 'A');
      appB = AppLogTab(appId: 'b', label: 'B');
      model.addTab(ServerLogTab());
      model.addTab(appA);
      model.addTab(appB);
    });

    test(
      'when each area sets its own selectedIndex then they stay independent',
      () {
        appsArea.selectedIndex = 1;
        mainArea.selectedIndex = 0;

        expect(mainArea.selectedIndex, 0);
        expect(appsArea.selectedIndex, 1);
        expect(appsArea.selected?.label, 'B');
      },
    );

    test(
      'when focusTab is called then focusedAreaIndex and selectedIndex update',
      () {
        model.focusTab(appB);

        expect(model.focusedAreaIndex, 1);
        expect(appsArea.selectedIndex, 1);
        expect(model.focusedTab, appB);
      },
    );

    test(
      'when cyclableTabs is called in side-by-side mode '
      'then single-tab areas are skipped',
      () {
        final cyclable = model.cyclableTabs(sideBySide: true);

        expect(cyclable.map((t) => t.label), ['A', 'B']);
      },
    );

    test(
      'when cyclableTabs is called in merged mode then every tab is included',
      () {
        final cyclable = model.cyclableTabs(sideBySide: false);

        expect(cyclable.map((t) => t.label), ['Server logs', 'A', 'B']);
      },
    );

    test(
      'when cycleTabs is called in side-by-side mode from the server tab '
      'then the first app tab is focused',
      () {
        model.focusedAreaIndex = 0;

        model.cycleTabs(1, sideBySide: true);

        expect(model.focusedTab, appA);
        expect(appsArea.selectedIndex, 0);
      },
    );

    test(
      'when cycleTabs is called in side-by-side mode from an app tab '
      'then only app tabs are visited',
      () {
        model.focusTab(appA);

        model.cycleTabs(1, sideBySide: true);

        expect(model.focusedTab, appB);
      },
    );

    test(
      'when cycleTabs wraps in side-by-side mode '
      'then it returns to the first app tab',
      () {
        model.focusTab(appB);

        model.cycleTabs(1, sideBySide: true);

        expect(model.focusedTab, appA);
      },
    );

    test(
      'when cycleTabs moves backward in side-by-side mode from the server tab '
      'then the last app tab is focused',
      () {
        model.focusedAreaIndex = 0;

        model.cycleTabs(-1, sideBySide: true);

        expect(model.focusedTab, appB);
      },
    );

    test(
      'when selectAllTabs is called then the tab at the global index is focused',
      () {
        model.selectAllTabs(2);

        expect(model.focusedTab?.label, 'B');
        expect(mainArea.selectedIndex, 0);
      },
    );
  });

  group('Given a TabModel with a server tab and one app tab', () {
    late TabModel model;
    late ServerLogTab serverTab;
    late AppLogTab appA;

    setUp(() {
      final mainArea = TabArea(id: kMainArea);
      final appsArea = TabArea(id: kAppsArea);
      model = TabModel([mainArea, appsArea]);
      serverTab = ServerLogTab();
      appA = AppLogTab(appId: 'a', label: 'A');
      model.addTab(serverTab);
      model.addTab(appA);
    });

    test(
      'when cycleTabs is called in merged mode then the server tab is included',
      () {
        model.focusTab(serverTab);

        model.cycleTabs(1, sideBySide: false);

        expect(model.focusedTab, appA);
      },
    );

    test(
      'when cycleTabs is called in side-by-side mode then it is a no-op',
      () {
        // Each area holds a single tab, so nothing is cyclable side-by-side.
        model.focusTab(appA);

        model.cycleTabs(1, sideBySide: true);

        expect(model.focusedTab, appA);
      },
    );

    test(
      'when selectAllTabs is called with an out-of-range index '
      'then it is a no-op',
      () {
        model.selectAllTabs(5);

        expect(model.focusedTab, serverTab);
      },
    );
  });

  group('Given a TabModel with two app tabs and the second selected', () {
    late TabModel model;
    late TabArea appsArea;
    late AppLogTab appA;
    late AppLogTab appB;

    setUp(() {
      final mainArea = TabArea(id: kMainArea);
      appsArea = TabArea(id: kAppsArea);
      model = TabModel([mainArea, appsArea]);
      appA = AppLogTab(appId: 'a', label: 'A');
      appB = AppLogTab(appId: 'b', label: 'B');
      model.addTab(appA);
      model.addTab(appB);
      appsArea.selectedIndex = 1;
    });

    test(
      'when the selected tab is removed then selectedIndex is clamped',
      () {
        model.removeTab(appB);

        expect(appsArea.selectedIndex, 0);
        expect(appsArea.selected, appA);
      },
    );
  });

  group('Given a TabModel with a single app tab', () {
    late TabModel model;
    late TabArea appsArea;
    late AppLogTab appTab;

    setUp(() {
      final mainArea = TabArea(id: kMainArea);
      appsArea = TabArea(id: kAppsArea);
      model = TabModel([mainArea, appsArea]);
      appTab = AppLogTab(appId: 'a', label: 'A');
      model.addTab(appTab);
    });

    test(
      'when the last tab in an area is removed then selected is null',
      () {
        model.removeTab(appTab);

        expect(appsArea.tabs.length, 0);
        expect(appsArea.selected, isNull);
      },
    );
  });
}

class _UnknownAreaTab implements PaneTab {
  @override
  String get areaId => 'unknown';

  @override
  String get label => 'Unknown';

  @override
  final scrollController = ScrollController();
}
