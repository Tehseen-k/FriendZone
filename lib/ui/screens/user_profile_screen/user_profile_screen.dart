// ignore_for_file: depend_on_referenced_packages

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/strings.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/main.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/ui/screens/chat_screen/chat_screen.dart';
import 'package:code_structure/ui/screens/home_screen/home_veiw_model.dart';
import 'package:code_structure/ui/screens/user_profile_screen/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatefulWidget {
  final User matchedUser;
  final double compatibilityScore;
  const UserProfileScreen(
      {super.key, required this.matchedUser, required this.compatibilityScore});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();
  }

  Future<void> _initializeVideoControllers() async {
    if (widget.matchedUser.profileVideoKey?.isNotEmpty ?? false) {
      for (String videoKey in widget.matchedUser.profileVideoKey!) {
        final videoUrl = await getFileUrl(videoKey);
        final controller = VideoPlayerController.network(videoUrl);
        await controller.initialize();
        setState(() {
          _videoControllers[videoKey] = controller;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Color(0xffffffff),
            appBar: _appBar(context),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
                    25.verticalSpace,
                    _buildActionButtons(context, widget.matchedUser),
                    25.verticalSpace,
                    _buildVideoSection(),
                    25.verticalSpace,
                    _buildPhotoGallery(),
                    25.verticalSpace,
                    _buildPersonalInfo(widget.matchedUser),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Profile Image
        GestureDetector(
          onTap: widget.matchedUser.profileImageKey != null
              ? () => _showImagePreview(widget.matchedUser.profileImageKey!)
              : null,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor.withOpacity(0.1), Colors.white],
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: widget.matchedUser.profileImageKey != null
                ? FutureBuilder<String>(
                    future: getFileUrl(widget.matchedUser.profileImageKey!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Hero(
                          tag: 'profileImage',
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data!),
                            radius: 80,
                          ),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    },
                  )
                : CircleAvatar(
                    radius: 80,
                    backgroundImage:
                        AssetImage("$dynamicAssets/default_avatar.png"),
                  ),
          ),
        ),
        20.verticalSpace,
        // User Info
        Text(
          widget.matchedUser.username ?? "Unknown",
          style: style25B.copyWith(color: blackColor),
        ),
        5.verticalSpace,
        Text(
          widget.matchedUser.introduction ?? "",
          style: style16.copyWith(color: blackColor),
          textAlign: TextAlign.center,
        ),
        10.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.1),
                Colors.blue.withOpacity(0.1)
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.matchedUser.visible ?? false)
                Icon(Icons.verified, color: Colors.blue),
              SizedBox(width: 5.w),
              Text(
                "${widget.compatibilityScore}% Compatibility",
                style: style14B.copyWith(color: greyColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoSection() {
    if (widget.matchedUser.profileVideoKey?.isEmpty ?? true) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Video Introduction",
          style: style18B.copyWith(color: blackColor),
        ),
        15.verticalSpace,
        Container(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.matchedUser.profileVideoKey?.length ?? 0,
            itemBuilder: (context, index) {
              final videoKey = widget.matchedUser.profileVideoKey![index];
              final controller = _videoControllers[videoKey];

              if (controller == null) return SizedBox();

              return Container(
                width: 140.w,
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor.withOpacity(0.1), Colors.white],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      VideoPlayer(controller),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showVideoFullScreen(videoKey),
                          child: Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              size: 50,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoGallery() {
    if (widget.matchedUser.userImageKeys?.isEmpty ?? true) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Photo Gallery",
          style: style18B.copyWith(color: blackColor),
        ),
        15.verticalSpace,
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: widget.matchedUser.userImageKeys?.length ?? 0,
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: getFileUrl(widget.matchedUser.userImageKeys![index]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return GestureDetector(
                  onTap: () => _showImagePreview(snapshot.data as String),
                  child: Hero(
                    tag: widget.matchedUser.userImageKeys![index],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data as String),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _showVideoFullScreen(String videoKey) {
    final controller = _videoControllers[videoKey];
    if (controller == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ValueListenableBuilder(
                        valueListenable: controller,
                        builder: (context, VideoPlayerValue value, child) {
                          return IconButton(
                            icon: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              value.isPlaying
                                  ? controller.pause()
                                  : controller.play();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePreview(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PhotoView(
                imageProvider: NetworkImage(imageUrl),
                heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
              ),
              SafeArea(
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}

_appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Color(0xffffffff),
    leading: Icon(Icons.arrow_back_ios),
    title: Text(
      "User Profile",
      style: style24B.copyWith(color: blackColor),
    ),
    centerTitle: true,
    // actions: [
    //   Icon(
    //     Icons.edit,
    //     color: blackColor,
    //   ),
    //   20.horizontalSpace,
    //   Icon(
    //     Icons.settings,
    //     color: blackColor,
    //   )
    // ],
  );
}

Widget _buildActionButtons(BuildContext context, User matchedUser) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                            currentUser: userModel!,
                            participants: [matchedUser])));
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Message",
                    style: style16B.copyWith(color: whiteColor),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 8),
            child: InkWell(
              onTap: () {
                // Handle block action
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.red.withOpacity(0.8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Block",
                    style: style16B.copyWith(color: whiteColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildPersonalInfo(User user) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, primaryColor.withOpacity(0.05)],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          blurRadius: 8,
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 1,
        ),
      ],
    ),
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personal Information",
          style: style18B.copyWith(color: blackColor),
        ),
        15.verticalSpace,
        if (user.interests?.isNotEmpty ?? false) ...[
          Text(
            "Interests",
            style: style16B.copyWith(color: blackColor),
          ),
          10.verticalSpace,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.interests!
                .map((interest) => Chip(
                      label: Text(interest),
                      backgroundColor: primaryColor.withOpacity(0.1),
                      labelStyle: TextStyle(color: primaryColor),
                    ))
                .toList(),
          ),
          20.verticalSpace,
        ],
        if (user.hobbies?.isNotEmpty ?? false) ...[
          Text(
            "Hobbies",
            style: style16B.copyWith(color: blackColor),
          ),
          10.verticalSpace,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.hobbies!
                .map((hobby) => Chip(
                      label: Text(hobby),
                      backgroundColor: Colors.purple.withOpacity(0.1),
                      labelStyle: TextStyle(color: Colors.purple[900]),
                    ))
                .toList(),
          ),
          20.verticalSpace,
        ],
        if (user.address != null) ...[
          Text(
            "Location",
            style: style16B.copyWith(color: blackColor),
          ),
          10.verticalSpace,
          GestureDetector(
            onTap: () {
              if (user.latitude != null && user.longitude != null) {
                final url =
                    'https://www.google.com/maps/search/?api=1&query=${user.latitude},${user.longitude}';
                launchUrl(Uri.parse(url));
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.teal.withOpacity(0.15),
                    Colors.blue.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.location_on, color: Colors.teal),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Text(
                      user.address!,
                      style: style16.copyWith(color: blackColor),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
                ],
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
