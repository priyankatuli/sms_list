
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:platform_channel/src/core/constants/app_strings.dart';
import 'package:platform_channel/src/features/fetch_sms_list/controller/sms_summary_controller.dart';
import 'package:platform_channel/src/features/fetch_sms_list/screens/widgets/custom_app_bar.dart';
import 'package:platform_channel/src/features/fetch_sms_list/screens/widgets/sms_summary_card.dart';

//isolate friendly parse method //Top-level isolate function
/*List<SmsModel> parseSmsList(List<dynamic> rawList){
  return rawList.map((e) => SmsModel.fromJson(Map<String,dynamic>.from(e))).toList();
}
 */

class SmsListScreen extends StatelessWidget{

  final SmsSummaryController controller = Get.put(SmsSummaryController());

  SmsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: CustomAppBar(
       title: AppStrings.bkashTitle,
       actions: [
         Icon(Icons.search_rounded,color: Colors.black,),
         SizedBox(width: 15,),
         CircleAvatar(
             backgroundColor: Colors.grey.shade400,
             child: Text("T",style: GoogleFonts.roboto(
                 fontSize: 17,
                 color: Colors.black54,
                 fontWeight: FontWeight.w500
             ),)
         ),
         SizedBox(width: 10,)
       ],
     ),
      body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  print("CashIn updated: ${controller.totalCashIn.value}");
                  return SmsSummaryCard(
                         title: AppStrings.cashInTitle,
                         amount: controller.totalCashIn.value,);
      }),
                SizedBox(height: 10,),
                Obx((){
                          print("CashOut updated: ${controller.totalCashOut.value}");
                          return SmsSummaryCard(
                              title: AppStrings.cashOuTitle,
                              amount: controller.totalCashOut.value
                          );
                        }
                ),

      ])
    ));
  }
}
