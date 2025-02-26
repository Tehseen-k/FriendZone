import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';

final authFieldDecoration = InputDecoration(
  hintText: "Enter your email",
  hintStyle: style16.copyWith(color: blackColor.withOpacity(0.50)),
  prefixIconColor: blackColor,
  suffixIconColor: blackColor,
  fillColor: blackColor.withOpacity(0.04),
  filled: true,
  border: InputBorder.none,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: transparentColor, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: transparentColor, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: transparentColor, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
  disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: transparentColor, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
  focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: transparentColor, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
);
