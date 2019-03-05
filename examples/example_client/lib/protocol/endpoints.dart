/*** AUTOMATICALLY GENERATED CODE DO NOT MODIFY ***/
/* To generate run: "serverpod generate"  */

import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

Future<String> setUserInfo(UserInfo userInfo,String firstName,[String lastName,int number,]) async {
  return await callServerEndpoint('setUserInfo',[userInfo,firstName,lastName,number,]);
}

Future<UserInfo> getUserInfo(int id,) async {
  return await callServerEndpoint('getUserInfo',[id,]);
}

