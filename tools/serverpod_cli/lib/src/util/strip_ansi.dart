/// Removes ANSI terminal escape sequences so log lines render correctly in the
/// nocterm TUI (which does not interpret ANSI coloring).
///
/// Covers CSI sequences (`ESC [ …`) used by [SourceSpan.toString] with `color:`,
/// Dart analyzer diagnostics, and cli_tools styling.
String stripAnsi(String input) {
  if (!input.contains('\x1b')) return input;
  return input.replaceAll(_csiSequence, '');
}

/// CSI — Control Sequence Introducer: `ESC [` … final byte in `0x40–0x7E`.
///
/// See ECMA-48.
final _csiSequence = RegExp(
  r'\x1b\[[\x30-\x3f]*[\x20-\x2f]*[\x40-\x7e]',
);
