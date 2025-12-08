//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:platform_channel/src/core/utils/time_utils.dart';
import 'package:platform_channel/src/features/fetch_sms_list/service/sms_service.dart';
import 'package:platform_channel/src/model/sms_model.dart';

//isolate friendly parse method //Top-level isolate function
List<SmsModel> parseSmsList(List<dynamic> rawList){
  return rawList.map((e) => SmsModel.fromJson(Map<String,dynamic>.from(e))).toList();
}

class SmsListScreen extends StatefulWidget{
  const SmsListScreen({super.key});

  @override
  State<SmsListScreen> createState() => _SmsListScreenState();
}

class _SmsListScreenState extends State<SmsListScreen> {

  //List<SmsModel> smsList = [];
  double totalCashIn = 0.0;

  @override
  void initState(){
    super.initState();
    //checkPermission();
    //loadSms();
    loadTotalCashIn();
  }

 /* void checkPermission() async{
    bool allowed = await SmsService.requestPermission();
    print("SMS Permision: $allowed");
  }
  */

  /*void loadSms() async{
    final raw = await SmsService.getBkashSms(); //only maps
    final data = await compute(parseSmsList, raw);
    setState(() {
      smsList = data;
    });
  }*/
  void loadTotalCashIn() async {
    bool allowed = await SmsService.requestPermission();

    if (allowed) {
      final total = await SmsService.getTotalCashIn();
      setState(() {
        totalCashIn = total;
      });
    } else {
      print("Permission Denied!");
      setState(() {
        totalCashIn = 0.0;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
       elevation: 0,
       backgroundColor: Colors.grey.shade300,
       title: Text('Bkash Details',style: GoogleFonts.roboto(
         fontSize: 20,
         color: Colors.black,
         fontWeight: FontWeight.w800
       ),),
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
         SizedBox(width: 15,),

       ],
     ),
      body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: Colors.grey.shade300
                    ),
                    gradient: LinearGradient(colors: [
                      Colors.grey,
                      Colors.purple.shade300
                    ]),
                    borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.rectangle
                  ),
                  width: double.maxFinite,
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Total Cash In",style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                      ),),
                      SizedBox(height: 8,),
                      Text("Tk ${totalCashIn.toStringAsFixed(2)}",
                        style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.black
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
        ),
      /*smsList.isEmpty ? Center(child: CircularProgressIndicator(),) :
      ListView.builder(
          itemCount: smsList.length,
          itemBuilder: (_,index){
            final sms = smsList[index];
        return Column(
          children: [
            ListTile(
              /*leading: CircleAvatar(
                backgroundColor: Colors.blue.shade200,
                child: Icon(Icons.person_2_rounded,color: Colors.blue,),
              ),

               */
              title: Text(sms.address,style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.black,
              )),
              subtitle: Text(sms.body,
                maxLines: 2,
                style: TextStyle(
                fontSize: 13,
                color: Colors.grey.withOpacity(0.9),
                overflow: TextOverflow.ellipsis,
              ),),
              trailing: Text(TimeUtils.getTimeAgo(sms.date),style: GoogleFonts.roboto(
                fontSize: 15,
                color: Colors.black54
              ),),
            )
          ],
        );
      }),
       */
    );
  }
}