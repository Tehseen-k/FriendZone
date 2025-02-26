// ignore_for_file: unused_local_variable

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/ui/screens/your_matches/tabs/swipe_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'your_matchs_view_model.dart';

class YourMatches extends StatefulWidget {
  const YourMatches({super.key});

  @override
  State<YourMatches> createState() => _YourMatchesState();
}

class _YourMatchesState extends State<YourMatches> {
  bool _isSelected = true;
  @override
  void initState() {
    super.initState();
  }

  void onClick() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (context) => YourMatchesViewModel(),
      child: Consumer<YourMatchesViewModel>(builder: (context, model, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                children: [
                  30.verticalSpace,
                  Container(
                    width: screenwidth * 0.88,
                    decoration: BoxDecoration(
                      color: transparentColor.withOpacity(0.10),
                      border: Border.all(color: borderColor.withOpacity(0.20)),
                      borderRadius: BorderRadius.circular(57),
                    ),
                    child: TabBar(tabs: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                            40,
                          )),
                          child: Tab(child: Text("Swipe Tab"))),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40)),
                        child: Tab(
                          child: Text("List View"),
                        ),
                      )
                    ]),
                  ),
                  Expanded(
                      child: TabBarView(
                          children: [SwipTabYourMatvhes(), Text("fds")])),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
