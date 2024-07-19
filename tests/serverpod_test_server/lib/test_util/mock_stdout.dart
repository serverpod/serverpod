import 'dart:convert';
import 'dart:io';

class MockStdout implements Stdout {
  final _buffer = StringBuffer();

  @override
  Encoding encoding = utf8;

  String lineTerminator = '\n';

  String get output => _buffer.toString();

  @override
  void add(List<int> data) {
    _buffer.write(utf8.decode(data));
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    throw UnimplementedError();
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    throw UnimplementedError();
  }

  @override
  Future close() {
    return Future.value();
  }

  @override
  Future get done => Future.value();

  @override
  Future flush() {
    return Future.value();
  }

  @override
  bool get hasTerminal => false;

  @override
  IOSink get nonBlocking => throw UnimplementedError();

  @override
  bool get supportsAnsiEscapes => false;

  @override
  int get terminalColumns => 80;

  @override
  int get terminalLines => 24;

  @override
  void write(Object? object) {
    _buffer.write(object);
  }

  @override
  void writeAll(Iterable objects, [String sep = ""]) {
    _buffer.writeAll(objects, sep);
  }

  @override
  void writeCharCode(int charCode) {
    _buffer.writeCharCode(charCode);
  }

  @override
  void writeln([Object? object = ""]) {
    _buffer.writeln(object);
  }
}
