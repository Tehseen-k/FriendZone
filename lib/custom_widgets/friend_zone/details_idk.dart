import 'package:code_structure/core/model/detail_idk.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDetailIdkWidget extends StatelessWidget {
  DetailsIdkModel Object_DetailIdk = DetailsIdkModel();
  CustomDetailIdkWidget({super.key, required this.Object_DetailIdk});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
              image: AssetImage("${Object_DetailIdk.imgUrl}"),
              fit: BoxFit.cover)),
    );
  }
}
