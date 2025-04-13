import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/ui/screens/root_screen/root_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatelessWidget {
  final int selectedScreen;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RootScreen({Key? key, this.selectedScreen = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RootViewModel(selectedScreen),
      child: Consumer<RootViewModel>(
        builder: (context, model, child) => Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: model.allScreen[model.selectedScreen],
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
                icon: Icon(Icons.home, size: 30),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: whiteColor,
                icon: Icon(Icons.group, size: 30),
                label: 'Group',
              ),
              BottomNavigationBarItem(
                backgroundColor: whiteColor,
                icon: Icon(Icons.chat, size: 30),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                backgroundColor: whiteColor,
                icon: Icon(Icons.person, size: 30),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
