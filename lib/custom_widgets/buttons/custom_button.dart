// ignore_for_file: must_be_immutable, library_private_types_in_public_api, use_super_parameters

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatefulWidget {
  String? name;
  VoidCallback? onPressed;
  Color? textColor;
  Color? boxColor;
  Color? borderColor;

  CustomButton({
    Key? key,
    required this.name,
    this.borderColor,
    this.boxColor,
    required this.onPressed,
    this.textColor,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed?.call();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              height: 56.h,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 0.5,
                      color: widget.borderColor ?? transparentColor),
                  color: widget.boxColor ?? buttonColor,
                  borderRadius: BorderRadius.circular(96.r)),
              child: Text(
                "${widget.name}",
                style: style16B.copyWith(color: widget.textColor ?? blackColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
