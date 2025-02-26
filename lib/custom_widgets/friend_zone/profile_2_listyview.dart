import 'package:code_structure/core/model/profile_2_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomSecondListWidget extends StatelessWidget {
  Profile2ListModel Object_Profile_2_list = Profile2ListModel();
  CustomSecondListWidget({super.key, required this.Object_Profile_2_list});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Container(
      height: screenheight * 0.3,
      width: screenWidth * 0.4,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0.0, 2),
            blurRadius: 6.r,
            spreadRadius: 0)
      ], color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 150.h,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("${Object_Profile_2_list.imgUrl}"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18.r),
                    topLeft: Radius.circular(18.r))),
          ),
          SizedBox(
            height: 11,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              "${Object_Profile_2_list.tiitle}",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xfff1b1e28)),
            ),
          ),
        ],
      ),
    );
  }
}
