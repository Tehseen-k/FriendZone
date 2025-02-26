import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/constants/colors.dart';

import 'package:code_structure/core/model/local_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomLocalEventsWidget extends StatelessWidget {
  HomeLocalEventsModel Object_LocalEventModel = HomeLocalEventsModel();
  CustomLocalEventsWidget({super.key, required this.Object_LocalEventModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
          color: transparentColor,
          border: Border.all(color: borderColor.withOpacity(0.20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("${Object_LocalEventModel.mainImgUrl}"),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 15.r,
                  backgroundImage:
                      AssetImage("${Object_LocalEventModel.profileImgUrl}"),
                ),
                title: Text(
                  "${Object_LocalEventModel.title}",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.sp,
                      color: Color(0xfff000000)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${Object_LocalEventModel.day}"),
                    SizedBox(
                      height: 10.h,
                      width: 5.w,
                    ),
                    Text("${Object_LocalEventModel.time}")
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("${Object_LocalEventModel.className}"),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text("${Object_LocalEventModel.discription}"),
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        AppAssets.chat2,
                        scale: 4,
                      )),
                  SizedBox(
                    width: 150.w,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        AppAssets.saveIcon,
                        scale: 4,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        AppAssets.more,
                        scale: 4,
                      ))
                ],
              )
            ],
          )
          //ListTile(
          // leading: Row(
          //   mainAxisSize: MainAxisSize
          //       .min, // Minimize space taken by Row
          //   children: [
          //     CircleAvatar(
          //       radius: 15,
          //       backgroundImage:
          //           AssetImage(AppAssets().FacebookIcon),
          //     ),
          //     SizedBox(
          //         width:
          //             8), // Space between CircleAvatar and Text
          //     Text("Local Events"),
          //     SizedBox(
          //       width: 20.w,
          //     ),
          //     SizedBox(
          //       width: 20.w,
          //     ),
          //     Text("Sunday"), Text("3 PM")
          //   ],
          // ),

          //),
        ],
      ),
    );
  }
}
