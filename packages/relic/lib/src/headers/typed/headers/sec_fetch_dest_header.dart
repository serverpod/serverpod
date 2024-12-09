import 'package:relic/src/headers/typed/base/typed_header.dart';

/// A class representing the HTTP Sec-Fetch-Dest header.
///
/// This header indicates the destination of the request.
class SecFetchDestHeader extends TypedHeader {
  /// The destination value of the request.
  final String destination;

  /// Private constructor for [SecFetchDestHeader].
  const SecFetchDestHeader(this.destination);

  /// Predefined destination values.
  static const _audio = 'audio';
  static const _audioworklet = 'audioworklet';
  static const _document = 'document';
  static const _embed = 'embed';
  static const _empty = 'empty';
  static const _fencedframe = 'fencedframe';
  static const _font = 'font';
  static const _frame = 'frame';
  static const _iframe = 'iframe';
  static const _image = 'image';
  static const _manifest = 'manifest';
  static const _object = 'object';
  static const _paintworklet = 'paintworklet';
  static const _report = 'report';
  static const _script = 'script';
  static const _serviceworker = 'serviceworker';
  static const _sharedworker = 'sharedworker';
  static const _style = 'style';
  static const _track = 'track';
  static const _video = 'video';
  static const _webidentity = 'webidentity';
  static const _worker = 'worker';
  static const _xslt = 'xslt';

  static const audio = SecFetchDestHeader(_audio);
  static const audioworklet = SecFetchDestHeader(_audioworklet);
  static const document = SecFetchDestHeader(_document);
  static const embed = SecFetchDestHeader(_embed);
  static const empty = SecFetchDestHeader(_empty);
  static const fencedframe = SecFetchDestHeader(_fencedframe);
  static const font = SecFetchDestHeader(_font);
  static const frame = SecFetchDestHeader(_frame);
  static const iframe = SecFetchDestHeader(_iframe);
  static const image = SecFetchDestHeader(_image);
  static const manifest = SecFetchDestHeader(_manifest);
  static const object = SecFetchDestHeader(_object);
  static const paintworklet = SecFetchDestHeader(_paintworklet);
  static const report = SecFetchDestHeader(_report);
  static const script = SecFetchDestHeader(_script);
  static const serviceworker = SecFetchDestHeader(_serviceworker);
  static const sharedworker = SecFetchDestHeader(_sharedworker);
  static const style = SecFetchDestHeader(_style);
  static const track = SecFetchDestHeader(_track);
  static const video = SecFetchDestHeader(_video);
  static const webidentity = SecFetchDestHeader(_webidentity);
  static const worker = SecFetchDestHeader(_worker);
  static const xslt = SecFetchDestHeader(_xslt);

  /// Parses a [value] and returns the corresponding [SecFetchDestHeader] instance.
  /// If the value does not match any predefined types, it returns a custom instance.
  factory SecFetchDestHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    switch (trimmed) {
      case _audio:
        return audio;
      case _audioworklet:
        return audioworklet;
      case _document:
        return document;
      case _embed:
        return embed;
      case _empty:
        return empty;
      case _fencedframe:
        return fencedframe;
      case _font:
        return font;
      case _frame:
        return frame;
      case _iframe:
        return iframe;
      case _image:
        return image;
      case _manifest:
        return manifest;
      case _object:
        return object;
      case _paintworklet:
        return paintworklet;
      case _report:
        return report;
      case _script:
        return script;
      case _serviceworker:
        return serviceworker;
      case _sharedworker:
        return sharedworker;
      case _style:
        return style;
      case _track:
        return track;
      case _video:
        return video;
      case _webidentity:
        return webidentity;
      case _worker:
        return worker;
      case _xslt:
        return xslt;
      default:
        return SecFetchDestHeader(trimmed);
    }
  }

  /// Converts the [SecFetchDestHeader] instance into a string representation
  /// suitable for HTTP headers.
  @override
  String toHeaderString() => destination;

  @override
  String toString() {
    return 'SecFetchDestHeader(value: $destination)';
  }
}
