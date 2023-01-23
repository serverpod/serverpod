/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// An attachement to a chat message. Typically an image or a file.
class ChatMessageAttachment extends _i1.SerializableEntity {
  ChatMessageAttachment({
    required this.fileName,
    required this.url,
    required this.contentType,
    this.previewImage,
    this.previewWidth,
    this.previewHeight,
  });

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
  Map<String, dynamic> allToJson() {
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
