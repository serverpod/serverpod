import 'dart:io';
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
    http.Response result = await http.get(url);
    Uint8List bytes = result.bodyBytes;
    return await setUserImageFromBytes(session, userId, bytes);
  }

  /// Sets a user's image from image data. The image is resized before being
  /// stored in the cloud and associated with the user.
  static Future<bool> setUserImageFromBytes(
      Session session, int userId, Uint8List bytes) async {
    Image? image = decodeImage(bytes);
    if (image == null) return false;

    int imageSize = AuthConfig.current.userImageSize;
    if (image.width != imageSize || image.height != imageSize) {
      image = copyResizeCropSquare(image, imageSize);
    }

    ByteData imageData = _encodeImage(image);

    return await _setUserImage(session, userId, imageData);
  }

  /// Sets a user's image to the default image for that user.
  static Future<bool> setDefaultUserImage(Session session, int userId) async {
    UserInfo? userInfo = await Users.findUserByUserId(session, userId);
    if (userInfo == null) return false;

    Image image = await AuthConfig.current.userImageGenerator(userInfo);
    ByteData imageData = _encodeImage(image);

    return await _setUserImage(session, userId, imageData);
  }

  static ByteData _encodeImage(Image image) {
    UserImageType format = AuthConfig.current.userImageFormat;
    List<int> encoded;
    if (format == UserImageType.jpg) {
      encoded = encodeJpg(image, quality: AuthConfig.current.userImageQuality);
    } else {
      encoded = encodePng(image);
    }

    // Reference as ByteData.
    Uint8List encodedBytes = Uint8List.fromList(encoded);
    return ByteData.view(encodedBytes.buffer);
  }

  static Future<bool> _setUserImage(
      Session session, int userId, ByteData imageData) async {
    // Find the latest version of the user image if any.
    UserImage? oldImageRef = await session.db.findSingleRow<UserImage>(
      where: UserImage.t.userId.equals(userId),
      orderDescending: true,
      orderBy: UserImage.t.version,
    );

    // Add one to the version number or create a new version 1.
    int version = (oldImageRef?.version ?? 0) + 1;

    String pathExtension;
    if (AuthConfig.current.userImageFormat == UserImageType.jpg) {
      pathExtension = '.jpg';
    } else {
      pathExtension = '.png';
    }

    // Store the image.
    String path = 'serverpod/user_images/$userId-$version$pathExtension';
    await session.storage
        .storeFile(storageId: 'public', path: path, byteData: imageData);
    Uri? publicUrl =
        await session.storage.getPublicUrl(storageId: 'public', path: path);
    if (publicUrl == null) return false;

    // Store the path to the image.
    UserImage imageRef =
        UserImage(userId: userId, version: version, url: publicUrl.toString());
    await session.db.insert(imageRef);

    // Update the UserInfo with the new image path.
    UserInfo? userInfo =
        await Users.findUserByUserId(session, userId, useCache: false);
    if (userInfo == null) return false;
    userInfo.imageUrl = publicUrl.toString();
    await session.db.update(userInfo);

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

List<int> _defaultUserImageColors = <int>[
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
Future<Image> defaultUserImageGenerator(UserInfo userInfo) async {
  int imageSize = AuthConfig.current.userImageSize;
  Image image = Image(256, 256);

  BitmapFont font = roboto_138;

  // Get first letter of the user name (or * if not found in bitmap font).
  String name = userInfo.userName;
  int charCode =
      (name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '*').codeUnits[0];
  if (font.characters[charCode] == null) charCode = '*'.codeUnits[0];

  // Draw the image.
  int chWidth = font.characters[charCode]!.width;
  int chHeight = font.characters[charCode]!.height;
  int chOffsetY = font.characters[charCode]!.yoffset;
  int chOffsetX = font.characters[charCode]!.xoffset;
  int xPos = 128 - chWidth ~/ 2;
  int yPos = 128 - chHeight ~/ 2;

  // Pick color based on user id from the default colors (from material design).
  fill(image,
      _defaultUserImageColors[userInfo.id! % _defaultUserImageColors.length]);

  // Draw the character on top of the solid filled image.
  drawString(image, font, xPos - chOffsetX, yPos - chOffsetY,
      String.fromCharCode(charCode));

  // Resize image if it's not the preferred size.
  if (imageSize != 256) image = copyResizeCropSquare(image, imageSize);

  return image;
}
