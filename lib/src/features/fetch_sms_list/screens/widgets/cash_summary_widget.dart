import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:platform_channel/src/core/constants/app_strings.dart';

class CashSummaryWidget extends StatelessWidget {
  const CashSummaryWidget({super.key, required this.cashIn, required this.cashOut});

  final RxDouble cashIn;
  final RxDouble cashOut;

  @override
  Widget build(BuildContext context) {
      return Obx(() => Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14,vertical: 10),
          child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.cashInTitle,style: GoogleFonts.roboto(
                      fontSize: 15,
                    ),),
                    SizedBox(width: 10,),
                    Text("Tk ${cashIn.value.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.bold),)
                  ],),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.cashOuTitle,style: GoogleFonts.roboto(
                      fontSize: 15,
                    ),),
                    SizedBox(width: 10,),
                    Text("Tk ${cashOut.value.toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),)
                  ],),]
          ),
        ),
      ));
  }

}