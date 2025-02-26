import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/constants/auth_text_feild.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/strings.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/buttons/custom_button.dart';
import 'package:code_structure/ui/screens/root_screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UplaodProfileVideoScreen extends StatefulWidget {
  @override
  _UplaodProfileVideoScreenState createState() =>
      _UplaodProfileVideoScreenState();
}

class _UplaodProfileVideoScreenState extends State<UplaodProfileVideoScreen> {
  List<String> listimages = [
    AppAssets.hiking,
    AppAssets.tech,
    AppAssets.travel,
    AppAssets.cooking,
    AppAssets.hiking,
    AppAssets.tech,
    AppAssets.travel,
    AppAssets.cooking,
  ];
  List<String> name = [
    "Hiking",
    "Tech",
    "Travel",
    "Cooking",
    "Hiking",
    "Tech",
    "Travel",
    "Cooking",
  ];

  int selectedIndex = -1; // Tracks the selected index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Setup Profile",
          style: style24B.copyWith(color: blackColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: authFieldDecoration.copyWith(
                  hintText:
                      "Let others know more about you! Upload your photo, share your interests, and set your preferences.",
                  hintStyle: style14B.copyWith(color: greyColor),
                  fillColor: blackColor.withOpacity(0.04),
                ),
                enabled: false,
                onTap: () {},
              ),
              _profile(),
              20.verticalSpace,
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listimages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    bool isSelected = index == selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(6),
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.white,
                          border: Border.all(
                            width: 0.4,
                            color: isSelected ? Colors.blue : borderColor,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${name[index]}",
                              style: style14B.copyWith(
                                color: isSelected ? Colors.white : blackColor,
                              ),
                            ),
                            10.horizontalSpace,
                            Image.asset(
                              "${listimages[index]}",
                              scale: 4,
                              color: isSelected ? Colors.white : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "Preferred activities",
                  style: style16B.copyWith(color: blackColor),
                ),
              ),
              10.verticalSpace,
              TextFormField(
                decoration: authFieldDecoration.copyWith(
                    hintText: "Write your Activities which you prefer to s",
                    hintStyle: style14B.copyWith(color: greyColor),
                    fillColor: blackColor.withOpacity(0.04)),
              ),
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "Relationship goals",
                  style: style16B.copyWith(color: blackColor),
                ),
              ),
              10.verticalSpace,
              TextFormField(
                decoration: authFieldDecoration.copyWith(
                    hintText: "Write your Relationship goals",
                    hintStyle: style14B.copyWith(color: greyColor),
                    fillColor: blackColor.withOpacity(0.04)),
              ),
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "Visibility Preferences",
                  style: style16B.copyWith(color: blackColor),
                ),
              ),
              10.verticalSpace,
              TextFormField(
                decoration: authFieldDecoration.copyWith(
                    hintText: "Write which is your Visibility Preferences",
                    hintStyle: style14B.copyWith(color: greyColor),
                    fillColor: blackColor.withOpacity(0.04)),
              ),
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "Location",
                  style: style16B.copyWith(color: blackColor),
                ),
              ),
              10.verticalSpace,
              TextFormField(
                decoration: authFieldDecoration.copyWith(
                    hintText: "Set your location",
                    hintStyle: style14B.copyWith(color: greyColor),
                    fillColor: blackColor.withOpacity(0.04)),
              ),
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "Radius",
                  style: style16B.copyWith(color: blackColor),
                ),
              ),
              10.verticalSpace,
              TextFormField(
                decoration: authFieldDecoration.copyWith(
                    hintText: "Set a radius",
                    hintStyle: style14B.copyWith(color: greyColor),
                    fillColor: blackColor.withOpacity(0.04)),
              ),
              20.verticalSpace,
              CustomButton(
                  textColor: whiteColor,
                  name: "Save Profile",
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RootScreen()));
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _profile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          20.verticalSpace,
          CircleAvatar(
            radius: 60.r,
            backgroundImage: AssetImage("$dynamicAssets/woman.png"),
          ),
          20.verticalSpace,
          Text(
            "Upload Photo/Video",
            style: style25B.copyWith(color: blackColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Use a clear photo or a fun video to make a great first impression!",
              style: style16N.copyWith(color: blackColor),
              textAlign: TextAlign.center,
            ),
          ),
          5.verticalSpace,
          Text(
            "Upload Photo Upload Video",
            style: style14B.copyWith(color: greyColor),
          ),
        ],
      ),
    );
  }
}
