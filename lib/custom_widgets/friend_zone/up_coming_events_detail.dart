import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/strings.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/model/Upcoming_events_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomUpComingEventsWidget extends StatelessWidget {
  UpcomingEventsDetailModel Object_UpComingEvents = UpcomingEventsDetailModel();
  CustomUpComingEventsWidget({super.key, required this.Object_UpComingEvents});

  @override
  Widget build(BuildContext context) {
    double screenHeights = MediaQuery.of(context).size.height;
    double ScreenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      width: ScreenWidth * 0.8,
      decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0.0, 2),
                blurRadius: 6.r,
                spreadRadius: 0.0)
          ],
          borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 186,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              image: DecorationImage(
                image: AssetImage("${Object_UpComingEvents.imgUrl}"),
                fit: BoxFit.cover,
              )),
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
                "${Object_UpComingEvents.GroupName}",
                style: style16B.copyWith(color: blackColor),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Image.asset(
                    "$iconsAssets/calender.png",
                    scale: 3,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${Object_UpComingEvents.day}",
                    style: style16N.copyWith(color: greyColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    "$iconsAssets/profile.png",
                    scale: 5,
                    color: greyColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${Object_UpComingEvents.time}",
                    style: style16N.copyWith(color: greyColor),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "${Object_UpComingEvents.message}",
                style: style16N.copyWith(color: greyColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ],
          ),
        )
      ]),
    );
  }
}
