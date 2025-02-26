// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, deprecated_member_use, unused_local_variable

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/model/up_coming_activities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomUpcomingEvents extends StatelessWidget {
  UpComingActivities upComingActivities = UpComingActivities();

  CustomUpcomingEvents({required this.upComingActivities});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
      // height: screenheight * 0.3,
      width: screenWidth * 0.44,
      decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
                color: blackColor.withOpacity(0.08),
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
                  image: AssetImage("${upComingActivities.imgUrl}"),
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            height: 11,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              "${upComingActivities.title}",
              style:
                  GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              "${upComingActivities.dateAndTime}",
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
