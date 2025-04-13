// ignore_for_file: body_might_complete_normally_nullable

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/ui/screens/shedule_meetups/shedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SheduleViewModel(),
      child: Consumer<SheduleViewModel>(
        builder: (context, model, child) => Scaffold(
          ///
          /// App Bar
          ///
          appBar: _appBar(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 185,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: model.listcompatibilityscore.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    // return GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => CompatibiltyScore()));
                    //     },
                    //     child: CustomCompatibilityScorewidget(
                    //         object_CompitableScore:
                    //             model.listcompatibilityscore[index]));
                  },
                ),
              ),
              20.verticalSpace,

              // ///
              // /// Weekly Trends
              // ///
              // Padding(
              //   padding: const EdgeInsets.only(left: 16.0),
              //   child: Text(
              //     "Weekly Trends",
              //     style: style16B.copyWith(color: blackColor),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 16.0, top: 20),
              //   child: Text(
              //     "Bar Chart",
              //     style: style16B.copyWith(color: blackColor, fontSize: 13),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 16.0),
              //   child: Text(
              //     "Daily Messages",
              //     style: style16N.copyWith(color: greyColor, fontSize: 10),
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.only(left: 16.0, top: 20),
              //   child: Text(
              //     "Pie Chart",
              //     style: style16B.copyWith(color: blackColor, fontSize: 13),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 16.0),
              //   child: Text(
              //     "Group Activity Types",
              //     style: style16N.copyWith(color: greyColor, fontSize: 10),
              //   ),
              // ),
              SizedBox(
                height: 60,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: GestureDetector(
                    onTap: () {
                      () {
                        // onClick();
                      };
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: borderColor.withOpacity(0.20)),
                          color: Color(0x00000fff),
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                        child: Text(
                          "Explore Group",
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_appBar(BuildContext context) {
  return AppBar(
    backgroundColor: whiteColor,
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: blackColor,
        )),
    title: Text(
      "Weekly Schedule Meetup",
      style: style24B.copyWith(color: blackColor),
    ),
  );
}
