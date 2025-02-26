// ignore_for_file: deprecated_member_use

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/model/nearby_matches_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomNearbyMatchesWidget extends StatelessWidget {
  NearbyMatchesModel Object_nearbyMatches = NearbyMatchesModel();
  CustomNearbyMatchesWidget({super.key, required this.Object_nearbyMatches});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, bottom: 8),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
              color: blackColor.withOpacity(0.08),
              offset: const Offset(0.0, 2),
              blurRadius: 7.r,
              spreadRadius: 0)
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(18.r), topLeft: Radius.circular(18.r)),
          child: Image.asset(
            "${Object_nearbyMatches.imgUrl}",
            height: 150,
            // width: double.infinity,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${Object_nearbyMatches.groupName}",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800, fontSize: 17),
              ),
              SizedBox(
                height: 8,
              ),
              Text("${Object_nearbyMatches.time}"),
              Text("${Object_nearbyMatches.day}"),
              SizedBox(
                height: 8,
              ),
              Text("${Object_nearbyMatches.message}")
            ],
          ),
        )
      ]),
    );
  }
}
