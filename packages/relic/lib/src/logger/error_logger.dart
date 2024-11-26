part of '../relic_server.dart';

void _logError(
  Request request,
  String message,
  StackTrace stackTrace,
) {
  var buffer = StringBuffer();
  buffer.write('${request.method} ${request.requestedUri.path}');
  if (request.requestedUri.query.isNotEmpty) {
    buffer.write('?${request.requestedUri.query}');
  }
  buffer.writeln();
  buffer.write(message);

  _logTopLevelError(buffer.toString(), stackTrace);
}

void _logTopLevelError(String message, StackTrace stackTrace) {
  final chain = Chain.forTrace(stackTrace)
      .foldFrames((frame) => frame.isCore || frame.package == 'relic_server')
      .terse;

  stderr.writeln('ERROR - ${DateTime.now()}');
  stderr.writeln(message);
  stderr.writeln(chain);
}
