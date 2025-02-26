// ignore_for_file: must_be_immutable

import 'package:code_structure/core/model/detail_comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDetailScreenCommentSection extends StatelessWidget {
  detailCommentModel Object_DetailScreenComment = detailCommentModel();
  CustomDetailScreenCommentSection(
      {super.key, required this.Object_DetailScreenComment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20.r,
        backgroundImage:
            AssetImage("${Object_DetailScreenComment.ProfilrImgUrl}"),
      ),
      title: Text(
        "${Object_DetailScreenComment.UserNamere}",
        style: GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 17),
      ),
      subtitle: Text(
        "${Object_DetailScreenComment.Comment} ",
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
      ),
      trailing: Text("${Object_DetailScreenComment.time}"),
    );
  }
}
