/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class _Undefined {}

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
  final String filePath;

  /// The upload description, including any authentication keys required to do
  /// the upload.
  final String uploadDescription;

  late Function({
    String? filePath,
    String? uploadDescription,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'uploadDescription': uploadDescription,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ChatMessageAttachmentUploadDescription &&
            (identical(
                  other.filePath,
                  filePath,
                ) ||
                other.filePath == filePath) &&
            (identical(
                  other.uploadDescription,
                  uploadDescription,
                ) ||
                other.uploadDescription == uploadDescription));
  }

  @override
  int get hashCode => Object.hash(
        filePath,
        uploadDescription,
      );

  ChatMessageAttachmentUploadDescription _copyWith({
    String? filePath,
    String? uploadDescription,
  }) {
    return ChatMessageAttachmentUploadDescription(
      filePath: filePath ?? this.filePath,
      uploadDescription: uploadDescription ?? this.uploadDescription,
    );
  }
}
