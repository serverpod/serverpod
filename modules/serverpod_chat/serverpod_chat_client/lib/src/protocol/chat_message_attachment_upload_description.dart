/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A description for uploading an attachment.
abstract class ChatMessageAttachmentUploadDescription
    implements _i1.SerializableModel {
  ChatMessageAttachmentUploadDescription._({
    required this.filePath,
    required this.uploadDescription,
  });

  factory ChatMessageAttachmentUploadDescription({
    required String filePath,
    required String uploadDescription,
  }) = _ChatMessageAttachmentUploadDescriptionImpl;

  factory ChatMessageAttachmentUploadDescription.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ChatMessageAttachmentUploadDescription(
      filePath: jsonSerialization['filePath'] as String,
      uploadDescription: jsonSerialization['uploadDescription'] as String,
    );
  }

  /// The path where the file should be uploaded.
  String filePath;

  /// The upload description, including any authentication keys required to do
  /// the upload.
  String uploadDescription;

  /// Returns a shallow copy of this [ChatMessageAttachmentUploadDescription]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatMessageAttachmentUploadDescription copyWith({
    String? filePath,
    String? uploadDescription,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'uploadDescription': uploadDescription,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatMessageAttachmentUploadDescriptionImpl
    extends ChatMessageAttachmentUploadDescription {
  _ChatMessageAttachmentUploadDescriptionImpl({
    required String filePath,
    required String uploadDescription,
  }) : super._(
          filePath: filePath,
          uploadDescription: uploadDescription,
        );

  /// Returns a shallow copy of this [ChatMessageAttachmentUploadDescription]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
