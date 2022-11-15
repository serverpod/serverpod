/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

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

  String fileName;

  String url;

  String contentType;

  String? previewImage;

  int? previewWidth;

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
