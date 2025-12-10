import 'package:flutter/services.dart';

// a part of method channel in flutter

class SmsService {

  static const platform = MethodChannel("sms_channel"); //flutter side e method channel create kora
  static const platform1 = MethodChannel("sms_permission_channel");

  //isolate shudhu simple list ba map nite parbe
  /*static Future<List<dynamic>> getSmsListRaw() async{

      final List<dynamic> result = await platform.invokeMethod("getSmsList"); //flutter side theke native ke call korbe
      return result;
       // result.map((e) => SmsModel.fromJson(Map<String,dynamic>.from(e))).toList(); //eita main thread e run hoy
  }

  //bKash SMS
  static Future <List<dynamic>> getBkashSms() async{
    return await platform.invokeMethod("getBkashSmsList");

  }*/
 /*static Future<Map<String,dynamic>> getCashSummary() async{
   final result = await platform.invokeMethod("getCashSummary");
   return Map<String,dynamic>.from(result);
 } */
  static Future<List<dynamic>> getAllSms() async{
    return await platform.invokeMethod("getAllSms");
  }

  //Request Permission
  static Future<bool> requestPermission() async{
    return await platform1.invokeMethod("requestSmsPermission"); // flutter theke native e permission request pathai
  }

}