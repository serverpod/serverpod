import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Sec-Fetch-Dest header.
///
/// This header indicates the destination of the request.
class SecFetchDestHeader implements TypedHeader {
  /// The destination value of the request.
  final String destination;

  /// Private constructor for [SecFetchDestHeader].
  const SecFetchDestHeader._(this.destination);

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

  static const audio = SecFetchDestHeader._(_audio);
  static const audioworklet = SecFetchDestHeader._(_audioworklet);
  static const document = SecFetchDestHeader._(_document);
  static const embed = SecFetchDestHeader._(_embed);
  static const empty = SecFetchDestHeader._(_empty);
  static const fencedframe = SecFetchDestHeader._(_fencedframe);
  static const font = SecFetchDestHeader._(_font);
  static const frame = SecFetchDestHeader._(_frame);
  static const iframe = SecFetchDestHeader._(_iframe);
  static const image = SecFetchDestHeader._(_image);
  static const manifest = SecFetchDestHeader._(_manifest);
  static const object = SecFetchDestHeader._(_object);
  static const paintworklet = SecFetchDestHeader._(_paintworklet);
  static const report = SecFetchDestHeader._(_report);
  static const script = SecFetchDestHeader._(_script);
  static const serviceworker = SecFetchDestHeader._(_serviceworker);
  static const sharedworker = SecFetchDestHeader._(_sharedworker);
  static const style = SecFetchDestHeader._(_style);
  static const track = SecFetchDestHeader._(_track);
  static const video = SecFetchDestHeader._(_video);
  static const webidentity = SecFetchDestHeader._(_webidentity);
  static const worker = SecFetchDestHeader._(_worker);
  static const xslt = SecFetchDestHeader._(_xslt);

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
        throw FormatException('Invalid value');
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
