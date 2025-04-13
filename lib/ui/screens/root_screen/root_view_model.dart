import 'package:code_structure/core/enums/view_state_model.dart';
import 'package:code_structure/core/others/base_view_model.dart';
import 'package:code_structure/main.dart';
import 'package:code_structure/ui/screens/chats_list/chats_list_screen.dart';
import 'package:code_structure/ui/screens/group/group_screen.dart';
import 'package:code_structure/ui/screens/home_screen/home_screen.dart';
import 'package:code_structure/ui/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class RootViewModel extends BaseViewModel {
  // final PageController pageController = PageController(initialPage: 0);

  int selectedScreen = 0;

  List<Widget> allScreen = [
    HomeScreen(),
    GroupScreen(),
    ChatsListScreen(),
    ProfileScreen(),
  ];

  ///
  /// Constructor
  ///
  RootViewModel(int? val) : selectedScreen = val ?? 0 {
    updatedScreen(selectedScreen);
    notifyListeners();
  }

  // int selectIndex = 0;

  updatedScreen(int index) {
    setState(ViewState.busy);
    selectedScreen = index;
    setState(ViewState.idle);
    notifyListeners();
  }

  // pushScreen(int index) {
  //   pageController.animateToPage(index,
  //       duration: Duration(milliseconds: 2000), curve: Curves.bounceIn);
  //   selectedScreen = index;
  //   notifyListeners();
  // }
}
