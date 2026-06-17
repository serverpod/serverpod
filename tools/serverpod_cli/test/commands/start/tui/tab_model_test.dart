import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/start/tui/tab_model.dart';
import 'package:test/test.dart';

void main() {
  group('Given a TabModel with main and apps areas', () {
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

    test(
      'when two areas have selected tabs then selectedIndex is independent',
      () {
        model.addTab(ServerLogTab());
        model.addTab(AppLogTab(appId: 'a', label: 'A'));
        model.addTab(AppLogTab(appId: 'b', label: 'B'));

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
        final appA = AppLogTab(appId: 'a', label: 'A');
        final appB = AppLogTab(appId: 'b', label: 'B');
        model.addTab(ServerLogTab());
        model.addTab(appA);
        model.addTab(appB);

        model.focusTab(appB);

        expect(model.focusedAreaIndex, 1);
        expect(appsArea.selectedIndex, 1);
        expect(model.focusedTab, appB);
      },
    );

    test(
      'when the selected tab is removed then selectedIndex is clamped',
      () {
        final appA = AppLogTab(appId: 'a', label: 'A');
        final appB = AppLogTab(appId: 'b', label: 'B');
        model.addTab(appA);
        model.addTab(appB);
        appsArea.selectedIndex = 1;

        model.removeTab(appB);

        expect(appsArea.selectedIndex, 0);
        expect(appsArea.selected, appA);
      },
    );

    test(
      'when the last tab in an area is removed then selected is null',
      () {
        final appTab = AppLogTab(appId: 'a', label: 'A');
        model.addTab(appTab);

        model.removeTab(appTab);

        expect(appsArea.tabs.length, 0);
        expect(appsArea.selected, isNull);
      },
    );

    test(
      'when cyclableTabs is called in side-by-side mode then single-tab areas are skipped',
      () {
        model.addTab(ServerLogTab());
        model.addTab(AppLogTab(appId: 'a', label: 'A'));
        model.addTab(AppLogTab(appId: 'b', label: 'B'));

        final cyclable = model.cyclableTabs(sideBySide: true);

        expect(cyclable.map((t) => t.label), ['A', 'B']);
      },
    );

    test(
      'when cyclableTabs is called in merged mode then every tab is included',
      () {
        model.addTab(ServerLogTab());
        model.addTab(AppLogTab(appId: 'a', label: 'A'));
        model.addTab(AppLogTab(appId: 'b', label: 'B'));

        final cyclable = model.cyclableTabs(sideBySide: false);

        expect(cyclable.map((t) => t.label), ['Server logs', 'A', 'B']);
      },
    );

    test(
      'when cycleTabs is called in side-by-side mode from the server tab then the first app tab is focused',
      () {
        final appA = AppLogTab(appId: 'a', label: 'A');
        final appB = AppLogTab(appId: 'b', label: 'B');
        model.addTab(ServerLogTab());
        model.addTab(appA);
        model.addTab(appB);
        model.focusedAreaIndex = 0;

        model.cycleTabs(1, sideBySide: true);

        expect(model.focusedTab, appA);
        expect(appsArea.selectedIndex, 0);
      },
    );

    test(
      'when cycleTabs is called in side-by-side mode then only app tabs are visited',
      () {
        final appA = AppLogTab(appId: 'a', label: 'A');
        final appB = AppLogTab(appId: 'b', label: 'B');
        model.addTab(ServerLogTab());
        model.addTab(appA);
        model.addTab(appB);
        model.focusTab(appA);

        model.cycleTabs(1, sideBySide: true);

        expect(model.focusedTab, appB);
      },
    );

    test(
      'when cycleTabs wraps in side-by-side mode then it returns to the first app tab',
      () {
        final appA = AppLogTab(appId: 'a', label: 'A');
        final appB = AppLogTab(appId: 'b', label: 'B');
        model.addTab(ServerLogTab());
        model.addTab(appA);
        model.addTab(appB);
        model.focusTab(appB);

        model.cycleTabs(1, sideBySide: true);

        expect(model.focusedTab, appA);
      },
    );

    test(
      'when cycleTabs moves backward from the server tab in side-by-side mode then the last app tab is focused',
      () {
        final appA = AppLogTab(appId: 'a', label: 'A');
        final appB = AppLogTab(appId: 'b', label: 'B');
        model.addTab(ServerLogTab());
        model.addTab(appA);
        model.addTab(appB);
        model.focusedAreaIndex = 0;

        model.cycleTabs(-1, sideBySide: true);

        expect(model.focusedTab, appB);
      },
    );

    test(
      'when cycleTabs is called in merged mode then the server tab is included',
      () {
        final serverTab = ServerLogTab();
        final appA = AppLogTab(appId: 'a', label: 'A');
        model.addTab(serverTab);
        model.addTab(appA);
        model.focusTab(serverTab);

        model.cycleTabs(1, sideBySide: false);

        expect(model.focusedTab, appA);
      },
    );

    test(
      'when only one cyclable tab exists then cycleTabs is a no-op',
      () {
        model.addTab(ServerLogTab());
        model.addTab(AppLogTab(appId: 'a', label: 'A'));
        model.focusTab(model.allTabs.last);

        model.cycleTabs(1, sideBySide: true);

        expect(model.focusedTab, model.allTabs.last);
      },
    );

    test(
      'when selectAllTabs is called then the tab at the global index is focused',
      () {
        model.addTab(ServerLogTab());
        model.addTab(AppLogTab(appId: 'a', label: 'A'));
        model.addTab(AppLogTab(appId: 'b', label: 'B'));

        model.selectAllTabs(2);

        expect(model.focusedTab?.label, 'B');
        expect(mainArea.selectedIndex, 0);
      },
    );

    test(
      'when selectAllTabs is out of range then it is a no-op',
      () {
        model.addTab(ServerLogTab());
        model.addTab(AppLogTab(appId: 'a', label: 'A'));

        model.selectAllTabs(5);

        expect(model.focusedTab?.label, 'Server logs');
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
