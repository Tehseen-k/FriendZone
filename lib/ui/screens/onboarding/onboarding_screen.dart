// ignore_for_file: deprecated_member_use

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/strings.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/ui/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                buildPage(
                    context,
                    "$staticAssets/freind_zone.png", // Replace with your image path
                    "Friend Zone",
                    "Connect, collaborate, and create meaningful friendships.\n Welcome to Friend Zone!"),
                buildPage(
                  context,
                  "$staticAssets/ai_powered.png", // Replace with your image path
                  "AI-Powered Matches",
                  "Our AI helps you find the perfect match based on shared interests.",
                ),
                buildPage(
                  context,
                  "$staticAssets/group.png", // Replace with your image path
                  "Group Creation",
                  "Form or join groups to connect with like-minded people.",
                ),
                buildPage(
                  context,
                  "$staticAssets/map.png", // Replace with your image path
                  "Geolocation Networking",
                  "Discover and connect with friends nearby.",
                ),
                buildPage(
                  context,
                  "$staticAssets/shedule.png", // Replace with your image path
                  "Smart Scheduler",
                  "Plan activities and events effortlessly.",
                ),
                buildPage(
                  context,
                  "$staticAssets/chat.png", // Replace with your image path
                  "Real-Time Chats",
                  "Chat with friends in real-time.",
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              6, // Update for the number of pages
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: _currentPage == index ? 30 : 6,
                decoration: BoxDecoration(
                  color: _currentPage == index ? buttonColor : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          60.verticalSpace,
          // Stack(
          //   children: [
          //     Container(
          //       height: 100,
          //       decoration: BoxDecoration(color: whiteCoolor),
          //     ),
          //     Positioned(bottom: 80.r, child: ),
          //   ],
          // )
          buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget buildPage(BuildContext context, String imagePath, String title,
      String description) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              imagePath,
              height: 250,
              width: 250,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavigation() {
    return Stack(
      clipBehavior:
          Clip.none, // Ensures the button can overlap outside the container
      children: [
        // Bottom navigation container
        Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: whiteColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                if (_currentPage > 0)
                  InkWell(
                    onTap: () {
                      _controller.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: blackColor.withOpacity(0.50),
                        ),
                        Text(
                          "Back",
                          style: style14B.copyWith(
                            color: blackColor.withOpacity(0.50),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(), // Placeholder when back button is not shown

                // Skip Button
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.skip_next,
                        color: blackColor.withOpacity(0.50),
                      ),
                      Text(
                        "Skip",
                        style: style14B.copyWith(
                          color: blackColor.withOpacity(0.50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating Next/Finish Button
        Positioned(
          top: -30, // Adjust this value to control how much the button overlaps
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                if (_currentPage == 5) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                } else {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
              child: CircleAvatar(
                backgroundColor: blueColor,
                radius: 40.r,
                child: CircleAvatar(
                  backgroundColor: whiteColor,
                  radius: 37.r,
                  child: CircleAvatar(
                    radius: 35.r,
                    backgroundColor: blueColor,
                    child: Text(
                      _currentPage == 5 ? "Finish" : "Next",
                      style: style16B.copyWith(color: whiteColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
