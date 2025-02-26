import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/strings.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/ui/screens/auth/setup_profile/setup_profile_screen.dart';
import 'package:code_structure/ui/screens/user_profile_screen/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, value, child) => Scaffold(
          ///
          /// App Bar
          ///
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Profile",
              style: style24B.copyWith(color: blackColor),
            ),
          ),

          ///
          /// Start Body
          ///

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///
                /// Profile
                ///
                _profile(),
                20.verticalSpace,

                ///
                /// Divider
                ///
                Divider(),
                20.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Image.asset(
                        AppAssets.email,
                        scale: 4.5,
                      ),
                      10.horizontalSpace,
                      Text(
                        "Email Address",
                        style: style16N.copyWith(
                            color: blackColor, fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                iconRow(
                    image: AppAssets.lock,
                    name: 'Update Password',
                    onPressed: () {}),

                iconRow(
                    image: AppAssets.gallery,
                    name: 'Profile Photo',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetupProfileScreen()));
                    }),
                iconRow(
                    image: AppAssets.langauge,
                    name: 'Language Settings',
                    onPressed: () {}),
                30.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Privacy Options',
                    style:
                        style16B.copyWith(color: blackColor, fontSize: 20.sp),
                  ),
                ),
                20.verticalSpace,
                iconRow(
                    image: AppAssets.hide_profile,
                    name: 'Hide Profile from Public Search',
                    onPressed: () {}),
                iconRow(
                    image: AppAssets.enableTwoFactor,
                    name: 'Enable Two-Factor Authentication',
                    onPressed: () {}),
                iconRow(
                    image: AppAssets.notification,
                    name: 'Push Notification Settings',
                    onPressed: () {}),
                iconRow(
                    image: AppAssets.email,
                    name: 'Receive Updates via Email',
                    onPressed: () {}),
                iconRow(
                    image: AppAssets.message,
                    name: 'Receive SMS Notifications',
                    onPressed: () {}),
                iconRow(
                    image: AppAssets.profile,
                    name: 'Recent Login Activity',
                    onPressed: () {}),
                40.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_profile() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 70.r,
              backgroundImage: AssetImage("$dynamicAssets/woman.png"),
            ),
            InkWell(
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: blueColor,
                radius: 20.r,
                child: Icon(
                  Icons.edit,
                  color: whiteColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      Text(
        "Aurelia Smith",
        style: style25B.copyWith(color: blackColor),
      ),
      Text(
        "aurelia.smith@example.com",
        style: style16.copyWith(color: greyColor),
      ),
    ],
  );
}

iconRow(
    {required String? image,
    required String? name,
    required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
      child: Row(
        children: [
          Image.asset(
            "$image",
            scale: 4,
          ),
          15.horizontalSpace,
          Text(
            "$name",
            style: style16N.copyWith(color: blackColor, fontSize: 18.sp),
          ),
        ],
      ),
    ),
  );
}
