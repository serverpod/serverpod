import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/start/tui/tab_model.dart';
import 'package:serverpod_tui/serverpod_tui.dart';
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
      'when selectInFocusedArea is called then only the focused area changes',
      () {
        model.addTab(AppLogTab(appId: 'a', label: 'A'));
        model.addTab(AppLogTab(appId: 'b', label: 'B'));
        model.addTab(AppLogTab(appId: 'c', label: 'C'));
        mainArea.selectedIndex = 0;
        model.focusedAreaIndex = 1;

        model.selectInFocusedArea(2);

        expect(appsArea.selectedIndex, 2);
        expect(mainArea.selectedIndex, 0);
      },
    );

    test(
      'when selectInFocusedArea is out of range then it is a no-op',
      () {
        model.addTab(AppLogTab(appId: 'a', label: 'A'));
        model.focusedAreaIndex = 1;

        model.selectInFocusedArea(5);

        expect(appsArea.selectedIndex, 0);
      },
    );

    test(
      'when cycleTabInFocusedArea is called then only the focused area cycles',
      () {
        model.addTab(AppLogTab(appId: 'a', label: 'A'));
        model.addTab(AppLogTab(appId: 'b', label: 'B'));
        model.focusedAreaIndex = 1;
        appsArea.selectedIndex = 0;

        model.cycleTabInFocusedArea(1);

        expect(appsArea.selectedIndex, 1);
      },
    );

    test(
      'when cycleTabInFocusedArea would go out of range then it is a no-op',
      () {
        model.addTab(AppLogTab(appId: 'a', label: 'A'));
        model.addTab(AppLogTab(appId: 'b', label: 'B'));
        model.focusedAreaIndex = 1;
        appsArea.selectedIndex = 1;

        model.cycleTabInFocusedArea(1);

        expect(appsArea.selectedIndex, 1);
      },
    );

    test(
      'when focusArea is called then focus wraps across areas',
      () {
        model.focusedAreaIndex = 1;

        model.focusArea(1);

        expect(model.focusedAreaIndex, 0);

        model.focusArea(-1);

        expect(model.focusedAreaIndex, 1);
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
  final lines = BoundedQueueList<String>(100);

  @override
  final scrollController = ScrollController();
}
