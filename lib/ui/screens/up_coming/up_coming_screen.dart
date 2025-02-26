// ignore_for_file: use_key_in_widget_constructors

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/friend_zone/custom_upcoming.dart';
import 'package:code_structure/ui/screens/up_coming/up_coming_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpComingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UpComingViewModel(),
      child: Consumer<UpComingViewModel>(
          builder: (context, model, child) => Scaffold(
                ///
                /// App Bar
                ///
                appBar: _appBar(context),

                ///
                /// Start Body
                ///
                body: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 1.2),
                  itemCount: model.listUpComing.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: CustomUpComing(
                          upComingModel: model.listUpComing[index]),
                    );
                  },
                ),
              )),
    );
  }
}

_appBar(BuildContext context) {
  return AppBar(
    backgroundColor: whiteColor,
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: blackColor,
        )),
    title: Text(
      "Upcoming Activities",
      style: style24B.copyWith(color: blackColor),
    ),
  );
}
