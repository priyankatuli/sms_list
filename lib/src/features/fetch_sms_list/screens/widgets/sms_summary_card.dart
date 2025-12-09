import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmsSummaryCard extends StatelessWidget{
  const SmsSummaryCard({super.key, required this.title, required this.amount});

  final String title;
  final double amount;

  @override
  Widget build(BuildContext context) {
      return Container(
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
            Text(title,style: GoogleFonts.roboto(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ),),
            SizedBox(height: 8,),
            Text("Tk ${amount.toStringAsFixed(2)}",
              style: GoogleFonts.roboto(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.black
              ),
            )
          ],
        ),
      );
  }

}