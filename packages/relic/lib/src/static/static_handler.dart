import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:relic/src/headers/typed/typed_headers.dart';
import 'package:relic/src/method/request_method.dart';
import 'package:relic/src/static/extension/datetime_extension.dart';

import '../body/body.dart';
import '../handler/handler.dart';
import '../headers/headers.dart';
import '../body/types/mime_type.dart';
import '../message/request.dart';
import '../message/response.dart';

import 'directory_listing.dart';

/// The default resolver for MIME types based on file extensions.
final _defaultMimeTypeResolver = MimeTypeResolver();

/// Creates a Relic [Handler] that serves files from the provided
/// [fileSystemPath].
///
/// Accessing a path containing symbolic links will succeed only if the resolved
/// path is within [fileSystemPath]. To allow access to paths outside of
/// [fileSystemPath], set [serveFilesOutsidePath] to `true`.
///
/// When a existing directory is requested and a [defaultDocument] is specified
/// the directory is checked for a file with that name. If it exists, it is
/// served.
///
/// If no [defaultDocument] is found and [listDirectories] is true, then the
/// handler produces a listing of the directory.
///
/// If [useHeaderBytesForContentType] is `true`, the contents of the
/// file will be used along with the file path to determine the content type.
///
/// Specify a custom [contentTypeResolver] to customize automatic content type
/// detection.
Handler createStaticHandler(
  String fileSystemPath, {
  bool serveFilesOutsidePath = false,
  String? defaultDocument,
  bool listDirectories = false,
  bool useHeaderBytesForContentType = false,
  MimeTypeResolver? contentTypeResolver,
}) {
  final rootDir = Directory(fileSystemPath);
  if (!rootDir.existsSync()) {
    throw ArgumentError('A directory corresponding to fileSystemPath '
        '"$fileSystemPath" could not be found');
  }

  fileSystemPath = rootDir.resolveSymbolicLinksSync();

  if (defaultDocument != null) {
    if (defaultDocument != p.basename(defaultDocument)) {
      throw ArgumentError('defaultDocument must be a file name.');
    }
  }

  final mimeResolver = contentTypeResolver ?? _defaultMimeTypeResolver;

  return (Request request) {
    final segs = [fileSystemPath, ...request.url.pathSegments];

    final fsPath = p.joinAll(segs);

    final entityType = FileSystemEntity.typeSync(fsPath);

    File? fileFound;

    if (entityType == FileSystemEntityType.file) {
      fileFound = File(fsPath);
    } else if (entityType == FileSystemEntityType.directory) {
      fileFound = _tryDefaultFile(fsPath, defaultDocument);
      if (fileFound == null && listDirectories) {
        final uri = request.requestedUri;
        if (!uri.path.endsWith('/')) return _redirectToAddTrailingSlash(uri);
        return listDirectory(fileSystemPath, fsPath);
      }
    }

    if (fileFound == null) {
      return Response.notFound(
        body: Body.fromString('Not Found'),
      );
    }
    final file = fileFound;

    if (!serveFilesOutsidePath) {
      final resolvedPath = file.resolveSymbolicLinksSync();

      // Do not serve a file outside of the original fileSystemPath
      if (!p.isWithin(fileSystemPath, resolvedPath)) {
        return Response.notFound(
          body: Body.fromString('Not Found'),
        );
      }
    }

    // when serving the default document for a directory, if the requested
    // path doesn't end with '/', redirect to the path with a trailing '/'
    final uri = request.requestedUri;
    if (entityType == FileSystemEntityType.directory &&
        !uri.path.endsWith('/')) {
      return _redirectToAddTrailingSlash(uri);
    }

    return _handleFile(request, file, getContentType: () async {
      if (useHeaderBytesForContentType) {
        final length =
            math.min(mimeResolver.magicNumbersMaxLength, file.lengthSync());

        final byteSink = ByteAccumulatorSink();

        await file.openRead(0, length).listen(byteSink.add).asFuture<void>();

        var type = mimeResolver.lookup(file.path, headerBytes: byteSink.bytes);
        if (type == null) return null;

        return MimeType.parse(type);
      } else {
        var type = mimeResolver.lookup(file.path);
        if (type == null) return null;
        return MimeType.parse(type);
      }
    });
  };
}

Response _redirectToAddTrailingSlash(Uri uri) {
  final location = Uri(
      scheme: uri.scheme,
      userInfo: uri.userInfo,
      host: uri.host,
      port: uri.port,
      path: '${uri.path}/',
      query: uri.query);

  return Response.movedPermanently(location);
}

File? _tryDefaultFile(String dirPath, String? defaultFile) {
  if (defaultFile == null) return null;

  final filePath = p.join(dirPath, defaultFile);

  final file = File(filePath);

  if (file.existsSync()) {
    return file;
  }

  return null;
}

/// Creates a Relic [Handler] that serves the file at [path].
///
/// This returns a 404 response for any requests whose [Request.url] doesn't
/// match [url]. The [url] defaults to the basename of [path].
///
/// This uses the given [contentType] for the Content-Type header. It defaults
/// to looking up a content type based on [path]'s file extension, and failing
/// that doesn't sent a [contentType] header at all.
Handler createFileHandler(
  String path, {
  String? url,
  MimeType? contentType,
}) {
  final file = File(path);
  if (!file.existsSync()) {
    throw ArgumentError.value(path, 'path', 'does not exist.');
  } else if (url != null && !p.url.isRelative(url)) {
    throw ArgumentError.value(url, 'url', 'must be relative.');
  }

  url ??= p.toUri(p.basename(path)).toString();

  return (request) {
    if (request.url.path != url) {
      return Response.notFound(
        body: Body.fromString(
          'Not Found',
        ),
      );
    }

    var mimeType = contentType;
    if (mimeType == null) {
      var type = _defaultMimeTypeResolver.lookup(path);
      if (type != null) {
        mimeType = MimeType.parse(type);
      }
    }
    return _handleFile(
      request,
      file,
      getContentType: () => mimeType,
    );
  };
}

/// Serves the contents of [file] in response to [request].
///
/// This handles caching, and sends a 304 Not Modified response if the request
/// indicates that it has the latest version of a file. Otherwise, it calls
/// [getContentType] and uses it to populate the Content-Type header.
Future<Response> _handleFile(
  Request request,
  File file, {
  required FutureOr<MimeType?> Function() getContentType,
}) async {
  final stat = file.statSync();
  final ifModifiedSince = request.headers.ifModifiedSince;

  if (ifModifiedSince != null) {
    final fileChangeAtSecResolution = stat.modified.toSecondResolution;
    if (!fileChangeAtSecResolution.isAfter(ifModifiedSince)) {
      return Response.notModified();
    }
  }
  final headers = Headers.response(
    lastModified: stat.modified,
    acceptRanges: AcceptRangesHeader.bytes(),
  );

  var response = _fileRangeResponse(request, file, headers);
  if (response != null) return response;

  Body? body;

  if (request.method != RequestMethod.head) {
    body = Body.fromDataStream(
      file.openRead().cast<Uint8List>(),
      mimeType: await getContentType(),
      contentLength: file.lengthSync(),
    );
  }

  return Response.ok(
    body: body,
    headers: Headers.response(
      lastModified: file.lastModifiedSync(),
    ),
  );
}

/// Serves a range of [file], if [request] is valid 'bytes' range request.
///
/// If the request does not specify a range, specifies a range of the wrong
/// type, or has a syntactic error the range is ignored and `null` is returned.
///
/// If the range request is valid but the file is not long enough to include the
/// start of the range a range not satisfiable response is returned.
///
/// Ranges that end past the end of the file are truncated.
Response? _fileRangeResponse(
  Request request,
  File file,
  Headers headers,
) {
  final range = request.headers.range;
  if (range == null) return null;

  final actualLength = file.lengthSync();
  final startMatch = range.ranges.firstOrNull?.start;
  final endMatch = range.ranges.firstOrNull?.end;

  if (startMatch == null && endMatch == null) return null;

  int start; // First byte position - inclusive.
  int end; // Last byte position - inclusive.

  if (startMatch == null) {
    // If start is missing, calculate based on the end range (suffix byte range).
    start = actualLength - (endMatch ?? 0);
    if (start < 0) start = 0;
    end = actualLength - 1;
  } else {
    // Use the provided start, and if end is missing, default to the file length.
    start = startMatch;
    end = endMatch ?? actualLength - 1;
  }

  // If the range is syntactically invalid the Range header
  // MUST be ignored (RFC 2616 section 14.35.1).
  if (start > end) return null;

  // Adjust end if it's beyond the actual file length.
  if (end >= actualLength) {
    end = actualLength - 1;
  }

  if (start >= actualLength) {
    return Response(
      HttpStatus.requestedRangeNotSatisfiable,
      headers: headers,
    );
  }

  Body? body;
  if (request.method != RequestMethod.head) {
    body = Body.fromDataStream(
      file.openRead(start, end + 1).cast<Uint8List>(),
      encoding: null,
      contentLength: (end - start) + 1,
      mimeType: MimeType.binary,
    );
  }

  return Response(
    HttpStatus.partialContent,
    body: body,
    headers: headers.copyWith(
      contentRange: ContentRangeHeader(
        start: start,
        end: end,
        size: actualLength,
      ),
    ),
  );
}
