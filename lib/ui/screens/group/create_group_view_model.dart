import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';// import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:place_picker/place_picker.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/models/GroupMember.dart';
import 'package:code_structure/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

class CreateGroupViewModel extends ChangeNotifier {
  String? groupName;
  String? description;
  List<String> interests = [];
  List<String> hobbies = [];
  String? locationName;
  double latitude = 0;
  double longitude = 0;
  double allowedRadius = 50;
  String? groupImageKey;
  List<String> mediaKeys = [];
  List<String> videoKeys = [];
  Map<String, VideoPlayerController> videoControllers = {};
  bool isLoading = false;
  bool isUploading = false;
  Set<User> selectedMembers = {};
  List<User> nearbyUsers = [];

  final List<String> availableInterests = [
    'Hiking', 'Reading', 'Cooking', 'Gaming', 'Travel',
    'Photography', 'Music', 'Sports', 'Art', 'Movies',
    'Dancing', 'Yoga', 'Fashion', 'Technology', 'Food',
  ];

  final List<String> availableHobbies = [
    'Painting', 'Writing', 'Gardening', 'Chess', 'Swimming',
    'Cycling', 'Pottery', 'Singing', 'Dancing', 'Photography',
    'Baking', 'Woodworking', 'Knitting', 'Fishing', 'Meditation',
    'Bird Watching', 'Collecting', 'DIY', 'Astronomy', 'Volunteering'
  ];

  Set<String> selectedInterests = {};
  Set<String> selectedHobbies = {};
  bool showAllInterests = false;
  bool showAllHobbies = false;

  CreateGroupViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    isLoading = true;
    notifyListeners();

    await _loadNearbyUsers();

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadNearbyUsers() async {
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
      }).map((user) => user!).toList();

      notifyListeners();
    } catch (e) {
      print('Error loading nearby users: $e');
    }
  }

  void addInterest(String interest) {
    interests.add(interest);
    notifyListeners();
  }

  void removeInterest(String interest) {
    interests.remove(interest);
    notifyListeners();
  }

  void addHobby(String hobby) {
    hobbies.add(hobby);
    notifyListeners();
  }

  void removeHobby(String hobby) {
    hobbies.remove(hobby);
    notifyListeners();
  }

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
    notifyListeners();
  }

  void toggleHobby(String hobby) {
    if (selectedHobbies.contains(hobby)) {
      selectedHobbies.remove(hobby);
    } else {
      selectedHobbies.add(hobby);
    }
    notifyListeners();
  }

  void toggleShowAllInterests() {
    showAllInterests = !showAllInterests;
    notifyListeners();
  }

  void toggleShowAllHobbies() {
    showAllHobbies = !showAllHobbies;
    notifyListeners();
  }

  // Future<void> pickLocation(BuildContext context) async {
  //   try {
  //     LocationResult? result = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PlacePicker(
  //           "YOUR_GOOGLE_MAPS_API_KEY", // Replace with your API key
  //           displayLocation: LatLng(latitude, longitude),
  //         ),
  //       ),
  //     );

  //     if (result != null) {
  //       latitude = result.latLng!.latitude;
  //       longitude = result.latLng!.longitude;
  //       locationName = result.formattedAddress;
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print('Error picking location: $e');
  //   }
  // }

  // Future<void> pickMedia() async {
  //   try {
  //     final picker = ImagePicker();
  //     final result = await picker.pickImage(source: ImageSource.gallery);
      
  //     if (result != null) {
  //       mediaKeys.add(result.path);
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print('Error picking media: $e');
  //   }
  // }

  void removeMedia(int index) {
    mediaKeys.removeAt(index);
    notifyListeners();
  }

  void addMember(User user) {
    selectedMembers.add(user);
    notifyListeners();
  }

  void removeMember(User user) {
    selectedMembers.remove(user);
    notifyListeners();
  }

  String getDistanceText(User user) {
    if (user.latitude == null || user.longitude == null) return 'Distance unknown';
    
    final distance = Geolocator.distanceBetween(
      latitude,
      longitude,
      user.latitude!,
      user.longitude!,
    );

    final km = (distance / 1000).round();
    return '$km km away';
  }

  Future<void> createGroup() async {
    if (groupName == null || description == null || locationName == null) {
      throw Exception('Required fields are missing');
    }

    isLoading = true;
    notifyListeners();

    try {
      // Upload media files
      for (var fileKey in mediaKeys) {
        await getFileUrl(fileKey);
      }

      // Create group
      final group = Group(
        name: groupName!,
        description: description!,
        interests: interests,
        hobbies: hobbies,
        latitude: latitude,
        longitude: longitude,
        allowedRadius: allowedRadius,
        locationName: locationName,
        mediaKeys: mediaKeys,
        groupImageKey: groupImageKey,
        admin: userModel!,
        createdAt: TemporalDateTime(DateTime.now()),
      );

      final createGroupResponse = await Amplify.API.mutate(
        request: ModelMutations.create(group),
      ).response;

      final createdGroup = createGroupResponse.data;
      if (createdGroup == null) throw Exception('Failed to create group');

      // Add members
      await Future.wait([
        // Add admin as member
        _createGroupMember(createdGroup, userModel!, 'admin'),
        // Add selected members
        ...selectedMembers.map((user) => 
          _createGroupMember(createdGroup, user, 'member')
        ),
      ]);

    } catch (e) {
      print('Error creating group: $e');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> _uploadFile(PlatformFile file, {bool isGroupImage = false}) async {
    try {
      final userId = await _getUserId();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      final filePath = isGroupImage
          ? 'public/$userId/groups/profile/$timestamp-${file.name}'
          : 'public/$userId/groups/media/$timestamp-${file.name}';

      isUploading = true;
      notifyListeners();

      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromStream(file.readStream!, size: file.size),
        path: StoragePath.fromString(filePath),
        options: StorageUploadFileOptions(
          pluginOptions: S3UploadFilePluginOptions(),
        ),
        onProgress: (progress) {
          print('Upload progress: ${progress.fractionCompleted * 100}%');
        },
      ).result;

      return result.uploadedItem.path;
    } catch (e) {
      print('Upload error: $e');
      return null;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  Future<String> getFileUrl(String fileKey) async {
    final result = await Amplify.Storage.getUrl(
      path: StoragePath.fromString(fileKey),
      options: StorageGetUrlOptions(
        pluginOptions: S3GetUrlPluginOptions(
          expiresIn: Duration(days: 7),
          validateObjectExistence: true,
        ),
      ),
    ).result;
    return result.url.toString();
  }

  Future<void> uploadGroupImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: false,
      withReadStream: true,
    );

    if (result != null) {
      final fileKey = await _uploadFile(result.files.first, isGroupImage: true);
      if (fileKey != null) {
        groupImageKey = fileKey;
        notifyListeners();
      }
    }
  }

  Future<void> uploadMediaFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: false,
      withReadStream: true,
    );

    if (result != null) {
      for (final file in result.files) {
        final fileKey = await _uploadFile(file);
        if (fileKey != null) {
          mediaKeys.add(fileKey);
          notifyListeners();
        }
      }
    }
  }

  Future<void> uploadVideos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
      withData: false,
      withReadStream: true,
    );

    if (result != null) {
      for (final file in result.files) {
        final fileKey = await _uploadFile(file);
        if (fileKey != null) {
          videoKeys.add(fileKey);
          final videoUrl = await getFileUrl(fileKey);
          await _initializeVideoController(fileKey, videoUrl);
          notifyListeners();
        }
      }
    }
  }

  Future<void> _initializeVideoController(String videoKey, String videoUrl) async {
    final controller = VideoPlayerController.network(videoUrl);
    await controller.initialize();
    videoControllers[videoKey] = controller;
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading = true;
      notifyListeners();

      final position = await Geolocator.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;

      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        locationName = '${place.locality}, ${place.administrativeArea}';
      }

      await _loadNearbyUsers();
    } catch (e) {
      print('Error getting location: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _createGroupMember(Group group, User user, String role) async {
    final member = GroupMember(
      group: group,
      user: user,
      role: role,
      status: 'active',
      joinedAt: TemporalDateTime(DateTime.now()),
    );

    await Amplify.API.mutate(
      request: ModelMutations.create(member),
    ).response;
  }

  Future<String> _getUserId() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user.userId;
  }

  @override
  void dispose() {
    for (var controller in videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void updateRadius(double value) {
    allowedRadius = value;
    notifyListeners();
  }
} 