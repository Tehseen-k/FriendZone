// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, file_names

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/model/key_factor_CS.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomKeyFactorCompatibilityScoreWidget extends StatelessWidget {
  KeyFactorComapatibiltyScoreModel Object_KeyFactorCS =
      KeyFactorComapatibiltyScoreModel();
  CustomKeyFactorCompatibilityScoreWidget({required this.Object_KeyFactorCS});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
              image: AssetImage("${Object_KeyFactorCS.imgUrl}"),
              fit: BoxFit.cover)),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          "Shared Interests",
          style: style16B.copyWith(color: whiteColor),
        ),
      ),
    );
  }
}
