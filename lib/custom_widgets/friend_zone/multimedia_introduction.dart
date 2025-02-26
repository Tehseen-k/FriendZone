// ignore_for_file: must_be_immutable

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/model/profile_multimedia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMultiMediaIntrodductionWidget extends StatelessWidget {
  ProfileMultimediaModel Object_profileMultiMedia = ProfileMultimediaModel();
  CustomMultiMediaIntrodductionWidget(
      {super.key, required this.Object_profileMultiMedia});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage("${Object_profileMultiMedia.imgUrl}"),
                )),
            height: 170,
            width: 320,
          ),
          Text(
            "${Object_profileMultiMedia.title}",
            style: style14B.copyWith(color: blackColor),
          ),
        ],
      ),
    );
  }
}
