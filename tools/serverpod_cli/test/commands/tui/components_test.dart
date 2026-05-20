import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/tui/components/button.dart';
import 'package:test/test.dart';

Future<NoctermTester> _pumpButton({
  required void Function(LogicalKey) onActivate,
  void Function(LogicalKey)? onShiftActivate,
  String name = 'Reload',
}) async {
  final tester = await NoctermTester.create(size: const Size(20, 1));
  await tester.pumpComponent(
    Button(
      name: name,
      activationChar: 'R',
      activationKeys: const [LogicalKey.keyR],
      onActivate: onActivate,
      onShiftActivate: onShiftActivate,
    ),
  );
  return tester;
}

Future<void> _send(NoctermTester tester, LogicalKey key, {bool shift = false}) {
  return tester.sendKeyEvent(
    KeyboardEvent(
      logicalKey: key,
      modifiers: ModifierKeys(shift: shift),
    ),
  );
}

void main() {
  // NoctermTestBinding is a process-wide singleton, so every test must
  // dispose its tester before the next one can call NoctermTester.create.
  late NoctermTester tester;
  tearDown(() => tester.dispose());

  group('Given a Button without onShiftActivate', () {
    test(
      'when a bare activation key is pressed, '
      'then onActivate fires with that key',
      () async {
        LogicalKey? activated;
        tester = await _pumpButton(onActivate: (k) => activated = k);

        await _send(tester, LogicalKey.keyR);

        expect(activated, LogicalKey.keyR);
      },
    );
  });

  group('Given a Button with onShiftActivate', () {
    test(
      'when a bare activation key is pressed, '
      'then onActivate fires and onShiftActivate does not',
      () async {
        LogicalKey? activated;
        var shiftFired = false;
        tester = await _pumpButton(
          onActivate: (k) => activated = k,
          onShiftActivate: (_) => shiftFired = true,
        );

        await _send(tester, LogicalKey.keyR);

        expect(activated, LogicalKey.keyR);
        expect(shiftFired, isFalse);
      },
    );

    test(
      'when Shift+activation key is pressed, '
      'then onShiftActivate fires and onActivate does not',
      () async {
        var activateFired = false;
        LogicalKey? shiftActivated;
        tester = await _pumpButton(
          onActivate: (_) => activateFired = true,
          onShiftActivate: (k) => shiftActivated = k,
        );

        await _send(tester, LogicalKey.keyR, shift: true);

        expect(shiftActivated, LogicalKey.keyR);
        expect(activateFired, isFalse);
      },
    );
  });
}
