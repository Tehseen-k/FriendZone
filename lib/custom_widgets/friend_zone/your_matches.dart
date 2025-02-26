import 'package:code_structure/core/model/your_matches_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomYourMatcheswidget extends StatelessWidget {
  YourMatchesModel Object_YourMatches = YourMatchesModel();
  // final String imgUrl;
  // final String tittle;
  // final String subtittle;
  CustomYourMatcheswidget({super.key, required this.Object_YourMatches

      // required this.imgUrl,
      // required this.tittle,
      // required this.subtittle
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 185.h,
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
              "${Object_YourMatches.ImgUrl}",
              fit: BoxFit.cover,
              width: double.infinity,
              // height: 130,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "${Object_YourMatches.name}",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xfff1b1e28)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "${Object_YourMatches.location}",
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
