import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/custom_widgets/friend_zone/home_groups.dart';
import 'package:code_structure/custom_widgets/friend_zone/home_matches.dart';
import 'package:code_structure/custom_widgets/friend_zone/local_events.dart';
import 'package:code_structure/ui/screens/Interest_with_ai/interest_with_ai_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});

  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  bool _isSelected = false;
  bool _isSelectedSchedaul = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onClick() {
    _isSelected = !_isSelected;
    _isSelectedSchedaul = !_isSelectedSchedaul;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (context) => InteretstWithAIViewModel(),
      child: Consumer<InteretstWithAIViewModel>(
          builder: (context, model, child) => Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        const Text(
                          "Matchess",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Colors.black),
                        ),
                        10.verticalSpace,
                        SizedBox(
                          height: screenHeight * 0.22,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.listMatches.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: CustomInterestWithAIMatcheswidget(
                                      Object_InteretWithAIMatches:
                                          model.listMatches[index]),
                                ),
                              );
                            },
                          ),
                        ),
                        20.verticalSpace,
                        //////
                        //////
                        //////              Groups
                        ///
                        ///
                        Text(
                          "Groups",
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w800, fontSize: 17),
                        ),

                        10.verticalSpace,
                        //
                        // grid view builder start for groups
                        //
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 1.5),
                          itemCount: model.listHomeGroups.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: CustomHomeGroupsWidget(
                                  Object_homeGroups:
                                      model.listHomeGroups[index]),
                            );
                          },
                        ),
                        const SizedBox(height: 42),
                        //
                        //
                        //              after groups local events strat
                        //
                        //
                        SizedBox(
                          height: 315.h,
                          child: ListView.builder(
                            itemCount: model.listHomeLocaLEVents.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: CustomLocalEventsWidget(
                                      Object_LocalEventModel:
                                          model.listHomeLocaLEVents[index]),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        ///
                        ///
                        ///       comment section here
                        ///
                        ///
                        const Text("add comment section here "),
                        const SizedBox(
                          height: 15,
                        ),
                        ////
                        ///
                        ///
                        ///             Explore more Button
                        ///
                        ///
                        GestureDetector(
                          onTap: () {
                            onClick();
                          },
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 60.h,
                                  width: screenWidth * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: borderColor.withOpacity(0.20)),
                                      color: _isSelectedSchedaul
                                          ? transparentColor
                                          : Color(0x00000fff),
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Center(
                                    child: Text(
                                      "Explore More",
                                      style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 17),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        ///
                        //////
                        ///           refreash button
                        ///
                        ///
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 60.h,
                              width: 130.w,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  // color: _isSelectedSchedaul
                                  //     ? buttonColor
                                  //     : Color(0xfff),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 15.w),
                                  Text(
                                    "Refreash",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        60.verticalSpace
                      ],
                    ),
                  ),
                ),

                ///
              )),
    );
  }
}
