import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'session_manager.dart';

class ImageUploader {
  static Future<void> updateUserImage({
    required BuildContext context,
    required SessionManager sessionManager,
    int imageSize = 256,
  }) async {

    var toolbarColor = Theme.of(context).primaryColor;
    var toolbarWidgetColor = Theme.of(context).buttonTheme.colorScheme?.onPrimary ?? Colors.white;

    final picker = ImagePicker();
    // Pick an image
    var imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null)
      return;

    print('picked image: $imageFile');

    if (kIsWeb) {
      var image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null)
        return;

      print('loaded image');
      image = img.copyResizeCropSquare(image, imageSize);

      print('resized image');

      // Encode as png
      var encoded = img.encodePng(image);
      var bytes = Uint8List.fromList(encoded);
      var data = ByteData.view(bytes.buffer);

      // Upload the image to the server
      await sessionManager.uploadUserImage(data);
    }
    else {
      // Crop the image
      var croppedImageFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        maxHeight: imageSize,
        maxWidth: imageSize,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: toolbarColor,
            toolbarWidgetColor: toolbarWidgetColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      if (croppedImageFile == null)
        return;

      // Load and resize
      var image = img.decodeImage(await croppedImageFile.readAsBytes());
      if (image == null)
        return;

      if (image.width != imageSize || image.height != imageSize);
      image = img.copyResize(image, width: imageSize, height: imageSize);

      // Encode as png
      var encoded = img.encodePng(image);
      var bytes = Uint8List.fromList(encoded);
      var data = ByteData.view(bytes.buffer);

      // Upload the image to the server
      await sessionManager.uploadUserImage(data);
    }
  }
}