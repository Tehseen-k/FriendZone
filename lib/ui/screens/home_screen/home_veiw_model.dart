// ignore_for_file: unnecessary_null_comparison

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
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/models/GroupEvent.dart';
import 'package:code_structure/models/User.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:photo_view/photo_view.dart';

class HomeScreenVeiwModel extends BaseViewModel {
  List<User?> matchedUsers = [];
  List<User?> nearbyUsers = [];
  List<Group> nearbyGroups = [];
  List<Group> matchedGroups = [];
  List<GroupEvent> nearbyEvents = [];
  List<GroupEvent> upcomingEvents = [];
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

    await Future.wait([
      fetchMatchedUsers(),
      fetchNearbyUsers(),
      fetchNearbyGroups(),
      fetchMatchedGroups(),
      fetchNearbyEvents(),
      fetchUpcomingEvents(),
    ]);

    isLoading = false;
    notifyListeners();
  }

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
      print("hereee2");
      if (userModel?.latitude == null || userModel?.longitude == null) return;
      print("hereee3");
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
        return (distance / 100000000) <= 100000000;
      }).toList();
      print("nearyby users length ${nearbyUsers.length}");
    } catch (e) {
      safePrint('Error fetching nearby users: $e');
    }
  }

  Future<void> fetchNearbyGroups() async {
    try {
      if (userModel?.latitude == null || userModel?.longitude == null) return;

      final request = ModelQueries.list(Group.classType);
      final response = await Amplify.API.query(request: request).response;
      final groups = response.data?.items.whereType<Group>().toList() ?? [];

      // Filter groups using Geolocator distance calculation
      nearbyGroups = groups.where((group) {
        if (group.latitude == null || group.longitude == null) return false;

        final distance = Geolocator.distanceBetween(
          userModel!.latitude!,
          userModel!.longitude!,
          group.latitude,
          group.longitude,
        );

        // Convert meters to kilometers and check if within radius (using same radius as users)
        return (distance / 100000000) <= 100000000; // 1000km radius
      }).toList();

      print("near by interest ${nearbyGroups.first.interests?.length}");
    } catch (e) {
      safePrint('Error fetching nearby groups: $e');
    }
  }

  Future<void> fetchMatchedGroups() async {
    try {
      print("hereee01");
      if (userModel?.interests == null && userModel?.hobbies == null) return;
      print("hereee 002");
      final request = ModelQueries.list(Group.classType);
      final response = await Amplify.API.query(request: request).response;
      final groups = response.data?.items.whereType<Group>().toList() ?? [];
      print("interesttt ${groups.first.interests}");
      print("hobbies ${groups.first.hobbies?.length}");
      // Filter groups with matching interests or hobbies
      matchedGroups = groups.where((group) {
        final hasMatchingInterests = group.interests?.any(
              (interest) => userModel?.interests?.contains(interest) ?? false,
            ) ??
            false;

        final hasMatchingHobbies = group.hobbies?.any(
              (hobby) => userModel?.hobbies?.contains(hobby) ?? false,
            ) ??
            false;

        return hasMatchingInterests || hasMatchingHobbies;
      }).toList();

      // Sort by number of matching interests and hobbies
      matchedGroups.sort((a, b) {
        final aScore = calculateGroupMatchScore(a);
        final bScore = calculateGroupMatchScore(b);
        return bScore.compareTo(aScore);
      });
    } catch (e) {
      safePrint('Error fetching matched groups: $e');
    }
  }

  Future<void> fetchNearbyEvents() async {
    try {
      if (userModel?.latitude == null || userModel?.longitude == null) return;

      final request = ModelQueries.list(GroupEvent.classType);
      final response = await Amplify.API.query(request: request).response;
      final events =
          response.data?.items.whereType<GroupEvent>().toList() ?? [];

      // Filter upcoming events using Geolocator distance calculation
      final now = DateTime.now();
      print("events lenght ${events.length}");
      nearbyEvents = events.where((event) {
        if (event.startTime.getDateTimeInUtc().isBefore(now)) return false;
        if (event.latitude == null || event.longitude == null) return false;

        final distance = Geolocator.distanceBetween(
          userModel!.latitude!,
          userModel!.longitude!,
          event.latitude!,
          event.longitude!,
        );

        // Convert meters to kilometers and check if within radius (using same radius as users)
        return (distance / 100000000) <= 100000000; // 1000km radius
      }).toList();

      // Sort by start time
      nearbyEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      safePrint('Error fetching nearby events: $e');
    }
  }

  Future<void> fetchUpcomingEvents() async {
    try {
      final request = ModelQueries.list(GroupEvent.classType);
      final response = await Amplify.API.query(request: request).response;
      final events =
          response.data?.items.whereType<GroupEvent>().toList() ?? [];

      // Filter upcoming events and sort by start time
      final now = DateTime.now();
      print("upcomming events 1 ${events.length}");
      upcomingEvents = events
          .where((event) => event.startTime.getDateTimeInUtc().isAfter(now))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      print("upcomming events 2 ${upcomingEvents.length}");
    } catch (e) {
      safePrint('Error fetching upcoming events: $e');
    }
  }

  double calculateGroupMatchScore(Group group) {
    if (userModel == null) return 0.0;

    int matchingInterests = 0;
    int matchingHobbies = 0;

    for (final interest in group.interests ?? []) {
      if (userModel!.interests?.contains(interest) ?? false) {
        matchingInterests++;
      }
    }

    for (final hobby in group.hobbies ?? []) {
      if (userModel!.hobbies?.contains(hobby) ?? false) {
        matchingHobbies++;
      }
    }

    final totalInterests =
        (userModel!.interests?.length ?? 0) + (group.interests?.length ?? 0);
    final totalHobbies =
        (userModel!.hobbies?.length ?? 0) + (group.hobbies?.length ?? 0);

    if (totalInterests + totalHobbies == 0) return 0.0;

    return ((matchingInterests + matchingHobbies) /
            (totalInterests + totalHobbies)) *
        100;
  }

  // Helper method to calculate compatibility score (optional)
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371.0; // Earth's radius in kilometers
  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _toRadians(double degree) {
  return degree * pi / 180;
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

void showImagePreview(String imageUrl, context) {
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
