// ignore_for_file: unused_field, prefer_final_fields, unused_element

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:code_structure/core/constants/auth_text_feild.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/buttons/custom_button.dart';
import 'package:code_structure/main.dart';
import 'package:code_structure/ui/screens/setup_profile/locationSlectionWidget.dart';
import 'package:code_structure/ui/screens/root_screen/root_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';

import '../../../models/ModelProvider.dart';

class SetupProfileScreen extends StatefulWidget {
  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  String _name = '';
  String _email = '';
  List<String> _interests = [];
  List<String> _hobbies = [];
  bool _isLoading = true;
  User? _userModel;
  String? _profileImageKey;
  List<String> _userImageKeys = [];
  String? _profileVideoKey;
  bool _isUploading = false;
  VideoPlayerController? _videoController;
  List<String> _videoKeys = [];
  Map<String, VideoPlayerController> _videoControllers = {};
  bool _visibleToMatchesOnly = true;

  bool _showAllInterests = false;
  TextEditingController _interestController = TextEditingController();
  String _currentLocation = '';
  bool _showAllHobbies = false;
  TextEditingController _hobbyController = TextEditingController();

  TextEditingController _introductionController = TextEditingController();
  double? _latitude;
  double? _longitude;

  // Add new state variable
  bool _isLoadingLocation = false;

  final List<String> _availableInterests = [
    'Hiking', 'Reading', 'Cooking', 'Gaming', 'Travel',
    'Photography', 'Music', 'Sports', 'Art', 'Movies',
    'Dancing', 'Yoga', 'Fashion', 'Technology', 'Food',
    // Add more interests
  ];

  final List<String> _availableHobbies = [
    'Painting',
    'Writing',
    'Gardening',
    'Chess',
    'Swimming',
    'Cycling',
    'Pottery',
    'Singing',
    'Dancing',
    'Photography',
    'Baking',
    'Woodworking',
    'Knitting',
    'Fishing',
    'Meditation',
    'Bird Watching',
    'Collecting',
    'DIY',
    'Astronomy',
    'Volunteering'
  ];

  // Get current user ID
  Future<String> _getUserId() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user.userId;
  }

  // Upload file to user-specific S3 path
  Future<String?> _uploadFile(PlatformFile file,
      {bool isProfileImage = false}) async {
    try {
      final userId = await _getUserId();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      print("hereee 2");
      // Generate unique file path
      final filePath = isProfileImage
          ? 'public/$userId/profile/$timestamp-${file.name}'
          : 'public/$userId/uploads/$timestamp-${file.name}';
      print("hereee 3");
      setState(() => _isUploading = true);

      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromStream(file.readStream!, size: file.size),
        path: StoragePath.fromString(filePath),
        options: StorageUploadFileOptions(
            pluginOptions: S3UploadFilePluginOptions()),
        onProgress: (progress) {
          print('Upload progress: ${progress.fractionCompleted * 100}%');
        },
      ).result;

      return result.uploadedItem.path;
    } on StorageException catch (e) {
      print('Upload error: ${e.message}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload failed: ${e.message}')));
      return null;
    } finally {
      setState(() => _isUploading = false);
    }
  }

  // Get temporary access URL for uploaded files
  Future<String> _getFileUrl(String fileKey) async {
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

  Future<void> _uploadProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: false,
      withReadStream: true,
    );

    if (result != null) {
      print("hereee 1");
      final fileKey =
          await _uploadFile(result.files.first, isProfileImage: true);
      if (fileKey != null) {
        setState(() => _profileImageKey = fileKey);
      }
    }
  }

  Future<void> _uploadUserImages() async {
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
          setState(() => _userImageKeys.add(fileKey));
        }
      }
    }
  }

  Future<void> _uploadVideos() async {
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
          setState(() => _videoKeys.add(fileKey));
          final videoUrl = await _getFileUrl(fileKey);
          await _initializeVideoController(fileKey, videoUrl);
        }
      }
    }
  }

  Future<void> _initializeVideoController(
      String videoKey, String videoUrl) async {
    final controller = VideoPlayerController.network(videoUrl);
    await controller.initialize();
    setState(() {
      _videoControllers[videoKey] = controller;
    });
  }

  Future<void> createUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final userId = user.userId;
      final userModell = User(
        id: userId,
        username: _name,
        email: _email,
        createdAt: TemporalDateTime(DateTime.now()),
        updatedAt: TemporalDateTime(DateTime.now()),
        interests: _interests,
        hobbies: _hobbies,
        introduction: _introductionController.text,
        visible: _visibleToMatchesOnly,
        profileImageKey: _profileImageKey,
        userImageKeys: _userImageKeys,
        profileVideoKey: _videoKeys,
        address: _currentLocation,
        latitude: _latitude,
        longitude: _longitude,
      );
      final request = ModelMutations.create(userModell,
          authorizationMode: APIAuthorizationType.apiKey);
      final response = await Amplify.API.mutate(request: request).response;

      final createdUser = response.data;
      print("response ${response.data}");
      if (createdUser == null) {
        _showToast('Error creating profile', isError: true);
        safePrint('errors: ${response.errors}');
      } else {
        safePrint('Mutation result: ${createdUser.createdAt}');
        _showToast('Profile created successfully!', isError: false);
        userModel = createdUser;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RootScreen()));
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      _showToast('Error creating profile: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> updateUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      print("hereee 1");
      final updatedUser = _userModel?.copyWith(
        updatedAt: TemporalDateTime(DateTime.now()),
        profileImageKey: _profileImageKey,
        userImageKeys: _userImageKeys,
        profileVideoKey: _videoKeys,
        address: _currentLocation,
        latitude: _latitude,
        longitude: _longitude,
        interests: _interests,
        hobbies: _hobbies,
        introduction: _introductionController.text,
        visible: _visibleToMatchesOnly,
      );
      print("hereee 2");
      final request = ModelMutations.update(updatedUser!);
      print("hereee 3 ");
      final response = await Amplify.API.mutate(request: request).response;
      safePrint('Response: ${response.data}....error ${response.errors}');
      if (response.data == null) {
        _showToast('Error updating profile', isError: true);
      } else {
        userModel = response.data;
        _showToast('Profile updated successfully!', isError: false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RootScreen()));
      }
    } catch (e) {
      print("error occured $e");
      _showToast('Error updating profile: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future getUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    try {
      _email = user.userId;
      final attributes = await Amplify.Auth.fetchUserAttributes();
      for (final attribute in attributes) {
        if (attribute.userAttributeKey == CognitoUserAttributeKey.name) {
          _name = attribute.value;
        }
        if (attribute.userAttributeKey == CognitoUserAttributeKey.email) {
          _email = attribute.value;
        }
      }
      print("user ${user.userId}");

      final request = ModelQueries.get(
        User.classType,
        UserModelIdentifier(id: user.userId),
      );
      final response = await Amplify.API.query(request: request).response;
      final data = response.data;
      print("user here  ${response.data}");
      _userModel = data;
      userModel = _userModel;
      if (data == null) {
        safePrint('errors: ${response.errors}');
      } else {
        _interests = _userModel?.interests ?? [];
        _hobbies = _userModel?.hobbies ?? [];
        _introductionController.text = _userModel?.introduction ?? '';
        _visibleToMatchesOnly = _userModel?.visible ?? true;
        _profileImageKey = _userModel?.profileImageKey ?? null;
        _userImageKeys = _userModel?.userImageKeys ?? [];
        _videoKeys = _userModel?.profileVideoKey ?? [];
        _latitude = _userModel?.latitude ?? null;
        _longitude = _userModel?.longitude ?? null;
        _currentLocation = _userModel?.address ?? '';
      }
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // Show dialog explaining why we need location permission
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Location Permission Required'),
            content: Text(
                'This app needs access to location to show your current city in your profile. Would you like to grant permission?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Grant Permission'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  permission = await Geolocator.requestPermission();
                  if (permission == LocationPermission.denied) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Location permission denied')));
                    return;
                  }
                  // If permission granted, get location
                  if (permission == LocationPermission.whileInUse ||
                      permission == LocationPermission.always) {
                    _getLocationData();
                  }
                },
              ),
            ],
          ),
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Location Permission Required'),
            content: Text(
                'Location permission is permanently denied. Please enable it in your device settings.'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Open Settings'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openAppSettings();
                },
              ),
            ],
          ),
        );
        return;
      }

      await _getLocationData();
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error getting location: $e')));
    }
  }

  Future<void> _getLocationData() async {
    setState(() => _isLoadingLocation = true);
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentLocation =
              '${place.locality ?? ''}, ${place.country ?? ''}'.trim();
          if (_currentLocation.startsWith(',')) {
            _currentLocation = _currentLocation.substring(2);
          }
        });
        _showToast('Location updated successfully!', isError: false);
      }
    } catch (e) {
      _showToast('Error getting location: $e', isError: true);
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  void _handleInterestInput(String value) {
    value = value.trim();
    if (value.isEmpty) return;

    if (_availableInterests.contains(value)) {
      if (!_interests.contains(value)) {
        setState(() {
          _interests.add(value);
        });
      }
    } else {
      setState(() {
        _availableInterests.add(value);
        _interests.add(value);
      });
    }
    _interestController.clear();
  }

  void _handleHobbyInput(String value) {
    value = value.trim();
    if (value.isEmpty) return;

    if (_availableHobbies.contains(value)) {
      if (!_hobbies.contains(value)) {
        setState(() {
          _hobbies.add(value);
        });
      }
    } else {
      setState(() {
        _availableHobbies.add(value);
        _hobbies.add(value);
      });
    }
    _hobbyController.clear();
  }

  Future<void> _signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    _introductionController.dispose();
    _videoController?.dispose();
    _videoControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CircularProgressIndicator(
        color: Colors.deepOrange,
      ),
      child: Scaffold(
        ///
        /// App Bar
        ///
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Setup Profile",
            style: style24B.copyWith(color: blackColor),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: _signOut,
            ),
          ],
        ),

        ///
        /// Start Body
        ///
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroductionSection(),
                  SizedBox(height: 20),
                  _buildProfileImageSection(),
                  SizedBox(height: 20),
                  _buildUserImagesSection(),
                  SizedBox(height: 20),
                  _buildVideoSection(),
                  SizedBox(height: 20),
                  _buildVideoPreview(),
                  10.verticalSpace,
                  _buildInterestsSection(),
                  _buildHobbiesSection(),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Profile Preferences",
                      style: style16B.copyWith(color: blackColor),
                    ),
                  ),
                  10.verticalSpace,
                  TextFormField(
                    onFieldSubmitted: (value) {
                      _interests.add(value);
                    },
                    decoration: authFieldDecoration.copyWith(
                        hintText:
                            "Looking for Friends, Interested in Events, Show Compatibility Score",
                        hintStyle: style14B.copyWith(color: greyColor),
                        fillColor: blackColor.withOpacity(0.04)),
                  ),
                  // 20.verticalSpace,
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 5.0),
                  //   child: Text(
                  //     "Select Interests",
                  //     style: style16B.copyWith(color: blackColor),
                  //   ),
                  // ),

                  20.verticalSpace,
                  _buildVisibilitySettings(),
                  _buildLocationSection(),
                  CustomButton(
                    name: "Submit",
                    onPressed: () {
                      if (_userModel == null) {
                        createUser();
                      } else {
                        updateUser();
                      }
                    },
                    textColor: whiteColor,
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroductionSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Introduce Yourself",
            style: style18B,
          ),
          SizedBox(height: 8),
          Text(
            "Tell others about yourself and what makes you unique",
            style: style14B.copyWith(color: greyColor),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: _introductionController,
              maxLines: 4,
              maxLength: 500,
              decoration: authFieldDecoration.copyWith(
                hintText:
                    "Share your interests, hobbies, and what you're looking for...",
                hintStyle: style14B.copyWith(color: greyColor),
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile Photo', style: style18B),
        SizedBox(height: 8),
        Text(
          "Add a photo that clearly shows your face",
          style: style14B.copyWith(color: greyColor),
        ),
        SizedBox(height: 16),
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: _profileImageKey != null
                    ? () => _showImagePreview(_profileImageKey!)
                    : _uploadProfileImage,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2)
                    ],
                  ),
                  child: _profileImageKey != null
                      ? FutureBuilder<String>(
                          future: _getFileUrl(_profileImageKey!),
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
                          backgroundColor: Colors.grey[100],
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: primaryColor,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _uploadProfileImage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1)
                      ],
                    ),
                    child: Icon(
                      _profileImageKey != null ? Icons.edit : Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_profileImageKey != null)
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _profileImageKey = null;
                });
              },
              child: Text(
                'Remove Photo',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Photo Gallery",
                style: style18B,
              ),
              TextButton.icon(
                onPressed: _uploadUserImages,
                icon: Icon(Icons.add_photo_alternate, color: primaryColor),
                label: Text(
                  'Add Photos',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
        ),
        Text(
          "Add up to 6 photos to showcase your personality",
          style: style14B.copyWith(color: greyColor),
        ),
        SizedBox(height: 12),
        _buildUserImagesGrid(),
      ],
    );
  }

  Widget _buildUserImagesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _userImageKeys.length + 1,
      itemBuilder: (context, index) {
        if (index == _userImageKeys.length) {
          return GestureDetector(
            onTap: _uploadUserImages,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor, width: 1),
              ),
              child: Icon(Icons.add_photo_alternate, color: primaryColor),
            ),
          );
        }
        return FutureBuilder(
          future: _getFileUrl(_userImageKeys[index]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return GestureDetector(
              onTap: () => _showImagePreview(snapshot.data!),
              child: Hero(
                tag: _userImageKeys[index],
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(snapshot.data!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVisibilitySettings() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Visibility Settings",
            style: style18B,
          ),
          SizedBox(height: 8),
          Text(
            "Control who can view your profile",
            style: style14B.copyWith(color: greyColor),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: SwitchListTile(
              title: Text(
                "Visible to Matches Only",
                style: style16B,
              ),
              subtitle: Text(
                "Only people you've matched with can view your full profile",
                style: TextStyle(color: greyColor),
              ),
              value: _visibleToMatchesOnly,
              onChanged: (bool value) {
                setState(() {
                  _visibleToMatchesOnly = value;
                });
              },
              activeColor: primaryColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          if (_visibleToMatchesOnly)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0),
              child: Text(
                "✓ Enhanced privacy and security",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
            ),
        ],
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

  Widget _buildVideoPreview() {
    if (_videoController == null) return Container();
    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_videoController!),
          IconButton(
            icon: Icon(
              _videoController!.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _videoController!.value.isPlaying
                    ? _videoController!.pause()
                    : _videoController!.play();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Personal Interests", style: style16B.copyWith(color: blackColor)),
        SizedBox(height: 10),
        TextField(
          controller: _interestController,
          onSubmitted: _handleInterestInput,
          decoration: authFieldDecoration.copyWith(
            hintText: "Add your interests",
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _handleInterestInput(_interestController.text),
            ),
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: _interests
              .map((interest) => Chip(
                    label: Text(interest),
                    onDeleted: () {
                      setState(() => _interests.remove(interest));
                    },
                  ))
              .toList(),
        ),
        SizedBox(height: 20),
        Text("Available Interests", style: style14B.copyWith(color: greyColor)),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: _availableInterests
              .take(_showAllInterests ? _availableInterests.length : 12)
              .map((interest) => InkWell(
                    onTap: () => _handleInterestInput(interest),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _interests.contains(interest)
                            ? Colors.orange
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(interest,
                          style: TextStyle(
                            color: _interests.contains(interest)
                                ? Colors.white
                                : Colors.black,
                          )),
                    ),
                  ))
              .toList(),
        ),
        if (_availableInterests.length > 12)
          TextButton(
            onPressed: () {
              setState(() => _showAllInterests = !_showAllInterests);
            },
            child: Text(_showAllInterests ? 'Show Less' : 'See More'),
          ),
      ],
    );
  }

  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Profile Videos",
                style: style18B,
              ),
              TextButton.icon(
                onPressed: _uploadVideos,
                icon: Icon(Icons.video_call, color: primaryColor),
                label: Text(
                  'Add Video',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
        ),
        if (_videoKeys.isEmpty)
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.video_library, size: 48, color: primaryColor),
                  SizedBox(height: 8),
                  Text(
                    'Upload videos to showcase yourself',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        if (_videoKeys.isNotEmpty)
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _videoKeys.length,
              itemBuilder: (context, index) {
                final videoKey = _videoKeys[index];
                final controller = _videoControllers[videoKey];

                if (controller == null) return Container();

                return Container(
                  width: 200,
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        ),
                      ),
                      Positioned.fill(
                        child: Material(
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
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deleteVideo(videoKey),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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

  void _deleteVideo(String videoKey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Video'),
        content: Text('Are you sure you want to delete this video?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                _videoKeys.remove(videoKey);
                _videoControllers[videoKey]?.dispose();
                _videoControllers.remove(videoKey);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHobbiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hobbies", style: style16B.copyWith(color: blackColor)),
        SizedBox(height: 10),
        TextField(
          controller: _hobbyController,
          onSubmitted: _handleHobbyInput,
          decoration: authFieldDecoration.copyWith(
            hintText: "Add your hobbies",
            suffixIcon: IconButton(
              icon: Icon(Icons.add, color: Colors.purple),
              onPressed: () => _handleHobbyInput(_hobbyController.text),
            ),
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: _hobbies
              .map((hobby) => Chip(
                    label: Text(hobby),
                    onDeleted: () {
                      setState(() => _hobbies.remove(hobby));
                    },
                    backgroundColor: Colors.purple[100],
                    deleteIconColor: Colors.purple,
                    labelStyle: TextStyle(color: Colors.purple[900]),
                  ))
              .toList(),
        ),
        SizedBox(height: 20),
        Text("Available Hobbies", style: style14B.copyWith(color: greyColor)),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: _availableHobbies
              .take(_showAllHobbies ? _availableHobbies.length : 12)
              .map((hobby) => InkWell(
                    onTap: () => _handleHobbyInput(hobby),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _hobbies.contains(hobby)
                            ? Colors.purple
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _hobbies.contains(hobby)
                              ? Colors.purple
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(hobby,
                          style: TextStyle(
                            color: _hobbies.contains(hobby)
                                ? Colors.white
                                : Colors.black87,
                          )),
                    ),
                  ))
              .toList(),
        ),
        if (_availableHobbies.length > 12)
          TextButton.icon(
            onPressed: () {
              setState(() => _showAllHobbies = !_showAllHobbies);
            },
            icon: Icon(
              _showAllHobbies ? Icons.expand_less : Icons.expand_more,
              color: Colors.purple,
            ),
            label: Text(
              _showAllHobbies ? 'Show Less' : 'See More',
              style: TextStyle(color: Colors.purple),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return LocationSelectionWidget(
      initialLocation: _currentLocation,
      onLocationSelected: (lat, lon, address) {
        setState(() {
          _latitude = lat;
          _longitude = lon;
          _currentLocation = address;
        });
      },
    );
  }

  // Add toast helper method
  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                isError ? Icons.error : Icons.check_circle,
                color: Colors.white,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red.shade800 : Colors.blue.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
