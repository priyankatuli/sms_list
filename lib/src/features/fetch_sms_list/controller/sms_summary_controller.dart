import 'package:get/get.dart';
import 'package:platform_channel/src/features/fetch_sms_list/service/sms_service.dart';

class SmsSummaryController extends GetxController{

    RxDouble totalCashIn = 0.0.obs;
    RxDouble totalCashOut = 0.0.obs;


  @override
  void onInit(){
    super.onInit();
  loadCashSummary();
  }

  void loadCashSummary() async{
     bool allowed = await SmsService.requestPermission();
     if(allowed){
       final summary = await SmsService.getCashSummary();
      totalCashIn.value = summary["cashIn"];
      totalCashOut.value = summary["cashOut"];
     }else{
       totalCashIn.value = 0.0;
       totalCashOut.value = 0.0;
     }
  }


}