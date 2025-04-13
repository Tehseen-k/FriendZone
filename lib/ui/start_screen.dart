import 'dart:math';

import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/buttons/custom_button.dart';
import 'package:code_structure/ui/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///
      /// Start Body
      ///
      body: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _headerText(),
            Spacer(),
            Image.asset(AppAssets().orbit),
            Spacer(),
          ],
        ),
      ),

      ///
      /// Custom Button
      ///
      bottomNavigationBar: _bottomTextButton(context),
    );
  }
}

_headerText() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: "Welcome to",
            style: style16N.copyWith(
                color: blackColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: "“Friend Zone”\n",
            style: style25B.copyWith(
                color: blueColor, fontWeight: FontWeight.w800, fontSize: 24.sp),
          ),
          TextSpan(
            text: "Connect and Collaborate\n With Ease!",
            style: style16N.copyWith(
                color: blackColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700),
          ),
        ])),
  );
}

_bottomTextButton(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
    color: Colors.transparent,
    height: 100,
    child: CustomButton(
      name: "Let's Start",
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()));
      },
      textColor: whiteColor,
    ),
  );
}

class OrbitAnimation extends StatefulWidget {
  @override
  _OrbitAnimationState createState() => _OrbitAnimationState();
}

class _OrbitAnimationState extends State<OrbitAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  final double centerSize = 80;
  final double orbitRadius = 100;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildOrbitingAvatar(double angle, String imageUrl) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final double rotation = _controller.value * 2 * pi;
        final double x = orbitRadius * cos(rotation + angle);
        final double y = orbitRadius * sin(rotation + angle);
        return Positioned(
          left: x + orbitRadius + (centerSize / 2) - 25,
          top: y + orbitRadius + (centerSize / 2) - 25,
          child: CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
            radius: 30,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> avatars = [
      AppAssets().woman,
      AppAssets().woman,
      AppAssets().woman,
      AppAssets().woman,
      AppAssets().woman,
      AppAssets().woman,
    ];

    return SizedBox(
      width: (orbitRadius + 50) * 2,
      height: (orbitRadius + 50) * 2,
      child: Stack(
        children: [
          // Circular orbit line
          Positioned.fill(
            child: Center(
              child: Container(
                width: orbitRadius * 2,
                height: orbitRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
              ),
            ),
          ),

          // Central avatar
          Positioned.fill(
            child: Center(
              child: CircleAvatar(
                backgroundImage: AssetImage(AppAssets().woman),
                radius: centerSize / 2,
              ),
            ),
          ),

          // Orbiting avatars
          for (int i = 0; i < avatars.length; i++)
            _buildOrbitingAvatar((3 * pi / avatars.length) * i, avatars[i]),
        ],
      ),
    );
  }
}
