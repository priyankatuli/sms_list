import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:platform_channel/src/features/fetch_sms_list/screens/sms_list_screen.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return GetMaterialApp(
        title: 'Platform channel with fetch sms list',
        debugShowCheckedModeBanner: false,
        home: SmsListScreen(),
      );
  }

}