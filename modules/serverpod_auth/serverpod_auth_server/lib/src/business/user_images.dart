import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:serverpod/serverpod.dart';

import '../../module.dart';
import '../util/roboto_138_fnt.dart';

/// Business logic to handle user images.
class UserImages {
  /// Sets a user's image from the provided [url]. Image is downloaded, stored
  /// in the cloud and associated with the user.
  static Future<bool> setUserImageFromUrl(
      Session session, int userId, Uri url) async {
    var result = await http.get(url);
    var bytes = result.bodyBytes;
    return await setUserImageFromBytes(session, userId, bytes);
  }

  /// Sets a user's image from image data. The image is resized before being
  /// stored in the cloud and associated with the user.
  static Future<bool> setUserImageFromBytes(
      Session session, int userId, Uint8List imageBytes,) async {
    var reEncodedImageBytes = await Isolate.run(() async {
      var image = decodeImage(imageBytes);
      if (image == null) return null;
      var imageSize = AuthConfig.current.userImageSize;
      if (image.width != imageSize || image.height != imageSize) {
        image = copyResizeCropSquare(image,
            size: imageSize, interpolation: Interpolation.average);
      }
      return _encodeImage(image);
    });
    return reEncodedImageBytes == null
        ? false
        : await _setUserImage(session, userId, reEncodedImageBytes);
  }

  /// Sets a user's image to the default image for that user.
  static Future<bool> setDefaultUserImage(Session session, int userId) async {
    var userInfo = await Users.findUserByUserId(session, userId);
    if (userInfo == null) return false;

    var image = await AuthConfig.current.userImageGenerator(userInfo);
    var imageBytes = await Isolate.run(() => _encodeImage(image));

    return await _setUserImage(session, userId, imageBytes);
  }

  static Uint8List _encodeImage(Image image) =>
      AuthConfig.current.userImageFormat == UserImageType.jpg
          ? encodeJpg(image, quality: AuthConfig.current.userImageQuality)
          : encodePng(image);

  static Future<bool> _setUserImage(
      Session session, int userId, Uint8List imageBytes) async {
    // Find the latest version of the user image if any.
    var oldImageRef = await UserImage.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
      orderDescending: true,
      orderBy: (t) => t.version,
    );

    // Add one to the version number or create a new version 1.
    var version = (oldImageRef?.version ?? 0) + 1;

    String pathExtension;
    if (AuthConfig.current.userImageFormat == UserImageType.jpg) {
      pathExtension = '.jpg';
    } else {
      pathExtension = '.png';
    }

    // Store the image.
    var path = 'serverpod/user_images/$userId-$version$pathExtension';
    await session.storage.storeFile(
        storageId: 'public',
        path: path,
        byteData: ByteData.view(imageBytes.buffer));
    var publicUrl =
        await session.storage.getPublicUrl(storageId: 'public', path: path);
    if (publicUrl == null) return false;

    // Store the path to the image.
    var imageRef =
        UserImage(userId: userId, version: version, url: publicUrl.toString());
    await UserImage.db.insertRow(session, imageRef);

    // Update the UserInfo with the new image path.
    var userInfo =
        await Users.findUserByUserId(session, userId, useCache: false);
    if (userInfo == null) return false;
    userInfo.imageUrl = publicUrl.toString();
    await UserInfo.db.updateRow(session, userInfo);

    if (AuthConfig.current.onUserUpdated != null) {
      await AuthConfig.current.onUserUpdated!(session, userInfo);
    }

    return true;
  }
}

/// Exception thrown when setting a user's image.
class UserImageException extends IOException {
  /// Message describing the issue.
  final String message;

  /// Creates a new exception.
  UserImageException(this.message);

  @override
  String toString() {
    return 'UserImageException: $message';
  }
}

var _defaultUserImageColors = <int>[
  _colorFromHexStr('D32F2F'),
  _colorFromHexStr('D81B60'),
  _colorFromHexStr('AB47BC'),
  _colorFromHexStr('7E57C2'),
  _colorFromHexStr('5C6BC0'),
  _colorFromHexStr('1976D2'),
  _colorFromHexStr('0277BD'),
  _colorFromHexStr('006064'),
  _colorFromHexStr('00796B'),
  _colorFromHexStr('2E7D32'),
  _colorFromHexStr('33691E'),
  _colorFromHexStr('BF360C'),
  _colorFromHexStr('8D6E63'),
  _colorFromHexStr('546E7A'),
];

int _colorFromHexStr(String hexStr) {
  return int.parse(hexStr, radix: 16) | 0xff000000;
}

/// The default [UserImageGenerator], mimics the default avatars used by Google.
Future<Image> defaultUserImageGenerator(UserInfo userInfo) => Isolate.run(() {
      var imageSize = AuthConfig.current.userImageSize;
      var image = Image(width: 256, height: 256);

      var font = roboto_138;

      // Get first letter of the user name (or * if not found in bitmap font).
      var name = userInfo.userName;
      var charCode =
          (name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '*')
              .codeUnits[0];
      if (font.characters[charCode] == null) charCode = '*'.codeUnits[0];

      // Draw the image.
      var chWidth = font.characters[charCode]!.width;
      var chHeight = font.characters[charCode]!.height;
      var chOffsetY = font.characters[charCode]!.yOffset;
      var chOffsetX = font.characters[charCode]!.xOffset;
      var xPos = 128 - chWidth ~/ 2;
      var yPos = 128 - chHeight ~/ 2;

      // Pick color based on user id from the default colors (from material design).
      var color = _defaultUserImageColors[
          userInfo.id! % _defaultUserImageColors.length];
      fill(image,
          color: ColorUint8.rgba((color >> 16) & 0xff, (color >> 16) & 0xff,
              color & 0xff, (color >> 24) & 0xff));

      // Draw the character on top of the solid filled image.
      drawString(image, String.fromCharCode(charCode),
          font: font, x: xPos - chOffsetX, y: yPos - chOffsetY);

      // Resize image if it's not the preferred size.
      return imageSize == 256
          ? image
          : copyResizeCropSquare(image, size: imageSize);
    });
