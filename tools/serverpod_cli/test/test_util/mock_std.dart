import 'dart:async';
import 'dart:convert';
import 'dart:io';

class MockStdout implements Stdout {
  final _buffer = StringBuffer();

  @override
  Encoding encoding = utf8;

  @override
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
    return stream.forEach((data) {
      add(data);
    });
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
  void writeAll(Iterable objects, [String sep = '']) {
    _buffer.writeAll(objects, sep);
  }

  @override
  void writeCharCode(int charCode) {
    _buffer.writeCharCode(charCode);
  }

  @override
  void writeln([Object? object = '']) {
    _buffer.writeln(object);
  }
}

class MockStdin extends Stream<List<int>> implements Stdin {
  // Create a broadcast stream that can be listened to multiple times
  // Use an empty stream that completes immediately to simulate no input
  final _stream = const Stream<List<int>>.empty().asBroadcastStream();

  @override
  bool get hasTerminal => false;

  @override
  bool get echoMode => true;

  @override
  set echoMode(bool value) {}

  @override
  bool get echoNewlineMode => false;

  @override
  set echoNewlineMode(bool value) {}

  @override
  bool get lineMode => true;

  @override
  set lineMode(bool value) {}

  @override
  bool get supportsAnsiEscapes => false;

  @override
  int readByteSync() {
    throw UnimplementedError('readByteSync not implemented in MockStdin');
  }

  @override
  String? readLineSync({
    bool retainNewlines = false,
    Encoding encoding = systemEncoding,
  }) {
    return null; // No input available
  }

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  // Delegate all Stream methods to the underlying stream
  @override
  Future<bool> any(bool Function(List<int> element) test) => _stream.any(test);

  @override
  Stream<List<int>> asBroadcastStream({
    void Function(StreamSubscription<List<int>>)? onListen,
    void Function(StreamSubscription<List<int>>)? onCancel,
  }) => _stream.asBroadcastStream(onListen: onListen, onCancel: onCancel);

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(List<int> event) convert) =>
      _stream.asyncExpand(convert);

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(List<int> event) convert) =>
      _stream.asyncMap(convert);

  @override
  Stream<R> cast<R>() => _stream.cast<R>();

  @override
  Future<bool> contains(Object? needle) => _stream.contains(needle);

  @override
  Stream<List<int>> distinct([bool Function(List<int>, List<int>)? equals]) =>
      _stream.distinct(equals);

  @override
  Future<E> drain<E>([E? futureValue]) => _stream.drain(futureValue);

  @override
  Future<List<int>> elementAt(int index) => _stream.elementAt(index);

  @override
  Future<bool> every(bool Function(List<int> element) test) =>
      _stream.every(test);

  @override
  Stream<S> expand<S>(Iterable<S> Function(List<int> element) convert) =>
      _stream.expand(convert);

  @override
  Future<List<int>> get first => _stream.first;

  @override
  Future<List<int>> firstWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) => _stream.firstWhere(test, orElse: orElse);

  @override
  Future<S> fold<S>(
    S initialValue,
    S Function(S previous, List<int> element) combine,
  ) => _stream.fold(initialValue, combine);

  @override
  Future<void> forEach(void Function(List<int> element) action) =>
      _stream.forEach(action);

  @override
  Stream<List<int>> handleError(
    Function onError, {
    bool Function(dynamic)? test,
  }) => _stream.handleError(onError, test: test);

  @override
  bool get isBroadcast => _stream.isBroadcast;

  @override
  Future<bool> get isEmpty => _stream.isEmpty;

  @override
  Future<String> join([String separator = '']) => _stream.join(separator);

  @override
  Future<List<int>> get last => _stream.last;

  @override
  Future<List<int>> lastWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) => _stream.lastWhere(test, orElse: orElse);

  @override
  Future<int> get length => _stream.length;

  @override
  Stream<S> map<S>(S Function(List<int> event) convert) => _stream.map(convert);

  @override
  Future<dynamic> pipe(StreamConsumer<List<int>> streamConsumer) =>
      _stream.pipe(streamConsumer);

  @override
  Future<List<int>> reduce(
    List<int> Function(List<int> previous, List<int> element) combine,
  ) => _stream.reduce(combine);

  @override
  Future<List<int>> get single => _stream.single;

  @override
  Future<List<int>> singleWhere(
    bool Function(List<int> element) test, {
    List<int> Function()? orElse,
  }) => _stream.singleWhere(test, orElse: orElse);

  @override
  Stream<List<int>> skip(int count) => _stream.skip(count);

  @override
  Stream<List<int>> skipWhile(bool Function(List<int> element) test) =>
      _stream.skipWhile(test);

  @override
  Stream<List<int>> take(int count) => _stream.take(count);

  @override
  Stream<List<int>> takeWhile(bool Function(List<int> element) test) =>
      _stream.takeWhile(test);

  @override
  Stream<List<int>> timeout(
    Duration timeLimit, {
    void Function(EventSink<List<int>>)? onTimeout,
  }) => _stream.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<List<List<int>>> toList() => _stream.toList();

  @override
  Future<Set<List<int>>> toSet() => _stream.toSet();

  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) =>
      _stream.transform(streamTransformer);

  @override
  Stream<List<int>> where(bool Function(List<int> event) test) =>
      _stream.where(test);
}
