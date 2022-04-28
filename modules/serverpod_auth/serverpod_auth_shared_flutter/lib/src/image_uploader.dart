import 'dart:io';
import 'dart:typed_data';

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
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: <String>['jpg', 'png'],
      );
      if (result == null) return;
      if (result.files.first.bytes == null) return;

      img.Image? image = img.decodeImage(result.files.first.bytes!);
      if (image == null) return;

      if (image.width > image.height) {
        int h = imageSize;
        double w = imageSize * image.width / image.height;
        image = img.copyResize(image,
            width: w.floor(),
            height: h,
            interpolation: img.Interpolation.average);
      } else {
        int w = imageSize;
        double h = imageSize * image.height / image.width;
        image = img.copyResize(image,
            width: w,
            height: h.floor(),
            interpolation: img.Interpolation.average);
      }

      image = img.copyResizeCropSquare(image, imageSize);

      // Encode as png
      List<int> encoded = img.encodePng(image);
      Uint8List bytes = Uint8List.fromList(encoded);
      ByteData data = ByteData.view(bytes.buffer);

      // Upload the image to the server
      await sessionManager.uploadUserImage(data);
    } else {
      Color toolbarColor = Theme.of(context).primaryColor;
      Color toolbarWidgetColor =
          Theme.of(context).buttonTheme.colorScheme?.onPrimary ?? Colors.white;

      ImagePicker picker = ImagePicker();
      // Pick an image
      XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);
      if (imageFile == null) return;

      // Crop the image
      File? croppedImageFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        maxHeight: imageSize,
        maxWidth: imageSize,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: toolbarColor,
            toolbarWidgetColor: toolbarWidgetColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      if (croppedImageFile == null) return;

      // Load and resize
      img.Image? image = img.decodeImage(await croppedImageFile.readAsBytes());
      if (image == null) return;

      if (image.width != imageSize || image.height != imageSize) {
        image = img.copyResize(image, width: imageSize, height: imageSize);
      }

      // Encode as png
      List<int> encoded = img.encodePng(image);
      Uint8List bytes = Uint8List.fromList(encoded);
      ByteData data = ByteData.view(bytes.buffer);

      // Upload the image to the server
      await sessionManager.uploadUserImage(data);
    }
  }
}
