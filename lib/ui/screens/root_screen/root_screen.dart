import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/strings.dart';
import 'package:code_structure/custom_widgets/bottom_navigator_bar.dart';
import 'package:code_structure/ui/screens/root_screen/root_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

class RootScreen extends StatelessWidget {
  final int? selectedScreen;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RootScreen({super.key, this.selectedScreen = 0});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RootViewModel(selectedScreen),
      child: Consumer<RootViewModel>(
        builder: (context, model, child) => Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,

          ///
          /// Start Body
          ///
          body: model.allScreen[model.selectedScreen],

          ///
          /// BottomBar
          ///
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: blueColor,
              unselectedItemColor: greyColor,
              currentIndex: model.selectedScreen,
              onTap: (index) {
                model.updatedScreen(index);
              },
              items: [
                BottomNavigationBarItem(
                    backgroundColor: whiteColor,
                    icon: Icon(
                      Icons.home,
                      size: 30,
                    ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    backgroundColor: whiteColor,
                    icon: Icon(
                      Icons.group,
                      size: 30,
                    ),
                    label: 'Group'),
                BottomNavigationBarItem(
                    backgroundColor: whiteColor,
                    icon: Icon(
                      Icons.chat,
                      size: 30,
                    ),
                    label: 'chat'),
                BottomNavigationBarItem(
                    backgroundColor: whiteColor,
                    icon: Icon(
                      Icons.person,
                      size: 30,
                    ),
                    label: 'Profile'),
              ]),
          // bottomNavigationBar: Container(
          //   height: 70.h,
          //   decoration: BoxDecoration(color: Colors.white, boxShadow: [
          //     BoxShadow(
          //         color: Colors.black.withOpacity(0.08),
          //         offset: const Offset(0, 1),
          //         blurRadius: 7.r,
          //         spreadRadius: 0),
          //   ]),
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 16.0),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: [
          //         CustomBottomNavigatorBar(
          //           image: '$iconsAssets/home1.png',
          //           onTap: () {
          //             model.updatedScreen(0);
          //           },
          //           iconColor:
          //               model.selectedScreen == 0 ? blueColor : Colors.grey,
          //           name: 'Home',
          //           textColor:
          //               model.selectedScreen == 0 ? blueColor : Colors.grey,
          //         ),
          //         CustomBottomNavigatorBar(
          //           image: '$iconsAssets/groups1.png',
          //           onTap: () {
          //             model.updatedScreen(1);
          //           },
          //           iconColor:
          //               model.selectedScreen == 1 ? blueColor : Colors.grey,
          //           name: 'Group',
          //           textColor:
          //               model.selectedScreen == 1 ? blueColor : Colors.grey,
          //         ),
          //         CustomBottomNavigatorBar(
          //           image: '$iconsAssets/profile.png',
          //           onTap: () {
          //             model.updatedScreen(2);
          //           },
          //           iconColor:
          //               model.selectedScreen == 2 ? blueColor : Colors.grey,
          //           name: 'Profile',
          //           textColor:
          //               model.selectedScreen == 2 ? blueColor : Colors.grey,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          ///
          /// Right Drawer
          ///
          // endDrawer: buildDrawer(context),
        ),
      ),
    );
  }
}

//   Widget bottomBar(RootViewModel model) {
//     return BottomAppBar(
//       color: Colors.green,
//       elevation: 0.0,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           CustomBottomNavigator(
//             currentIndex: model.selectedScreen,
//             indexNumber: 1,
//             text: 'Shop',
//             image: model.selectedScreen == 0 ? "" : "AppAssets.shop",
//             onPressed: () {
//               model.updatedScreen(0);
//             },
//           ),
//           CustomBottomNavigator(
//             currentIndex: model.selectedScreen,
//             indexNumber: 1,
//             text: 'Shop',
//             image: model.selectedScreen == 1 ? "" : "AppAssets.shop",
//             onPressed: () {
//               model.updatedScreen(1);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
