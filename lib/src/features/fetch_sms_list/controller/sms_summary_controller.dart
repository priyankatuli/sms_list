import 'package:get/get.dart';
import 'package:platform_channel/src/core/enum/provider_type.dart';
import 'package:platform_channel/src/features/fetch_sms_list/service/sms_service.dart';

class SmsSummaryController extends GetxController{

  //reactive variable
    RxDouble totalCashIn = 0.0.obs;
    RxDouble totalCashOut = 0.0.obs;
    List<dynamic> allSmsList = []; //kotlin theke fetch kora sms list eikhane rakhbe
    Rx<ProviderType> currentProvider = ProviderType.bKash.obs;

    final cashInRegex = RegExp(r'(cash in|received|credited)\D*(?:Tk\s*|Taka\s*)?([\d,]+(\.\d+)?)',
      caseSensitive: false,
    );
    final cashOutRegex = RegExp(r'(cash out|sent|debited)\D*(?:Tk\s*|Taka\s*)?([\d,]+(\.\d+)?)',
      caseSensitive: false,
    );

    @override
    void onInit(){
    super.onInit();
    loadSms();
  }

  void loadSms() async{
     bool allowed = await SmsService.requestPermission();
     if(allowed){
       allSmsList = await SmsService.getAllSms();
       print("Total Sms Fetched: ${allSmsList.length}");
     }

     filterByProvider(currentProvider.value);
  }

  void filterByProvider(ProviderType providerType) {
      //reset kora totals
    totalCashIn.value = 0;
    totalCashOut.value = 0;

    final firstDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

    for (var sms in allSmsList) {
      String body = sms["body"] ?? "";
      String address = sms["address"] ?? "";

      //print("Checking SMS: address=$address, body=$body");

      String rawTimeStamp = sms["date"] ?? "0"; //kotlin theke j date ta j ashtase jeta string
      int timeStamp = int.tryParse(rawTimeStamp) ?? 0;
      DateTime smsDate = DateTime.fromMillisecondsSinceEpoch(timeStamp);

      //current month filter
      if (smsDate.isBefore(firstDayOfMonth)) continue; //sms masher baire hoy porer sms e jao

      bool matchProvider = false;

      switch (providerType) {
        case ProviderType.bKash:
          matchProvider = body.contains("bKash") ||
              address.contains("bKash");
          break;
        case ProviderType.nagad:
          matchProvider = body.contains("NAGAD") ||
              address.contains("NAGAD");
          break;
        case ProviderType.rocket:
          matchProvider = body.contains("rocket") ||
              address.contains("rocket");
          break;
        case ProviderType.krishibank:
          matchProvider = body.contains("KRISHI BANK") ||
              address.contains("KRISHI BANK");
          break;
        case ProviderType.upay:
          matchProvider = body.contains("upay") ||
              address.contains("upay");
          break;
      }

      if (!matchProvider) continue;

      _extractAmounts(body);
    }
  }
      void _extractAmounts(String body){

        for(var match in cashInRegex.allMatches(body)){
           double amount = double.tryParse(match.group(2)?.replaceAll(",","") ?? "0") ?? 0;
           print("Cash in match: ${match.group(0)}, amount: ${match.group(2)}");
           totalCashIn.value += amount;
          }

        for(var match in cashOutRegex.allMatches(body)){
          double amount  = double.tryParse(match.group(2)?.replaceAll(",", "") ?? "0") ?? 0;
          print("Cash out match: ${match.group(0)}, amount: ${match.group(2)}");
          totalCashOut.value += amount;
        }

    }
      }


