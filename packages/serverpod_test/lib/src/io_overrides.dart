import 'dart:convert';
import 'dart:io';

/// A null implementation of [Stdout] that does nothing.
class NullStdOut implements Stdout {
  @override
  Encoding encoding = utf8;

  /// Line terminator used.
  @override
  String lineTerminator = '\n';

  @override
  Future get done => Future.value();

  @override
  bool get hasTerminal => false;

  @override
  IOSink get nonBlocking => NullStdOut();

  @override
  bool get supportsAnsiEscapes => false;

  @override
  int get terminalColumns => 80;

  @override
  int get terminalLines => 24;

  @override
  void add(List<int> data) {}

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future addStream(Stream<List<int>> stream) async {}

  @override
  Future close() async {}

  @override
  Future flush() async {}

  @override
  void write(Object? object) {}

  @override
  void writeAll(Iterable objects, [String sep = '']) {}

  @override
  void writeCharCode(int charCode) {}

  @override
  void writeln([Object? object = '']) {}
}
