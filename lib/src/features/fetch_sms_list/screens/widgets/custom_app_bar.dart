import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
     return AppBar(
       elevation: 0,
       backgroundColor: Colors.grey.shade300,
       title: Text(title,style: GoogleFonts.roboto(
           fontSize: 20,
           color: Colors.black,
           fontWeight: FontWeight.w800
       ),),
       actions: actions,
     );
  }

  @override
  // appbar requires this
  Size get preferredSize =>  Size.fromHeight(kToolbarHeight);

}