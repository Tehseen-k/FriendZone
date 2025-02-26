import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomBottomNavigatorBar extends StatelessWidget {
  String? image;
  VoidCallback? onTap;
  Color? iconColor;
  String? name;
  Color? textColor;
  CustomBottomNavigatorBar(
      {super.key,
      required this.image,
      required this.onTap,
      required this.name,
      required this.textColor,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            image!,
            color: iconColor,
            scale: 4,
          ),
          Text(
            '$name',
            style: style14B.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
