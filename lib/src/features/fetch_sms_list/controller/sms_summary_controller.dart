import 'package:get/get.dart';
import 'package:platform_channel/src/core/enum/provider_type.dart';
import 'package:platform_channel/src/features/fetch_sms_list/service/sms_service.dart';

class SmsSummaryController extends GetxController{

  //reactive variable
    RxDouble totalCashIn = 0.0.obs;
    RxDouble totalCashOut = 0.0.obs;
    RxDouble currentBalance = 0.0.obs;
    Rx<ProviderType> currentProvider = ProviderType.bKash.obs;
    List<dynamic> allSmsList = []; //kotlin theke fetch kora sms list eikhane rakhbe
    DateTime ? latestBalanceDate;

    //regular expression
    final cashInRegex = RegExp(r'(cash in|received|credited)\D*(?:Tk\s*|Taka\s*)?([\d,]+(\.\d+)?)',
      caseSensitive: false,);

    final cashOutRegex = RegExp(r'(cash out|sent|debited)\D*(?:Tk\s*|Taka\s*)?([\d,]+(\.\d+)?)',
      caseSensitive: false,);

    final balanceRegex = RegExp(r'(available balance|balance|current balance|a\/c balance|total balance|Bal.)\D*(?:Tk\s*|Taka\s*)?([\d,]+(\.\d+)?)',
      caseSensitive: false,);


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
       //decending order e sort korbo karon oldest to newest value show kore
       allSmsList.sort((a,b){
         int timeA = int.tryParse(a["date"] ?? "0") ?? 0;
         int timeB = int.tryParse(b["date"] ?? "0") ?? 0;
         return timeB.compareTo(timeA); //decending order//newest first
       });
     }
     filterByProvider(currentProvider.value);
  }

  void filterByProvider(ProviderType providerType) {
      //reset value
    totalCashIn.value = 0.0;
    totalCashOut.value = 0.0;
    currentBalance.value = 0.0;
    latestBalanceDate = null;

    final firstDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1); //2025,12,1 tarikh 00:00:00 time

    //double ? latestBalance; //for temporary holding last balance

    for (var sms in allSmsList) {
      String body = sms["body"] ?? "";
      String address = sms["address"] ?? "";
      //print("Checking SMS: address=$address, body=$body");

      String rawTimeStamp = sms["date"] ?? "0"; //kotlin theke j date ta j ashtase jeta string
      int timeStamp = int.tryParse(rawTimeStamp) ?? 0;
      DateTime smsDate = DateTime.fromMillisecondsSinceEpoch(timeStamp); //particular sms er date & time

      //current month filter
      if (smsDate.isBefore(firstDayOfMonth)) continue; //sms er date ki ei masher 1 tarikher age

      bool matchProvider = false;
      switch (providerType) {
        case ProviderType.bKash:
          matchProvider = body.contains("bKash") || address.contains("bKash");
          break;
        case ProviderType.nagad:
          matchProvider = body.contains("NAGAD") || address.contains("NAGAD");
          break;
        case ProviderType.rocket:
          matchProvider = body.contains("rocket") || address.contains("rocket");
          break;
        case ProviderType.krishibank:
          matchProvider = body.contains("KRISHI BANK") || address.contains("KRISHI BANK");
          break;
        case ProviderType.upay:
          matchProvider = body.contains("upay") || address.contains("upay");
          break;
        case ProviderType.primebank:
          matchProvider = body.contains("PRIME BANK") || address.contains("PRIME BANK");
          break;
        case ProviderType.onebank:
          matchProvider = body.contains("ONE BANK") || address.contains("ONE BANK");
          break;
        case ProviderType.bracbank:
          matchProvider =  body.contains("BRAC BANK") || address.contains("BRAC BANK");
      }

      if (!matchProvider) continue; //skip korbe jodi ei masher age hoy fole ei masher sms gulo _extractAmounts e jabe

      _extractAmounts(body,smsDate);
    }
  }
      void _extractAmounts(String body,DateTime smsDate){

        for(RegExpMatch match in cashInRegex.allMatches(body)){
           double amount = double.tryParse(match.group(2)?.replaceAll(",","") ?? "0") ?? 0.0;
           print("Cash in match: ${match.group(0)}, amount: ${match.group(2)}");
           totalCashIn.value += amount;
          }

        for(RegExpMatch match in cashOutRegex.allMatches(body)){
          double amount  = double.tryParse(match.group(2)?.replaceAll(",", "") ?? "0") ?? 0.0;
          print("Cash out match: ${match.group(0)}, amount: ${match.group(2)}");
          totalCashOut.value += amount;

        }

        for(RegExpMatch match in balanceRegex.allMatches(body)){
          double balance = double.tryParse(match.group(2)?.replaceAll(",", "") ?? "0") ?? 0.0;

          if(latestBalanceDate == null || smsDate.isAfter(latestBalanceDate!)){
            currentBalance.value = balance;
            latestBalanceDate = smsDate;
          }
          print('Balance found: $balance');
          }


    }

}


