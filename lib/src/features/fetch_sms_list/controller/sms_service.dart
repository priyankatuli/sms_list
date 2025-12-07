import 'package:flutter/services.dart';
import 'package:platform_channel/src/model/sms_model.dart';

// a part of method channel in flutter

class SmsService {

  static const platform = MethodChannel("sms_channel"); //flutter side e method channel create kora
  static const platform1 = MethodChannel("sms_permission_channel");

  static Future<List<SmsModel>> getSmsList() async{

      final List<dynamic> result = await platform.invokeMethod("getSmsList"); //flutter side theke native ke call korbe
      return
        result.map((e) => SmsModel.fromJson(Map<String,dynamic>.from(e))).toList();
  }

  static Future<bool> requestPermission() async{
     return await platform1.invokeMethod("requestSmsPermission"); // flutter theke native e permission request pathai
  }
}