// import 'package:code_structure/core/constants/app_asset.dart';
// import 'package:code_structure/core/constants/colors.dart';
// import 'package:code_structure/core/constants/date_time.dart';
// import 'package:code_structure/core/constants/strings.dart';
// import 'package:code_structure/core/constants/text_style.dart';
// import 'package:code_structure/core/model/app_user.dart';
// import 'package:code_structure/core/model/chat/messages.dart';
// import 'package:code_structure/ui/screens/chat/chat_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => ChatUsersViewModel(),
//       child: Consumer<ChatUsersViewModel>(
//         builder: (context, model, child) => Scaffold(
//           backgroundColor: whiteColor,

//           ///
//           /// App Bar
//           ///
//           appBar: _appBar(),

//           ///
//           /// Start Body
//           ///

//           body: Align(
//             alignment: Alignment.bottomCenter,
//             child: ListView.builder(
//                 padding: EdgeInsets.only(bottom: 100),
//                 shrinkWrap: true,
//                 itemCount: model.messages.length,
//                 itemBuilder: (context, index) {
//                   return ChatContainer(
//                     message: model.messages[index],
//                   );
//                 }),
//           ),

//           ///
//           /// Botomm app bar
//           ///
//           bottomSheet: Container(
//               height: 80.h,
//               // shadowColor: whiteColor,
//               color: Color(0xffFFFFFF),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       AppAssets.gallery,
//                       scale: 5,
//                     ),
//                     SizedBox(
//                       width: 10.w,
//                     ),
//                     Expanded(
//                       child: TextFormField(
//                         textAlign: TextAlign.start,
//                         decoration: InputDecoration(
//                           hintText: 'Write your message',
//                           fillColor: Color(0xffF3F6F6),
//                           filled: true,
//                           // suffixIcon: Icon(Icons.record_voice_over),
//                           contentPadding:
//                               EdgeInsets.symmetric(horizontal: 15, vertical: 2),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                             borderSide: BorderSide.none, // Remove borders
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                           // enabledBorder: OutlineInputBorder(
//                           //   borderRadius: borderRadius ?? BorderRadius.circular(4.0),
//                           //   borderSide: BorderSide(color: ColorPallete.primaryColor),
//                           // ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                             borderSide: BorderSide(color: blackColor),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Expanded(
//                     //   child: ReusableTextFormField(
//                     //     borderSide: BorderSide.none,
//                     //     borderRadius: BorderRadius.circular(12.r),
//                     //     hintText: 'Write your message',
//                     //   ),
//                     // ),
//                     SizedBox(
//                       width: 15.w,
//                     ),
//                     // Image.asset(
//                     //   "$icons/camera.png",
//                     //   scale: 5.0,
//                     // ),
//                     // SizedBox(
//                     //   width: 15.w,
//                     // ),
//                     // Image.asset(
//                     //   "$icons/microphone.png",
//                     //   scale: 5.0,
//                     // ),
//                   ],
//                 ),
//               )),
//         ),
//       ),
//     );
//   }

//   AppBar _appBar() {
//     return AppBar(
//       backgroundColor: whiteColor,
//       automaticallyImplyLeading: false,
//       elevation: 1.0,
//       title: Row(
//         children: [
//           ///
//           /// Image Profile
//           ///
//           Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               Container(
//                 height: 50.h,
//                 width: 50.w,
//                 decoration: BoxDecoration(shape: BoxShape.circle),
//                 child: Image.asset(
//                   "$dynamicAssets/woman.png",
//                   fit: BoxFit.cover,
//                 ),
//               ),

//               ///
//               /// online icon show
//               ///
//               Container(
//                 margin: EdgeInsets.only(bottom: 5),
//                 height: 8.h,
//                 width: 8.w,
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle, color: Color(0xff2BEF83)),
//               ),
//             ],
//           ),
//           SizedBox(
//             width: 10.w,
//           ),

//           ///
//           /// Name
//           ///
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Jhon Abraham",
//                   style: style16B.copyWith(fontSize: 16.sp, color: blackColor)),
//               Text("Property owner",
//                   style: style16B.copyWith(
//                       fontSize: 12.sp, color: greyColor.withOpacity(0.50))),
//             ],
//           ),
//         ],
//       ),

//       ///
//       /// audio and  video call icon images
//       ///
//       // actions: [
//       //   Padding(
//       //     padding: const EdgeInsets.only(right: 20.0),
//       //     child: Row(
//       //       children: [
//       //         Image.asset(
//       //           "$icons/audioCall.png",
//       //           scale: 5.0,
//       //         ),
//       //         SizedBox(
//       //           width: 15.w,
//       //         ),
//       //         Image.asset(
//       //           "$icons/videoCall.png",
//       //           scale: 4.0,
//       //         ),
//       //       ],
//       //     ),
//       //   )
//       // ],
//     );
//   }
// }

// class ChatContainer extends StatelessWidget {
//   final Message? message;
//   final AppUser? currentUser;
//   final bool? isShow;
//   ChatContainer({this.message, this.currentUser, this.isShow});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(left: message!.fromUserId != 1 ? 15.0 : 15.0),
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         child: Align(
//           alignment: (message!.fromUserId == "1"
//               ? Alignment.topLeft
//               : Alignment.topRight),
//           child: Column(
//             crossAxisAlignment: message!.fromUserId == "1"
//                 ? CrossAxisAlignment.start
//                 : CrossAxisAlignment.end,
//             children: [
//               Column(
//                 crossAxisAlignment: message!.fromUserId == "1"
//                     ? CrossAxisAlignment.start
//                     : CrossAxisAlignment.end,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: message!.fromUserId == "1"
//                           ? BorderRadius.only(
//                               topRight: Radius.circular(13),
//                               bottomRight: Radius.circular(13),
//                               bottomLeft: Radius.circular(13),
//                             )
//                           : BorderRadius.only(
//                               topLeft: Radius.circular(13),
//                               bottomLeft: Radius.circular(13),
//                               bottomRight: Radius.circular(13),
//                             ),
//                       color: message!.fromUserId == "1"
//                           ? Color(0xffF2F7FB)
//                           : Colors.black,
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     child: Text(
//                       message!.textMessage.toString(),
//                       style: message!.fromUserId == "1"
//                           ? style16B.copyWith(
//                               fontSize: 11.sp, color: blackColor)
//                           : style16B.copyWith(
//                               fontSize: 11.sp,
//                               color: whiteColor,
//                             ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8.0, vertical: 2),
//                     child: Text(
//                       "${onlyTime.format(message!.sendAt!)}",
//                       style:
//                           style14.copyWith(fontSize: 9.sp, color: blackColor),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// // class ChatBody extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<ChatViewModel>(builder: (context, value, child) {
// //       return Expanded(
// //         child: ListView(
// //           reverse: true,
// //           children: [
// //             MessageBubble(isMe: true, message: 'Yeah!'),
// //             MessageBubble(isMe: false, message: ' Hope you like it'),
// //             MessageBubble(isMe: false, message: 'Have a great working week!!'),
// //             MessageBubble(isMe: true, message: 'You did your job well!'),
// //             MessageBubble(isMe: false, message: 'Hello ! Nazrul How are you?'),
// //             MessageBubble(isMe: true, message: 'Hello! Jhon abraham!'),
// //           ],
// //         ),
// //       );
// //     });
// //   }
// // }

// // Widget _buildMessageComposer() {
// //   return Container(
// //     padding: EdgeInsets.all(8.0),
// //     color: Colors.grey[200],
// //     child: Row(
// //       children: [
// //         Expanded(
// //           child: TextField(
// //             decoration: InputDecoration(
// //               hintText: 'Type a message...',
// //               border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(25.0),
// //               ),
// //             ),
// //           ),
// //         ),
// //         SizedBox(width: 8.0),
// //         IconButton(
// //           icon: Icon(Icons.send),
// //           onPressed: () {
// //             // Implement sending message functionality
// //           },
// //         ),
// //       ],
// //     ),
// //   );
// // }

// // class MessageBubble extends StatelessWidget {
// //   final bool isMe;
// //   final String message;

// //   const MessageBubble({required this.isMe, required this.message});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(children: [
// //       isMe == false
// //           ? Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Container(
// //                   height: 40.h,
// //                   width: 40.w,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Image.asset(
// //                     "$images/profile.png",
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   width: 10.w,
// //                 ),
// //                 Text(
// //                   "Jhon Abraham",
// //                   style: headingTextStyleRegular.copyWith(fontSize: 14.sp),
// //                 ),
// //               ],
// //             )
// //           : SizedBox(),
// //       ListView.builder(
// //           reverse: true,
// //           physics: NeverScrollableScrollPhysics(),
// //           itemCount: 1,
// //           shrinkWrap: true,
// //           itemBuilder: (context, index) {
// //             return Column(
// //               children: [
// //                 Padding(
// //                   padding: EdgeInsets.symmetric(
// //                       vertical: isMe ? 4.0 : 4.0,
// //                       horizontal: isMe ? 8.0 : 50.0),
// //                   child: Align(
// //                     alignment:
// //                         isMe ? Alignment.centerRight : Alignment.centerLeft,
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                           color: isMe ? Colors.blue : Colors.grey[300],
// //                           borderRadius: isMe
// //                               ? BorderRadius.only(
// //                                   topLeft: Radius.circular(12),
// //                                   bottomLeft: Radius.circular(12),
// //                                   bottomRight: Radius.circular(12))
// //                               : BorderRadius.only(
// //                                   topRight: Radius.circular(12),
// //                                   bottomLeft: Radius.circular(12),
// //                                   bottomRight: Radius.circular(12))),
// //                       padding: EdgeInsets.all(8.0),
// //                       child: Column(
// //                         children: [
// //                           Text(
// //                             message,
// //                             style: TextStyle(
// //                                 color: isMe ? Colors.white : Colors.black),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             );
// //           }),
// //     ]);
// //   }
// // }