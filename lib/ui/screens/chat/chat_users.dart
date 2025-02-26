import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/strings.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/ui/screens/chat/chat_screen.dart';
import 'package:code_structure/ui/screens/chat/chat_view_model.dart';
import 'package:code_structure/ui/screens/chat_screen/chat_screen.dart';
import 'package:code_structure/ui/screens/user_profile_screen/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatUsersViewModel(),
      child: Consumer<ChatUsersViewModel>(
        builder: (context, value, child) => Scaffold(
          ///
          /// App Bar
          ///
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Text(
              "Chats",
              style: style24B.copyWith(color: blackColor),
            ),
          ),

          ///
          /// Start Body
          ///
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => ChatScreen()));
                },
                leading: CircleAvatar(
                  radius: 20.r,
                  backgroundImage: AssetImage("$dynamicAssets/woman.png"),
                ),
                title: Text(
                  "Alice",
                  style: style16B.copyWith(color: blackColor),
                ),
                subtitle: Text(
                  "Hey How are you doing?",
                  style: style14N.copyWith(color: greyColor),
                ),
                // titleAlignment: ListTileTitleAlignment.center,
                isThreeLine: true,
                trailing: Text(
                  "10:00 AM",
                  style: style14N.copyWith(color: greyColor),
                ),
              );
            },
          ),
        ),

        // body: ListView.builder(
        //     shrinkWrap: true,
        //     padding: EdgeInsets.all(10),
        //     scrollDirection: Axis.horizontal,
        //     itemCount: 10,
        //     itemBuilder: (context, index) {
        //       return Container(
        //         height: 100,
        //         width: double.infinity,
        //         decoration: BoxDecoration(color: blackColor),
        //         child: Text(
        //           "saf",
        //           style: style16B,
        //         ),
        //       );
        //     })),
      ),
    );
  }
}
