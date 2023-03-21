import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'session_manager.dart';

/// Use the image uploader to upload avatars associated with a users account.
class ImageUploader {
  /// Uploads a new image for a user. The user will be asked to pick a file,
  /// and is offered to crop the image (cropping is not available on web).
  /// The file is then uploaded to the server. An
  static Future<void> updateUserImage({
    required BuildContext context,
    required SessionManager sessionManager,
    int imageSize = 256,
  }) async {
    if (kIsWeb) {
      var result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png'],
      );
      if (result == null) return;
      if (result.files.first.bytes == null) return;

      var image = img.decodeImage(result.files.first.bytes!);
      if (image == null) return;

      if (image.width > image.height) {
        var h = imageSize;
        var w = imageSize * image.width / image.height;
        image = img.copyResize(image,
            width: w.floor(),
            height: h,
            interpolation: img.Interpolation.average);
      } else {
        var w = imageSize;
        var h = imageSize * image.height / image.width;
        image = img.copyResize(image,
            width: w,
            height: h.floor(),
            interpolation: img.Interpolation.average);
      }

      image = img.copyResizeCropSquare(image, size: imageSize);

      // Encode as png
      var encoded = img.encodePng(image);
      var bytes = Uint8List.fromList(encoded);
      var data = ByteData.view(bytes.buffer);

      // Upload the image to the server
      await sessionManager.uploadUserImage(data);
    } else {
      var toolbarColor = Theme.of(context).primaryColor;
      var toolbarWidgetColor =
          Theme.of(context).buttonTheme.colorScheme?.onPrimary ?? Colors.white;

      var picker = ImagePicker();
      // Pick an image
      var imageFile = await picker.pickImage(source: ImageSource.gallery);
      if (imageFile == null) return;

      // Crop the image
      var croppedImageFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        maxHeight: imageSize,
        maxWidth: imageSize,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        cropStyle: CropStyle.circle,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: toolbarColor,
              toolbarWidgetColor: toolbarWidgetColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedImageFile == null) return;

      // Load and resize
      var image = img.decodeImage(await croppedImageFile.readAsBytes());
      if (image == null) return;

      if (image.width != imageSize || image.height != imageSize) {
        image = img.copyResize(image, width: imageSize, height: imageSize);
      }

      // Encode as png
      var encoded = img.encodePng(image);
      var bytes = Uint8List.fromList(encoded);
      var data = ByteData.view(bytes.buffer);

      // Upload the image to the server
      await sessionManager.uploadUserImage(data);
    }
  }
}
