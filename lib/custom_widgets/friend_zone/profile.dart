// ignore_for_file: must_be_immutable

import 'package:code_structure/core/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProfile extends StatelessWidget {
  ProfileModel Object_ProfileModel = ProfileModel();
  CustomProfile({super.key, required this.Object_ProfileModel});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage("${Object_ProfileModel.ProfileImgUrl}"),
        ),
        10.verticalSpace,
        Text("${Object_ProfileModel.UserName}"),
        7.verticalSpace,
        Text("${Object_ProfileModel.UserBIo}"),
        7.verticalSpace,
        Text("${Object_ProfileModel.Achivments}"),
        7.verticalSpace,
      ],
    ));
  }
}
