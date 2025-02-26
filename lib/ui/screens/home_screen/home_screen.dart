// ignore_for_file: deprecated_member_use

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/custom_upcoming_events.dart';
import 'package:code_structure/custom_widgets/friend_zone/compatibility_score.dart';
import 'package:code_structure/custom_widgets/friend_zone/nearby_matches.dart';
import 'package:code_structure/custom_widgets/friend_zone/schedual_meetups.dart';
import 'package:code_structure/ui/screens/compatibility_screen/compatibility_score_view.dart';
import 'package:code_structure/ui/screens/home_screen/home_veiw_model.dart';
import 'package:code_structure/ui/screens/nearby_matches/nearby_view.dart';
import 'package:code_structure/ui/screens/shedule_events/shedule_events_screen.dart';
import 'package:code_structure/ui/screens/shedule_meetups/shedule_screen.dart';
import 'package:code_structure/ui/screens/up_coming/up_coming_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSelectedSchedaul = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (context) => HomeScreenVeiwModel(),
      child: Consumer<HomeScreenVeiwModel>(
        builder: (context, model, child) => ModalProgressHUD(
          inAsyncCall: model.isLoading,
          progressIndicator: CircularProgressIndicator(
            color: Colors.orange,
          ),
          child: Scaffold(
            ///
            /// App Bar
            ///
            appBar: _appBar(),

            backgroundColor: Colors.white,

            ///
            /// Start Body
            ///
            body: SingleChildScrollView(
              child: Column(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Your Dashboard",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Compatibility Scores",
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: Colors.black),
                    ),
                  ),

                  ///
                  ///    Compability Score
                  ///

                  _compabilityScore(model),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nearby Matches",
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NearbyScreen()));
                            },
                            child: Text(
                              "See All",
                              style: TextStyle(
                                  color: Color(0xfff123cc9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ))
                      ],
                    ),
                  ),
                  _nearByMatches(model, screenWidth),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Upcoming Activities",
                          style: style16B.copyWith(color: blackColor),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpComingScreen()));
                            },
                            child: Text(
                              "See All",
                              style: TextStyle(
                                  color: Color(0xfff123cc9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ))
                      ],
                    ),
                  ),

                  ///
                  /// Upcoming Activities
                  ///
                  _upComingEvents(model, screenheight),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Schedual Meetups",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SheduleScreen()));
                            },
                            child: Text(
                              "See All",
                              style: TextStyle(
                                  color: Color(0xfff123cc9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ))
                      ],
                    ),
                  ),

                  ///
                  /// Schedule Meeting
                  ///
                  _sheduleMeeting(model, screenheight),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ScheduleEventsScreen()));
                          },
                          child: Container(
                            width: 200,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                color: _isSelectedSchedaul
                                    ? buttonColor
                                    : Color(0x00000fff),
                                borderRadius: BorderRadius.circular(40)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Schedual Events",
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
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 170,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(40)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                Text(
                                  "New Group",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 15,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: screenheight * 0.07,
                              width: double.infinity,
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
                                  "Interact ith AI Assitant",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

_appBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: whiteColor,
    title: Text(
      "Friend Zone",
      style: style24B.copyWith(color: blackColor),
    ),
    actions: [
      CircleAvatar(
        radius: 20,
        backgroundColor: blueColor,
        child: IconButton(
          icon: Icon(Icons.notifications, color: Colors.white),
          onPressed: () {},
        ),
      ),
      10.horizontalSpace,
      CircleAvatar(
        radius: 20,
        backgroundColor: blueColor,
        child: IconButton(
          icon: Icon(Icons.person, color: Colors.white),
          onPressed: () {
            // Navigate to nearby matches
          },
        ),
      ),
      20.horizontalSpace,
    ],
  );
}

_compabilityScore(HomeScreenVeiwModel model) {
  return model.matchedUsers.isNotEmpty
      ? SizedBox(
          height: 185,
          width: double.infinity,
          child: ListView.builder(
            itemCount: model.matchedUsers.length ,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompatibiltyScore(matchedUser: model.matchedUsers[index]!,)));
                  },
                  child: CustomCompatibilityScorewidget(
                      matchedUser:
                          model.matchedUsers[index]!));
            },
          ),
        )
      : Container(
          height: 185,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 50,
                color: Colors.grey[400],
              ),
              SizedBox(height: 10),
              Text(
                "No Matches Found Yet",
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Keep exploring to find your perfect match!",
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
}

_nearByMatches(HomeScreenVeiwModel model, double screenWidth) {
  return model.nearbyUsers.isNotEmpty
      ? SizedBox(
          height: 290,
          width: screenWidth * 0.9,
          child: ListView.builder(
            itemCount: model.listNearbyMatches.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NearbyScreen()));
                },
                child: CustomNearbyMatchesWidget(
                    Object_nearbyMatches: model.listNearbyMatches[index]),
              );
            },
          ),
        )
      : Container(
          height: 290,
          width: screenWidth * 0.9,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_outlined,
                size: 50,
                color: Colors.grey[400],
              ),
              SizedBox(height: 10),
              Text(
                "No Nearby Matches",
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Expand your search radius to find more people!",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
}
_upComingEvents(HomeScreenVeiwModel model, double screenheight) {
  return model.upComingActivites.isNotEmpty
      ? SizedBox(
          height: screenheight * 0.31,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.upComingActivites.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpComingScreen()));
                },
                child: CustomUpcomingEvents(
                    upComingActivities: model.upComingActivites[index]),
              );
            },
          ),
        )
      : Text(
          "list upcoming activities is epmty",
          style: GoogleFonts.nunito(
              fontWeight: FontWeight.w800, fontSize: 17, color: Colors.black),
        );
}

_sheduleMeeting(HomeScreenVeiwModel model, double screenheight) {
  return model.listSchedualMeetups.isNotEmpty
      ? SizedBox(
          height: screenheight * 0.31,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.listSchedualMeetups.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SheduleScreen()));
                },
                child: CustomScheduleMeetUpsWidget(
                    Object_scgedualMeetUps: model.listSchedualMeetups[index]),
              );
            },
          ),
        )
      : Text(
          "list is epmty",
          style: GoogleFonts.nunito(
              fontWeight: FontWeight.w500, fontSize: 17, color: Colors.black),
        );
}
