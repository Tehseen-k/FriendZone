// ignore_for_file: must_be_immutable

import 'package:code_structure/core/model/your_matches_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomYourMatchesCommentSection extends StatelessWidget {
  YourMatchesCommentModel Object_YourMatchesComment = YourMatchesCommentModel();
  CustomYourMatchesCommentSection(
      {super.key, required this.Object_YourMatchesComment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20.r,
        backgroundImage:
            AssetImage("${Object_YourMatchesComment.ProfilrImgUrl}"),
      ),
      title: Text(
        "${Object_YourMatchesComment.UserNamere}",
        style: GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 17),
      ),
      subtitle: Text(
        "${Object_YourMatchesComment.Comment} ",
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
      ),
      trailing: Text("${Object_YourMatchesComment.time}"),
    );
  }
}
