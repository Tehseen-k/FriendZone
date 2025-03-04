// ignore_for_file: deprecated_member_use

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/model/nearby_matches_model.dart';
import 'package:code_structure/models/ModelProvider.dart';
import 'package:code_structure/ui/screens/home_screen/home_veiw_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomNearbyMatchesWidget extends StatelessWidget {
  User Object_nearbyMatches ;
  CustomNearbyMatchesWidget({super.key, required this.Object_nearbyMatches});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, bottom: 8),
      width: 250,
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
         Object_nearbyMatches.profileImageKey != null
              ? FutureBuilder(
                  future: getFileUrl(Object_nearbyMatches.profileImageKey!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return GestureDetector(
                      onTap: () => showImagePreview(snapshot.data!,context),
                      child: Container(
                        //width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18)),
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18)),
                    // image: DecorationImage(
                    //     image: I("${object_CompitableScore.imgUrl}"),
                    //     fit: BoxFit.cover),
                  ),
                  child: Icon(Icons.person),
                ),
        
        // ClipRRect(
        //   borderRadius: BorderRadius.only(
        //       topRight: Radius.circular(18.r), topLeft: Radius.circular(18.r)),
        //   child: Image.asset(
        //     "${Object_nearbyMatches.imgUrl}",
        //     height: 150,
        //     // width: double.infinity,
        //   ),
        // ),
       
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${Object_nearbyMatches.username}",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800, fontSize: 17),
              ),
              SizedBox(
                height: 8,
              ),
              Text("${Object_nearbyMatches.introduction}",maxLines: 2,overflow: TextOverflow.ellipsis,),
              Text("${Object_nearbyMatches.address}",style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(
                height: 8,
              ),
             // Text("${Object_nearbyMatches.message}")
            ],
          ),
        )
      ]),
    );
  }
}
