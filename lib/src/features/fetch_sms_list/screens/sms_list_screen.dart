import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:platform_channel/src/core/utils/time_utils.dart';
import 'package:platform_channel/src/features/fetch_sms_list/controller/sms_service.dart';
import 'package:platform_channel/src/model/sms_model.dart';

class SmsListScreen extends StatefulWidget{
  const SmsListScreen({super.key});

  @override
  State<SmsListScreen> createState() => _SmsListScreenState();
}

class _SmsListScreenState extends State<SmsListScreen> {

  List<SmsModel> smsList = [];

  @override
  void initState(){
    super.initState();
    checkPermission();
    loadSms();
  }

  void checkPermission() async{
    bool allowed = await SmsService.requestPermission();
    print("SMS Permision: $allowed");
  }


  void loadSms() async{
    final data = await SmsService.getSmsList();
    setState(() {
      smsList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
       elevation: 0,
       backgroundColor: Colors.grey.shade300,
       title: Text('Google Messages',style: GoogleFonts.roboto(
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
      body: smsList.isEmpty ? Center(child: CircularProgressIndicator(),) :
      ListView.builder(
          itemCount: smsList.length,
          itemBuilder: (_,index){
            final sms = smsList[index];
        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade200,
                child: Icon(Icons.person_2_rounded,color: Colors.blue,),
              ),
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
    );
  }
}