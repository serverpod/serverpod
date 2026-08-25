import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:test/test.dart';

void main() {
  group('Given a holder with onAttached wired,', () {
    test(
      'when the app is pumped, '
      'then onAttached is called once the app has mounted',
      () async {
        final holder = StartAppStateHolder(ServerWatchState());
        addTearDown(holder.dispose);
        var attached = 0;
        holder.onAttached = () {
          expect(holder.widgetState, isNotNull);
          attached++;
        };
        final tester = await NoctermTester.create(size: const Size(80, 24));
        addTearDown(tester.dispose);

        await tester.pumpComponent(ServerpodWatchApp(holder: holder));

        expect(attached, 1);
      },
    );
  });
}
