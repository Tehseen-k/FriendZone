import 'package:code_structure/core/model/home_matches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomInterestWithAIMatcheswidget extends StatelessWidget {
  HomeMatchesModel Object_InteretWithAIMatches = HomeMatchesModel();
  // final String imgUrl;
  // final String tittle;
  // final String subtittle;
  CustomInterestWithAIMatcheswidget(
      {super.key, required this.Object_InteretWithAIMatches

      // required this.imgUrl,
      // required this.tittle,
      // required this.subtittle
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 178.h,
      width: 140.w,
      decoration: BoxDecoration(
          color: Color(0xffffcfdff),
          border: Border.all(color: Color(0xfff49526e20)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              "${Object_InteretWithAIMatches.ImgUrl}",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 130,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "${Object_InteretWithAIMatches.name}",
              style:
                  GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "${Object_InteretWithAIMatches.location}",
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xfff141a2e)),
            ),
          ),
        ],
      ),
    );
  }
}
