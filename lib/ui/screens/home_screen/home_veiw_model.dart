import 'dart:math';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/model/dashbord_Score_model.dart';
import 'package:code_structure/core/model/nearby_matches_model.dart';
import 'package:code_structure/core/model/schedual_meetups.dart';
import 'package:code_structure/core/model/up_coming_activities.dart';
import 'package:code_structure/core/others/base_view_model.dart';
import 'package:code_structure/main.dart';
import 'package:code_structure/models/User.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:photo_view/photo_view.dart';

class HomeScreenVeiwModel extends BaseViewModel {
  List<User?> matchedUsers = [];
  List<User?> nearbyUsers = [];
  bool isLoading = false;

  List<DashBordCompatitbiltyScoreModel> listcompatibilityscore = [
    DashBordCompatitbiltyScoreModel(
        imgUrl: AppAssets().score1,
        tiitle: "shayan zahid",
        subTittle: "shayan zahid"),
    DashBordCompatitbiltyScoreModel(
        imgUrl: AppAssets().score1,
        tiitle: "shayan zahid",
        subTittle: "shayan zahid"),
    DashBordCompatitbiltyScoreModel(
        imgUrl: AppAssets().score1,
        tiitle: "shayan zahid",
        subTittle: "shayan zahid"),
    DashBordCompatitbiltyScoreModel(
        imgUrl: AppAssets().score1,
        tiitle: "shayan zahid",
        subTittle: "shayan zahid"),
    DashBordCompatitbiltyScoreModel(
        imgUrl: AppAssets().score1,
        tiitle: "shayan zahid",
        subTittle: "shayan zahid")
  ];

  List<NearbyMatchesModel> listNearbyMatches = [
    NearbyMatchesModel(
        imgUrl: AppAssets().nearby1,
        groupName: "Hiking Group",
        time: "10:am",
        day: "sunday",
        message: "join us for  a local hike"),
    NearbyMatchesModel(
        imgUrl: AppAssets().nearby1,
        groupName: "Hiking Group",
        time: "10:am",
        day: "sunday",
        message: "join us for  a local hike"),
    NearbyMatchesModel(
        imgUrl: AppAssets().nearby1,
        groupName: "Hiking Group",
        time: "10:am",
        day: "sunday",
        message: "join us for  a local hike"),
    NearbyMatchesModel(
        imgUrl: AppAssets().nearby1,
        groupName: "Hiking Group",
        time: "10:am",
        day: "sunday",
        message: "join us for  a local hike"),
    NearbyMatchesModel(
        imgUrl: AppAssets().nearby1,
        groupName: "Hiking Group",
        time: "10:am",
        day: "sunday",
        message: "join us for  a local hike"),
  ];

  List<UpComingActivities> upComingActivites = [
    UpComingActivities(
        imgUrl: AppAssets().schedual1,
        title: "Beach Volleyball",
        dateAndTime: "Monday, 5:00 PM"),
    UpComingActivities(
        imgUrl: AppAssets().schedual1,
        title: "Cooking Class",
        dateAndTime: "Wednesday, 6:00 PM"),
    UpComingActivities(
        imgUrl: AppAssets().schedual1,
        title: "Yoga Session",
        dateAndTime: "Thursday, 6:00 PM"),
  ];

  List<SchedualMeetupsModel> listSchedualMeetups = [
    SchedualMeetupsModel(
        imgUrl: AppAssets().schedual1,
        title: "Shayanz zahid",
        dateAndTime: "Monday, 5:00 PM"),
    SchedualMeetupsModel(
        imgUrl: AppAssets().schedual1,
        title: "Shayanz zahid",
        dateAndTime: "Wednesday, 5:00 PM"),
    SchedualMeetupsModel(
        imgUrl: AppAssets().schedual1,
        title: "Shayanz zahid",
        dateAndTime: "Thursday, 5:00 PM"),
  ];
  HomeScreenVeiwModel() {
    initialize();
  }


  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();
    //  await getCurrentUser();
    await fetchMatchedUsers();
    await fetchNearbyUsers();
    isLoading = false;
    notifyListeners();
  }

  // Future<void> getCurrentUser() async {
  //   try {
  //     final authUser = await Amplify.Auth.getCurrentUser();
  //     final request = ModelQueries.get(
  //       User.classType,
  //       UserModelIdentifier(id: authUser.userId),
  //     );
  //     final response = await Amplify.API.query(request: request).response;
  //     currentUser = response.data;
  //   } catch (e) {
  //     safePrint('Error getting current user: $e');
  //   }
  // }

  Future<void> fetchMatchedUsers() async {
    try {
      if (userModel == null) return;

      final request = ModelQueries.list(User.classType);
      final response = await Amplify.API.query(request: request).response;
      final users = response.data?.items;

      if (users == null) {
        safePrint('errors: ${response.errors}');
        return;
      }

      // Filter users with matching interests or hobbies
      matchedUsers = users.where((user) {
        if (user?.id == userModel?.id) return false;

        final hasMatchingInterests = user?.interests?.any((interest) =>
                userModel?.interests?.contains(interest) ?? false) ??
            false;

        final hasMatchingHobbies = user?.hobbies?.any(
                (hobby) => userModel?.hobbies?.contains(hobby) ?? false) ??
            false;

        return hasMatchingInterests || hasMatchingHobbies;
      }).toList();
    } catch (e) {
      safePrint('Error fetching matched users: $e');
    }
  }

  Future<void> fetchNearbyUsers() async {
    try {
      if (userModel?.latitude == null || userModel?.longitude == null) return;

      final request = ModelQueries.list(User.classType);
      final response = await Amplify.API.query(request: request).response;
      final users = response.data?.items;

      if (users == null) {
        safePrint('errors: ${response.errors}');
        return;
      }

      // Filter users within 1000km radius
      nearbyUsers = users.where((user) {
        if (user?.id == userModel?.id) return false;
        if (user?.latitude == null || user?.longitude == null) return false;

        final distance = Geolocator.distanceBetween(
          userModel!.latitude!,
          userModel!.longitude!,
          user!.latitude!,
          user.longitude!,
        );

        // Convert meters to kilometers and check if within 1000km
        return (distance / 1000) <= 1000;
      }).toList();
    } catch (e) {
      safePrint('Error fetching nearby users: $e');
    }
  }
 

  // Helper method to calculate compatibility score (optional)
  double calculateCompatibilityScore(User otherUser) {
    if (userModel == null) return 0.0;

    final matchingInterests = userModel!.interests!
        .where((interest) => otherUser.interests?.contains(interest) ?? false)
        .length;

    final matchingHobbies = userModel!.hobbies!
        .where((hobby) => otherUser.hobbies?.contains(hobby) ?? false)
        .length;

    final totalInterests = userModel!.interests!.length;
    final totalHobbies = userModel!.hobbies!.length;

    return ((matchingInterests + matchingHobbies) /
            (totalInterests + totalHobbies)) *
        100;
  }
}

  double calculateCompatibilityScore(User otherUser) {
    if (userModel == null) return 0.0;

    final matchingInterests = userModel!.interests!
        .where((interest) => otherUser.interests?.contains(interest) ?? false)
        .length;

    final matchingHobbies = userModel!.hobbies!
        .where((hobby) => otherUser.hobbies?.contains(hobby) ?? false)
        .length;

    final totalInterests = userModel!.interests!.length;
    final totalHobbies = userModel!.hobbies!.length;

    return ((matchingInterests + matchingHobbies) /
            (totalInterests + totalHobbies)) *
        100;
  }

   Future<String> getFileUrl(String fileKey) async {
    final result = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(fileKey),
        options: StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(
            expiresIn: Duration(days: 7),
            validateObjectExistence: true,
          ),
        ) // 1 hour expiration
        ).result;
    return result.url.toString();
  }


 void showImagePreview(String imageUrl,context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PhotoView(
                imageProvider: NetworkImage(imageUrl),
                heroAttributes: PhotoViewHeroAttributes(tag: 'profileImage'),
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
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371.0; // Earth's radius in kilometers
  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _toRadians(double degree) {
  return degree * pi / 180;
}