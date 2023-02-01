/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A description for uploading an attachement.
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
          .deserialize<String>(jsonSerialization['filePath']),
      uploadDescription: serializationManager
          .deserialize<String>(jsonSerialization['uploadDescription']),
    );
  }

  /// The path where the file should be uploaded.
  String filePath;

  /// The upload description, including any authentication keys required to do
  /// the upload.
  String uploadDescription;

  @override
  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'uploadDescription': uploadDescription,
    };
  }
}
