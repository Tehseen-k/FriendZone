// ignore_for_file: unused_local_variable

import 'package:code_structure/core/model/schedual_meetups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomScheduleMeetUpsWidget extends StatelessWidget {
  SchedualMeetupsModel Object_scgedualMeetUps = SchedualMeetupsModel();
  CustomScheduleMeetUpsWidget(
      {super.key, required this.Object_scgedualMeetUps});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(left: 8.0, bottom: 8),
      // height: screenheight * 0.3,
      width: screenWidth * 0.44,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0.0, 2),
                blurRadius: 7.r,
                spreadRadius: 0)
          ],
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                  image: AssetImage("${Object_scgedualMeetUps.imgUrl}"),
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            height: 11,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              "${Object_scgedualMeetUps.title}",
              style:
                  GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              "${Object_scgedualMeetUps.dateAndTime}",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xfff141a2e)),
            ),
          ),
        ],
      ),
    );
  }
}
