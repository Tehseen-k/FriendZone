import 'package:code_structure/core/constants/auth_text_feild.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFeild extends StatelessWidget {
  final String? hinttext;
  CustomTextFeild({super.key, required this.hinttext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: authFieldDecoration.copyWith(
            hintText: hinttext,
            hintStyle: TextStyle(color: Colors.grey[600]),
            fillColor: Colors.grey[200],
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: transparentColor)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: transparentColor))),
      ),
    );
  }
}
