/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A description for uploading an attachement.
abstract class ChatMessageAttachmentUploadDescription
    extends _i1.SerializableEntity {
  const ChatMessageAttachmentUploadDescription._();

  const factory ChatMessageAttachmentUploadDescription({
    required String filePath,
    required String uploadDescription,
  }) = _ChatMessageAttachmentUploadDescription;

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

  ChatMessageAttachmentUploadDescription copyWith({
    String? filePath,
    String? uploadDescription,
  });

  /// The path where the file should be uploaded.
  String get filePath;

  /// The upload description, including any authentication keys required to do
  /// the upload.
  String get uploadDescription;
}

/// A description for uploading an attachement.
class _ChatMessageAttachmentUploadDescription
    extends ChatMessageAttachmentUploadDescription {
  const _ChatMessageAttachmentUploadDescription({
    required this.filePath,
    required this.uploadDescription,
  }) : super._();

  /// The path where the file should be uploaded.
  @override
  final String filePath;

  /// The upload description, including any authentication keys required to do
  /// the upload.
  @override
  final String uploadDescription;

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

  @override
  ChatMessageAttachmentUploadDescription copyWith({
    String? filePath,
    String? uploadDescription,
  }) {
    return ChatMessageAttachmentUploadDescription(
      filePath: filePath ?? this.filePath,
      uploadDescription: uploadDescription ?? this.uploadDescription,
    );
  }
}
