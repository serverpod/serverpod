/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class ChatMessageAttachmentUploadDescription extends _i1.SerializableEntity {
  ChatMessageAttachmentUploadDescription({
    required this.filePath,
    required this.uploadDescription,
  });

  factory ChatMessageAttachmentUploadDescription.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatMessageAttachmentUploadDescription(
      filePath: serializationManager
          .deserializeJson<String>(jsonSerialization['filePath']),
      uploadDescription: serializationManager
          .deserializeJson<String>(jsonSerialization['uploadDescription']),
    );
  }

  String filePath;

  String uploadDescription;

  @override
  String get className =>
      'serverpod_chat_server.ChatMessageAttachmentUploadDescription';
  @override
  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'uploadDescription': uploadDescription,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'filePath': filePath,
      'uploadDescription': uploadDescription,
    };
  }
}
