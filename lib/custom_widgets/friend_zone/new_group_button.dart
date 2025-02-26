import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNewGroupButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  //final int icon;

  const CustomNewGroupButton({
    super.key,
    //required this.icon,
    required this.onPressed,
    this.text = "", //change it according to your use
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 327.w,
      height: 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(11), //  rounded corners of container
          ),
          // iconColor: Color(0xffFDD854), // Button color
        ),
        child: Row(
          children: [
            //Icon(ico),
            Icon(Icons.add),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14.sp, // Set the font size
                fontWeight: FontWeight.w500,
                color: Colors.white, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
