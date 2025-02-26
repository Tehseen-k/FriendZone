import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSocialIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  final String imagePath;
  final Color color;
  final textcolor;
  String? name;

  CustomSocialIconButton(
      {super.key,
      required this.onPressed,
      this.size = 52.0,
      required this.imagePath,
      required this.textcolor,
      required this.name,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color, // Background color of the container
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(
              color: blackColor.withOpacity(0.40),
              offset: Offset(0, 2),
              blurRadius: 7.r,
              spreadRadius: 0)
        ],
        border: Border.all(
            color: Color(0xfff000000 % 12), width: 2), // Border color
      ),
      child: TextButton(
          onPressed: onPressed, // Call the provided callback on press
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero, // Remove padding for a compact button
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath, scale: 3, // Path to your image asset
              ),
              SizedBox(
                width: 15.w,
              ),
              Text(
                "$name",
                style: style16B.copyWith(fontSize: 17, color: textcolor),
              )
            ],
          )),
    );
  }
}
