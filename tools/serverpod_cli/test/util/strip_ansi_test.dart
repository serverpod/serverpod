import 'package:serverpod_cli/src/util/strip_ansi.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given an empty string with no U+001B character, '
    'when stripAnsi is called, '
    'then the output is still empty.',
    () {
      expect(stripAnsi(''), '');
    },
  );

  test(
    'Given plain ASCII text with no U+001B character, '
    'when stripAnsi is called, '
    'then the output equals the input.',
    () {
      expect(stripAnsi('plain'), 'plain');
    },
  );

  test(
    'Given text that contains bracket notation resembling CSI but no ESC, '
    'when stripAnsi is called, '
    'then the output equals the input unchanged.',
    () {
      const s = 'Use [34m] in docs without escape — must not strip';
      expect(stripAnsi(s), s);
    },
  );

  test(
    'Given a Windows-style path string with backslashes and brackets, '
    'when stripAnsi is called, '
    'then the output equals the input unchanged.',
    () {
      const s = r'C:\path\[bracket]file.txt';
      expect(stripAnsi(s), s);
    },
  );

  test(
    'Given Dart source text with generics and list literals, '
    'when stripAnsi is called, '
    'then the output equals the input unchanged.',
    () {
      const s = 'List<int> values = [0, 1, 2];';
      expect(stripAnsi(s), s);
    },
  );

  test(
    'Given an analyzer-style file URI error line without ESC, '
    'when stripAnsi is called, '
    'then the output equals the input unchanged.',
    () {
      const s = 'error: file:///app/lib/main.dart:4:32: Error: not an escape';
      expect(stripAnsi(s), s);
    },
  );

  test(
    'Given a version string with bracketed suffix, '
    'when stripAnsi is called, '
    'then the output equals the input unchanged.',
    () {
      const s = 'Version [1.0m] build';
      expect(stripAnsi(s), s);
    },
  );

  test(
    'Given nested square brackets in user text, '
    'when stripAnsi is called, '
    'then the output equals the input unchanged.',
    () {
      const s = 'Nested [brackets [inner] ok]';
      expect(stripAnsi(s), s);
    },
  );

  test(
    'Given source-span output with CSI color and emphasis codes, '
    'when stripAnsi is called, '
    'then only escapes are removed and visible words remain.',
    () {
      const colored =
          '\x1b[34m\x1b[1mHint\x1b[0m on line 4\x1b[36mrandom_v7\x1b[0m';
      expect(stripAnsi(colored), 'Hint on line 4random_v7');
    },
  );

  test(
    'Given two separately styled words with CSI around each run, '
    'when stripAnsi is called, '
    'then words and spaces between runs are preserved.',
    () {
      const input = 'A\x1b[31mred\x1b[0m B\x1b[32mgreen\x1b[0m more';
      expect(stripAnsi(input), 'Ared Bgreen more');
    },
  );

  test(
    'Given extended CSI parameters such as 256-color foreground, '
    'when stripAnsi is called, '
    'then the full CSI sequence is removed.',
    () {
      expect(stripAnsi('\x1b[38;5;12mcolor\x1b[0m'), 'color');
    },
  );

  test(
    'Given box-drawing diagnostic lines with CSI around glyphs, '
    'when stripAnsi is called, '
    'then newlines, box characters, and snippet text remain.',
    () {
      const line =
          '\x1b[34m  ╷\x1b[0m\n'
          '\x1b[34m1\x1b[0m \x1b[34m│\x1b[0m \x1b[36mrandom_v7\x1b[0m';
      expect(stripAnsi(line), '  ╷\n1 │ random_v7');
    },
  );

  test(
    'Given Unicode text with CSI around a symbol in the middle, '
    'when stripAnsi is called, '
    'then code points outside escapes are preserved exactly.',
    () {
      const input = 'café \x1b[32m✓\x1b[0m 日本語';
      expect(stripAnsi(input), 'café ✓ 日本語');
    },
  );

  test(
    'Given a string that no longer contains CSI sequences, '
    'when stripAnsi is called, '
    'then the output equals the input.',
    () {
      const once = 'Ared Bgreen';
      expect(stripAnsi(once), once);
    },
  );

  test(
    'Given a string produced by stripping ANSI once, '
    'when stripAnsi is called a second time, '
    'then the output is unchanged.',
    () {
      const ansi = '\x1b[1mbold\x1b[0m text';
      final stripped = stripAnsi(ansi);
      expect(stripAnsi(stripped), stripped);
    },
  );

  test(
    'Given text that ends with a lone ESC byte and no CSI introducer, '
    'when stripAnsi is called, '
    'then the lone ESC is preserved.',
    () {
      expect(stripAnsi('ok\x1b'), 'ok\x1b');
    },
  );

  test(
    'Given ESC followed by a character other than [, '
    'when stripAnsi is called, '
    'then bytes are not treated as CSI and stay in the output.',
    () {
      expect(stripAnsi('x\x1bz'), 'x\x1bz');
    },
  );
}
