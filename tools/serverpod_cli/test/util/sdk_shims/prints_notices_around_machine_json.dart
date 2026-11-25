// Test shim: stands in for a `flutter` wrapper that prints notices around its
// answer to `--version --machine`. Prints each `--before=<line>`, then the
// machine JSON reporting the `flutterRoot` given by `--root=<path>`, indented
// the way `flutter` prints it, then each `--after=<line>`.
import 'dart:convert';

void main(List<String> args) {
  Iterable<String> valuesOf(String option) => args
      .where((a) => a.startsWith('--$option='))
      .map((a) => a.substring('--$option='.length));

  valuesOf('before').forEach(print);
  print(
    const JsonEncoder.withIndent(
      '  ',
    ).convert({
      'frameworkVersion': '3.32.0',
      'flutterRoot': valuesOf('root').first,
    }),
  );
  valuesOf('after').forEach(print);
}
