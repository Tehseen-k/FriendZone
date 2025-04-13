// ignore_for_file: deprecated_member_use, unused_local_variable, prefer_final_fields, unused_field

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/main.dart';
import 'package:code_structure/ui/screens/compatibility_screen/compatibility_score_view.dart';
import 'package:code_structure/ui/screens/event/event_info_screen.dart';
import 'package:code_structure/ui/screens/group/group_info_screen.dart';
import 'package:code_structure/ui/screens/home_screen/home_veiw_model.dart';
import 'package:code_structure/ui/screens/user_profile_screen/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:code_structure/ui/widgets/group_card.dart';
import 'package:code_structure/ui/widgets/event_card.dart';

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
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => model.initialize(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //      _appBar(),

                      // Matched Users Section
                      _sectionHeader(
                        "Best Matches",
                        "People who share your interests",
                        onSeeAll: () {
                          // Navigate to all matched users
                        },
                      ),
                      _buildMatchedUsers(model),

                      // Nearby Users Section
                      _sectionHeader(
                        "People Nearby",
                        "Users in your area",
                        onSeeAll: () {
                          // Navigate to all nearby users
                        },
                      ),
                      _buildNearbyUsers(model),

                      // Matched Groups Section
                      _sectionHeader(
                        "Matched Groups",
                        "Groups that match your interests",
                        onSeeAll: () {
                          // Navigate to all matched groups
                        },
                      ),
                      _buildMatchedGroups(model),

                      // Nearby Groups Section
                      _sectionHeader(
                        "Nearby Groups",
                        "Groups in your area",
                        onSeeAll: () {
                          // Navigate to all nearby groups
                        },
                      ),
                      _buildNearbyGroups(model),

                      // Upcoming Events Section
                      _sectionHeader(
                        "Upcoming Events",
                        "Events happening soon",
                        onSeeAll: () {
                          // Navigate to all events
                        },
                      ),
                      _buildUpcomingEvents(model),

                      // Nearby Events Section
                      _sectionHeader(
                        "Events Near You",
                        "Events in your area",
                        onSeeAll: () {
                          // Navigate to all nearby events
                        },
                      ),
                      _buildNearbyEvents(model),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle,
      {VoidCallback? onSeeAll}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          //    if (onSeeAll != null)
          // TextButton(
          //   onPressed: onSeeAll,
          //   child: Text(
          //     "See All",
          //     style: TextStyle(
          //       color: primaryColor,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildMatchedUsers(HomeScreenVeiwModel model) {
    if (model.isLoading) {
      return _buildLoadingList();
    }

    if (model.matchedUsers.isEmpty) {
      return _buildEmptyState(
        "No matches found",
        "Try expanding your interests and hobbies",
        Icons.people_outline,
      );
    }

    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: model.matchedUsers.length,
        itemBuilder: (context, index) {
          final user = model.matchedUsers[index]!;
          final matchScore = calculateCompatibilityScore(user);

          return Container(
            width: 150.w,
            margin: EdgeInsets.only(right: 16.w),
            child: Card(
              color: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CompatibiltyScore(matchedUser: user)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12.r),
                          ),
                          child: user.profileImageKey != null
                              ? FutureBuilder(
                                  future: getFileUrl(user.profileImageKey!),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Image.network(
                                        snapshot.data!,
                                        height: 120.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      );
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    );
                                  })
                              : Container(
                                  height: 120.h,
                                  width: double.infinity,
                                  color: primaryColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.person,
                                    size: 48.sp,
                                    color: primaryColor,
                                  ),
                                ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          margin: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '${matchScore.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (user.address != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              user.address!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyUsers(HomeScreenVeiwModel model) {
    if (model.isLoading) {
      return _buildLoadingList();
    }

    if (model.nearbyUsers.isEmpty) {
      return _buildEmptyState(
        "No users nearby",
        "Try expanding your search radius",
        Icons.location_off,
      );
    }

    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: model.nearbyUsers.length,
        itemBuilder: (context, index) {
          final user = model.nearbyUsers[index]!;
          final distance = calculateDistance(
            userModel!.latitude!,
            userModel!.longitude!,
            user.latitude!,
            user.longitude!,
          );

          return Container(
            width: 150.w,
            margin: EdgeInsets.only(right: 16.w),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: InkWell(
                onTap: () {
                  final compatibilityScore = calculateCompatibilityScore(user);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserProfileScreen(
                          matchedUser: user,
                          compatibilityScore: compatibilityScore)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12.r),
                          ),
                          child: user.profileImageKey != null
                              ? FutureBuilder(
                                  future: getFileUrl(user.profileImageKey!),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Image.network(
                                        snapshot.data!,
                                        height: 120.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      );
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    );
                                  })
                              : Container(
                                  height: 120.h,
                                  width: double.infinity,
                                  color: primaryColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.person,
                                    size: 48.sp,
                                    color: primaryColor,
                                  ),
                                ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          margin: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '${distance.toStringAsFixed(1)}km',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        children: [
                          Text(
                            user.username,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (user.address != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              user.address!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchedGroups(HomeScreenVeiwModel model) {
    if (model.isLoading) {
      return _buildLoadingList();
    }

    if (model.matchedGroups.isEmpty) {
      return _buildEmptyState(
        "No matched groups found",
        "Try updating your interests to find more groups",
        Icons.group_off,
      );
    }

    return SizedBox(
      height: 250.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: model.matchedGroups.length,
        itemBuilder: (context, index) {
          final group = model.matchedGroups[index];
          return Container(
            width: 280.w,
            height: 200.h,
            padding: EdgeInsets.only(right: 16.w),
            child: GroupCard(
              group: group,
              matchScore: model.calculateGroupMatchScore(group),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupInfoScreen(
                      group: group,
                      currentUser: userModel!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyGroups(HomeScreenVeiwModel model) {
    if (model.isLoading) {
      return _buildLoadingList();
    }

    if (model.nearbyGroups.isEmpty) {
      return _buildEmptyState(
        "No nearby groups found",
        "Try expanding your search radius",
        Icons.location_off,
      );
    }

    return SizedBox(
      height: 250.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: model.nearbyGroups.length,
        itemBuilder: (context, index) {
          final group = model.nearbyGroups[index];
          return Container(
            width: 288.w,
            height: 250.h,
            padding: EdgeInsets.only(right: 16.w),
            child: GroupCard(
              group: group,
              matchScore: model.calculateGroupMatchScore(group),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupInfoScreen(
                      group: group,
                      currentUser: userModel!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingEvents(HomeScreenVeiwModel model) {
    if (model.isLoading) {
      return _buildLoadingList();
    }

    if (model.upcomingEvents.isEmpty) {
      return _buildEmptyState(
        "No upcoming events",
        "Check back later for new events",
        Icons.event_busy,
      );
    }

    return SizedBox(
      height: 280.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: model.upcomingEvents.length,
        itemBuilder: (context, index) {
          final event = model.upcomingEvents[index];
          return Container(
            width: 280.w,
            padding: EdgeInsets.only(right: 16.w),
            child: EventCard(
              event: event,
              isUpcoming: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventInfoScreen(
                      event: event,
                      currentUser: userModel!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyEvents(HomeScreenVeiwModel model) {
    if (model.isLoading) {
      return _buildLoadingList();
    }

    if (model.nearbyEvents.isEmpty) {
      return _buildEmptyState(
        "No events nearby",
        "Try expanding your search radius",
        Icons.location_off,
      );
    }

    return SizedBox(
      height: 300.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: model.nearbyEvents.length,
        itemBuilder: (context, index) {
          final event = model.nearbyEvents[index];
          return Container(
            width: 280.w,
            padding: EdgeInsets.only(right: 16.w),
            child: EventCard(
              event: event,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventInfoScreen(
                      event: event,
                      currentUser: userModel!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingList() {
    return SizedBox(
      height: 280.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 280.w,
            padding: EdgeInsets.only(right: 16.w),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String title, String message, IconData icon) {
    return Container(
      height: 280.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
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
      // CircleAvatar(
      //   radius: 20,
      //   backgroundColor: blueColor,
      //   child: IconButton(
      //     icon: Icon(Icons.person, color: Colors.white),
      //     onPressed: () {
      //       // Navigate to nearby matches
      //     },
      //   ),
      // ),
      20.horizontalSpace,
    ],
  );
}
