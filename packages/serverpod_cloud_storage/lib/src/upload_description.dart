import 'dart:convert';

/// Type of a cloud storage upload.
enum UploadType {
  /// Multipart HTTP upload.
  multipart,

  /// Binary upload.
  binary,
}

/// Description for a cloud storage upload.
sealed class UploadDescription {
  /// Creates a new [UploadDescription].
  const UploadDescription({required this.url});

  /// Upload URL.
  final Uri url;

  /// Type of the upload.
  UploadType get type;

  /// Converts this upload description to its JSON representation.
  Map<String, Object?> toJson();

  /// Encodes this upload description for use by a `FileUploader`.
  String encode() => jsonEncode(toJson());
}

/// Description for an upload using a binary HTTP request.
final class BinaryUploadDescription extends UploadDescription {
  /// Creates a new [BinaryUploadDescription].
  const BinaryUploadDescription({
    required super.url,
    this.fileName,
    this.method,
    this.headers = const {},
  });

  @override
  UploadType get type => UploadType.binary;

  /// Name of the file.
  final String? fileName;

  /// Optional HTTP method.
  final String? method;

  /// Headers to be attached to the upload.
  final Map<String, String> headers;

  @override
  Map<String, Object?> toJson() {
    return {
      'url': url.toString(),
      'type': type.name,
      'headers': headers,
      if (fileName != null) 'file-name': fileName,
      if (method != null) 'method': method,
    };
  }
}

/// Description for an upload using a multipart HTTP request.
final class MultipartUploadDescription extends UploadDescription {
  /// Creates a new [MultipartUploadDescription].
  const MultipartUploadDescription({
    required super.url,
    required this.field,
    required this.fileName,
    this.requestFields = const {},
  });

  @override
  UploadType get type => UploadType.multipart;

  /// Name of the multipart form field containing the file.
  final String field;

  /// Name of the file.
  final String fileName;

  /// Additional fields to be attached to the multipart request.
  final Map<String, String> requestFields;

  @override
  Map<String, Object?> toJson() {
    return {
      'url': url.toString(),
      'type': type.name,
      'field': field,
      'file-name': fileName,
      'request-fields': requestFields,
    };
  }
}
