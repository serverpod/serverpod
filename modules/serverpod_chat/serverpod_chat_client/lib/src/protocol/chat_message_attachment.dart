/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// An attachement to a chat message. Typically an image or a file.
abstract class ChatMessageAttachment extends _i1.SerializableEntity {
  ChatMessageAttachment._({
    required this.fileName,
    required this.url,
    required this.contentType,
    this.previewImage,
    this.previewWidth,
    this.previewHeight,
  });

  factory ChatMessageAttachment({
    required String fileName,
    required String url,
    required String contentType,
    String? previewImage,
    int? previewWidth,
    int? previewHeight,
  }) = _ChatMessageAttachmentImpl;

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

  /// The name of the file.
  String fileName;

  /// The URL to the file.
  String url;

  /// The content type of the file.
  String contentType;

  /// URL to an image preview of the file, if available.
  String? previewImage;

  /// The width of the image preview, if available.
  int? previewWidth;

  /// The height of the image preview, if available.
  int? previewHeight;

  ChatMessageAttachment copyWith({
    String? fileName,
    String? url,
    String? contentType,
    String? previewImage,
    int? previewWidth,
    int? previewHeight,
  });
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
}

class _Undefined {}

class _ChatMessageAttachmentImpl extends ChatMessageAttachment {
  _ChatMessageAttachmentImpl({
    required String fileName,
    required String url,
    required String contentType,
    String? previewImage,
    int? previewWidth,
    int? previewHeight,
  }) : super._(
          fileName: fileName,
          url: url,
          contentType: contentType,
          previewImage: previewImage,
          previewWidth: previewWidth,
          previewHeight: previewHeight,
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
      previewImage: previewImage is! String? ? this.previewImage : previewImage,
      previewWidth: previewWidth is! int? ? this.previewWidth : previewWidth,
      previewHeight:
          previewHeight is! int? ? this.previewHeight : previewHeight,
    );
  }
}
