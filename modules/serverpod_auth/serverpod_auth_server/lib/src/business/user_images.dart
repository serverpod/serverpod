import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:serverpod/serverpod.dart';
import '../../module.dart';
import '../business/users.dart';
import '../util/roboto_138_fnt.dart';

import 'config.dart';

class UserImages {
  static Future<bool> setUserImageFromUrl(Session session, int userId, Uri url) async {
    var result = await http.get(url);
    var bytes = result.bodyBytes;
    return await setUserImageFromBytes(session, userId, bytes);
  }

  static Future<bool> setUserImageFromBytes(Session session, int userId, Uint8List bytes) async {
    var image = decodeImage(bytes);
    if (image == null)
      return false;

    var imageSize = AuthConfig.current.userImageSize;
    if (image.width != imageSize || image.height != imageSize)
      image = copyResizeCropSquare(image, imageSize);

    var imageData = _encodeImage(image);

    return await _setUserImage(session, userId, imageData);
  }

  static Future<bool> setDefaultUserImage(Session session, int userId) async {
    var userInfo = await Users.findUserByUserId(session, userId);
    if (userInfo == null)
      return false;

    var image = await AuthConfig.current.userImageGenerator(userInfo);
    var imageData = _encodeImage(image);

    return await _setUserImage(session, userId, imageData);
  }

  static ByteData _encodeImage(Image image) {
    var format = AuthConfig.current.userImageFormat;
    List<int> encoded;
    if (format == UserImageType.jpg)
      encoded = encodeJpg(image, quality: AuthConfig.current.userImageQuality);
    else
      encoded = encodePng(image);

    // Reference as ByteData.
    var encodedBytes = Uint8List.fromList(encoded);
    return ByteData.view(encodedBytes.buffer);
  }

  static Future<bool> _setUserImage(Session session, int userId, ByteData imageData) async {
    // Find the latest version of the user image if any.
    var oldImageRef = await session.db.findSingleRow(
      tUserImage,
      where: tUserImage.userId.equals(userId),
      orderDescending: true,
      orderBy: tUserImage.version,
    ) as UserImage?;
    
    // Add one to the version number or create a new version 1.
    var version = (oldImageRef?.version ?? 0) + 1;

    String pathExtension;
    if (AuthConfig.current.userImageFormat == UserImageType.jpg)
      pathExtension = '.jpg';
    else
      pathExtension = '.png';
    
    // Store the image.
    var path = 'serverpod/user_images/$userId-$version$pathExtension';
    await session.storage.storeFile(storageId: 'public', path: path, byteData: imageData);
    var publicUrl = await session.storage.getPublicUrl(storageId: 'public', path: path);
    if (publicUrl == null)
      return false;

    // Store the path to the image.
    var imageRef = UserImage(userId: userId, version: version, url: publicUrl.toString());
    await session.db.insert(imageRef);

    // Update the UserInfo with the new image path.
    var user = await Users.findUserByUserId(session, userId);
    if (user == null)
      return false;
    user.imageUrl = publicUrl.toString();
    await session.db.update(user);
    
    return true;
  }
}

class UserImageException extends IOException {
  final String message;
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

Future<Image> defaultUserImageGenerator(UserInfo userInfo) async {
  var imageSize = AuthConfig.current.userImageSize;
  var image = Image(256, 256);

  var font = roboto_138;

  // Get first letter of the user name (or * if not found in bitmap font).
  var name = userInfo.userName;
  var charCode = (name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '*').codeUnits[0];
  if (font.characters[charCode] == null)
    charCode = '*'.codeUnits[0];

  // Draw the image.
  var chWidth = font.characters[charCode]!.width;
  var chHeight = font.characters[charCode]!.height;
  var chOffsetY = font.characters[charCode]!.yoffset;
  var chOffsetX = font.characters[charCode]!.xoffset;
  var xPos = 128 - chWidth ~/ 2;
  var yPos = 128 - chHeight ~/ 2;

  // Pick color based on user id from the default colors (from material design).
  fill(image, _defaultUserImageColors[userInfo.id! % _defaultUserImageColors.length]);

  // Draw the character on top of the solid filled image.
  drawString(image, font, xPos - chOffsetX, yPos - chOffsetY, String.fromCharCode(charCode));

  // Resize image if it's not the preferred size.
  if (imageSize != 256)
    image = copyResizeCropSquare(image, imageSize);

  return image;
}