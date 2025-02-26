import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/custom_widgets/buttons/custom_button.dart';
import 'package:code_structure/custom_widgets/friend_zone/notification_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountNotificationSettingView extends StatefulWidget {
  const AccountNotificationSettingView({super.key});

  @override
  State<AccountNotificationSettingView> createState() =>
      _AccountNotificationSettingViewState();
}

class _AccountNotificationSettingViewState
    extends State<AccountNotificationSettingView> {
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
            CustomNotificationSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
            ),
            CustomNotificationSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
            ),
            CustomNotificationSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
            ),
            CustomNotificationSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
            ),
            CustomNotificationSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Privacy Options",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800, fontSize: 17),
              ),
            ),
            CustomNotificationSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
            ),
            CustomNotificationSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
            ),
            CustomNotificationSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
            ),
            CustomNotificationSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
            ),
            CustomNotificationSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
            ),
            CustomNotificationSettingWidget(
              icon: Icon(
                Icons.lock_outline_rounded,
              ),
              title: "Update Password",
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
