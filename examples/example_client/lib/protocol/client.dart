/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'dart:io';
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class Client extends ServerpodClient {
  Client(host, {SecurityContext context}) : super(host, Protocol.instance, context: context);

  Future<String> setUserInfo(UserInfo userInfo,String firstName,[String lastName,int number,]) async {
    return await callServerEndpoint('setUserInfo', 'String', {
      'userInfo':userInfo,
      'firstName':firstName,
      'lastName': lastName,
      'number': number,
    });
  }

  Future<CompanyInfo> getUserInfo(int id,String name,) async {
    return await callServerEndpoint('getUserInfo', 'CompanyInfo', {
      'id':id,
      'name':name,
    });
  }
}