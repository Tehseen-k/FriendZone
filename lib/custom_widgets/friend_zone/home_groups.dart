import 'package:code_structure/core/model/home_groups.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomHomeGroupsWidget extends StatelessWidget {
  HomeGroupsModel Object_homeGroups = HomeGroupsModel();
  CustomHomeGroupsWidget({super.key, required this.Object_homeGroups});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
              image: AssetImage("${Object_homeGroups.imgUrl}"),
              fit: BoxFit.cover)),
    );
  }
}
