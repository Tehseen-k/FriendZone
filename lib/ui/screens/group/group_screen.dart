import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/constants/auth_text_feild.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/strings.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/model/home_groups.dart';
import 'package:code_structure/ui/screens/chat/chat_screen.dart';
import 'package:code_structure/ui/screens/group/group_view_model.dart';
import 'package:code_structure/ui/screens/group_details/gourp_details_screen_.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupViewModel(),
      child: Consumer<GroupViewModel>(
        builder: (context, value, child) => Scaffold(
          ///
          /// App Bar
          ///
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Group You May like",
              style: style24B.copyWith(color: blackColor),
            ),
          ),

          ///
          /// Start Body
          ///

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: TextFormField(
                  decoration: authFieldDecoration.copyWith(
                      hintText: "Search for groups",
                      hintStyle: style14B.copyWith(
                          color: Color(0xff141A2E).withOpacity(0.62)),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xff141A2E).withOpacity(0.62),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                ),
                child: Text(
                  "Top Recommendations",
                  style: style24B.copyWith(color: blackColor),
                ),
              ),

              ///
              /// Top recommendations
              ///

              _topRecommendations(),

              ///
              /// Groups and recommendations
              ///
              _groups(),
            ],
          ),
        ),
      ),
    );
  }
}

_topRecommendations() {
  return SizedBox(
    height: 220,
    child: ListView.builder(
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupDetailsScreen()));
            },
            child: SizedBox(
              width: 320,
              // height: 220,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///
                  /// Image
                  ///
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    height: 128,
                    width: 320,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                            image: AssetImage("$dynamicAssets/group1.png"),
                            fit: BoxFit.cover)),
                  ),

                  ///
                  /// Image
                  ///
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text(
                      "Hiking Enthusiasts",
                      style: style16B.copyWith(color: blackColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 30),
                    child: Text(
                      "Shared Interest: Hiking wekjbfkwej;fbek;wbf;ejrb ljkrblbflerbhj.",
                      style: style14.copyWith(color: greyColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
  );
}

_chatAndSave(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => ChatScreen()));
          },
          child: Row(
            children: [
              Image.asset(
                AppAssets.chat2,
                scale: 4,
              ),
              10.horizontalSpace,
              Text(
                "Join",
                style: style14B.copyWith(color: blackColor),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Image.asset(
              AppAssets.saveIcon,
              scale: 4,
            ),
            10.horizontalSpace,
            Image.asset(
              AppAssets.more,
              scale: 4,
            ),
          ],
        )
      ],
    ),
  );
}

_groups() {
  return SizedBox(
    height: 360,
    child: ListView.builder(
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 300,
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(width: 1, color: greyColor)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///
                  /// Image
                  ///
                  Container(
                    height: 128,
                    width: 320,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                            image: AssetImage("$dynamicAssets/group1.png"),
                            fit: BoxFit.cover)),
                  ),

                  ///
                  /// Image
                  ///
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              AssetImage("$dynamicAssets/match1.png"),
                        ),
                        10.horizontalSpace,
                        Text(
                          "50 Members",
                          style: style14B.copyWith(color: greyColor),
                        ),
                        20.horizontalSpace,
                        Icon(
                          Icons.circle,
                          size: 7,
                          color: greyColor,
                        ),
                        20.horizontalSpace,
                        Expanded(
                          child: Text(
                            "5 miles away",
                            style: style14B.copyWith(color: greyColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                    ),
                    child: Text(
                      "Book Lovers Club",
                      style: style16B.copyWith(color: blackColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: Text(
                      "A group for book enthusiasts to discuss and share their favorite reads.",
                      style: style14.copyWith(color: greyColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  Spacer(),
                  _chatAndSave(context),
                ],
              ),
            ),
          );
        }),
  );
}
