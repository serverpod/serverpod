/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// An attachement to a chat message. Typically an image or a file.
abstract class ChatMessageAttachment extends _i1.SerializableEntity {
  const ChatMessageAttachment._();

  const factory ChatMessageAttachment({
    required String fileName,
    required String url,
    required String contentType,
    String? previewImage,
    int? previewWidth,
    int? previewHeight,
  }) = _ChatMessageAttachment;

  factory ChatMessageAttachment.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatMessageAttachment(
      fileName: serializationManager
          .deserialize<String>(jsonSerialization['fileName']),
      url: serializationManager.deserialize<String>(jsonSerialization['url']),
      contentType: serializationManager
          .deserialize<String>(jsonSerialization['contentType']),
      previewImage: serializationManager
          .deserialize<String?>(jsonSerialization['previewImage']),
      previewWidth: serializationManager
          .deserialize<int?>(jsonSerialization['previewWidth']),
      previewHeight: serializationManager
          .deserialize<int?>(jsonSerialization['previewHeight']),
    );
  }

  ChatMessageAttachment copyWith({
    String? fileName,
    String? url,
    String? contentType,
    String? previewImage,
    int? previewWidth,
    int? previewHeight,
  });

  /// The name of the file.
  String get fileName;

  /// The URL to the file.
  String get url;

  /// The content type of the file.
  String get contentType;

  /// URL to an image preview of the file, if available.
  String? get previewImage;

  /// The width of the image preview, if available.
  int? get previewWidth;

  /// The height of the image preview, if available.
  int? get previewHeight;
}

class _Undefined {}

/// An attachement to a chat message. Typically an image or a file.
class _ChatMessageAttachment extends ChatMessageAttachment {
  const _ChatMessageAttachment({
    required this.fileName,
    required this.url,
    required this.contentType,
    this.previewImage,
    this.previewWidth,
    this.previewHeight,
  }) : super._();

  /// The name of the file.
  @override
  final String fileName;

  /// The URL to the file.
  @override
  final String url;

  /// The content type of the file.
  @override
  final String contentType;

  /// URL to an image preview of the file, if available.
  @override
  final String? previewImage;

  /// The width of the image preview, if available.
  @override
  final int? previewWidth;

  /// The height of the image preview, if available.
  @override
  final int? previewHeight;

  @override
  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'url': url,
      'contentType': contentType,
      'previewImage': previewImage,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ChatMessageAttachment &&
            (identical(
                  other.fileName,
                  fileName,
                ) ||
                other.fileName == fileName) &&
            (identical(
                  other.url,
                  url,
                ) ||
                other.url == url) &&
            (identical(
                  other.contentType,
                  contentType,
                ) ||
                other.contentType == contentType) &&
            (identical(
                  other.previewImage,
                  previewImage,
                ) ||
                other.previewImage == previewImage) &&
            (identical(
                  other.previewWidth,
                  previewWidth,
                ) ||
                other.previewWidth == previewWidth) &&
            (identical(
                  other.previewHeight,
                  previewHeight,
                ) ||
                other.previewHeight == previewHeight));
  }

  @override
  int get hashCode => Object.hash(
        fileName,
        url,
        contentType,
        previewImage,
        previewWidth,
        previewHeight,
      );

  @override
  ChatMessageAttachment copyWith({
    String? fileName,
    String? url,
    String? contentType,
    Object? previewImage = _Undefined,
    Object? previewWidth = _Undefined,
    Object? previewHeight = _Undefined,
  }) {
    return ChatMessageAttachment(
      fileName: fileName ?? this.fileName,
      url: url ?? this.url,
      contentType: contentType ?? this.contentType,
      previewImage: previewImage == _Undefined
          ? this.previewImage
          : (previewImage as String?),
      previewWidth: previewWidth == _Undefined
          ? this.previewWidth
          : (previewWidth as int?),
      previewHeight: previewHeight == _Undefined
          ? this.previewHeight
          : (previewHeight as int?),
    );
  }
}
