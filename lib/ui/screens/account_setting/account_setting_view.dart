import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/custom_widgets/friend_zone/account_settings.dart';
import 'package:code_structure/custom_widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountSettingView extends StatefulWidget {
  const AccountSettingView({super.key});

  @override
  State<AccountSettingView> createState() => _AccountSettingViewState();
}

class _AccountSettingViewState extends State<AccountSettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(onTap: () {}, child: Icon(Icons.arrow_back)),
        actions: [
          Icon(
            Icons.help_outline_outlined,
          ),
          10.horizontalSpace,
          Icon(
            Icons.settings_suggest_outlined,
            weight: 10,
            size: 37,
          ),
          20.horizontalSpace
        ],
        centerTitle: true,
        title: Text(
          "Account Settings",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            30.verticalSpace,
            Center(child: Text("Add user information here ")),
            Divider(),
            CustomAccountSettingWidget(
              icon: Icon(
                Icons.email,
              ),
              title: "Email Address",
            ),
            CustomAccountSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
            ),
            CustomAccountSettingWidget(
              icon: Icon(
                Icons.photo_size_select_actual_outlined,
              ),
              title: "Profile Photo",
            ),
            CustomAccountSettingWidget(
              icon: Icon(
                Icons.language,
              ),
              title: "Language Settings",
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Privacy Options",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800, fontSize: 17),
              ),
            ),
            CustomAccountSettingWidget(
              icon: Icon(
                Icons.remove_red_eye_outlined,
              ),
              title: "Hide Profile from Public Search",
            ),
            CustomAccountSettingWidget(
              icon: Icon(
                Icons.security_rounded,
              ),
              title: "Enable tow factor Authentication",
            ),
            CustomAccountSettingWidget(
              icon: Icon(
                Icons.notifications_none_outlined,
              ),
              title: "Push Notification Settings",
            ),
            CustomAccountSettingWidget(
              icon: Icon(
                Icons.email_outlined,
              ),
              title: "Recive Update via Email",
            ),
            CustomAccountSettingWidget(
              icon: Icon(
                Icons.message_outlined,
              ),
              title: "Recive SMS Notification",
            ),
            CustomAccountSettingWidget(
              icon: Icon(
                Icons.watch_later_outlined,
              ),
              title: "Recent Login Activity",
            ),
            30.verticalSpace,

            ///
            /// Custom Button
            ///
            CustomButton(
              name: "Log Out of All Devices",
              onPressed: () {},
              textColor: whiteColor,
            ),
            30.verticalSpace,

            ///
            /// Custom Button
            ///
            CustomButton(
              name: "Delete My Account",
              onPressed: () {},
              textColor: whiteColor,
            ),

            150.verticalSpace
          ],
        ),
      ),
    );
  }
}
