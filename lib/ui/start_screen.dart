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
            50.verticalSpace,
            Image.asset(
              AppAssets().app_start,
              fit: BoxFit.cover,
            ),
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
    margin: EdgeInsets.all(10),
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
