import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/constants/auth_text_feild.dart';
import 'package:code_structure/custom_widgets/buttons/custom_button.dart';
import 'create_group_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateGroupViewModel(),
      child: _CreateGroupView(),
    );
  }
}

class _CreateGroupView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  BoxDecoration get gradientDecoration => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withOpacity(0.05),
        Colors.white,
        primaryColor.withOpacity(0.05),
      ],
    ),
  );

  Future<bool> _checkLocationPermission(BuildContext context) async {
    final status = await Permission.location.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location permission is required to set group location'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateGroupViewModel>();

    return ModalProgressHUD(
      inAsyncCall: viewModel.isLoading || viewModel.isUploading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Group', style: style18B),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: blackColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: gradientDecoration,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGroupImageSection(context),
                  SizedBox(height: 24.h),
                  _buildBasicInfoSection(context),
                  SizedBox(height: 24.h),
                  _buildInterestsSection(context),
                  SizedBox(height: 24.h),
                  _buildHobbiesSection(context),
                  SizedBox(height: 24.h),
                  _buildLocationSection(context),
                  SizedBox(height: 24.h),
                  _buildMediaSection(context),
                  SizedBox(height: 24.h),
                  _buildMembersSection(context),
                  SizedBox(height: 32.h),
                  _buildCreateButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupImageSection(BuildContext context) {
    final viewModel = context.watch<CreateGroupViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Group Photo', style: style18B),
        SizedBox(height: 8.h),
        Text(
          "Add a photo for your group",
          style: style14B.copyWith(color: greyColor),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: viewModel.groupImageKey != null
                    ? () => _showImagePreview(context, viewModel.groupImageKey!)
                    : viewModel.uploadGroupImage,
                child: Container(
                  width: 160.w,
                  height: 160.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: viewModel.groupImageKey != null
                      ? FutureBuilder<String>(
                          future: viewModel.getFileUrl(viewModel.groupImageKey!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Hero(
                                tag: 'groupImage',
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!),
                                  radius: 80.r,
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
                          radius: 80.r,
                          backgroundColor: Colors.grey[100],
                          child: Icon(
                            Icons.group,
                            size: 80.sp,
                            color: primaryColor,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: viewModel.uploadGroupImage,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Icon(
                      viewModel.groupImageKey != null ? Icons.edit : Icons.add,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(BuildContext context) {
    final viewModel = context.watch<CreateGroupViewModel>();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Information', style: style18B),
          SizedBox(height: 16.h),
          TextFormField(
            decoration: authFieldDecoration.copyWith(
              labelText: 'Group Name',
              hintText: 'Enter group name',
              prefixIcon: Icon(Icons.group, color: primaryColor),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter a group name';
              return null;
            },
            onChanged: (value) => viewModel.groupName = value,
          ),
          SizedBox(height: 16.h),
          TextFormField(
            decoration: authFieldDecoration.copyWith(
              labelText: 'Description',
              hintText: 'Enter group description',
              prefixIcon: Icon(Icons.description, color: primaryColor),
            ),
            maxLines: 3,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter a description';
              return null;
            },
            onChanged: (value) => viewModel.description = value,
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection(BuildContext context) {
    final viewModel = context.watch<CreateGroupViewModel>();
    final displayedInterests = viewModel.showAllInterests 
        ? viewModel.availableInterests 
        : viewModel.availableInterests.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Interests', style: style18B),
        SizedBox(height: 8.h),
        Text(
          "Select interests for your group",
          style: style14B.copyWith(color: greyColor),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ...displayedInterests.map((interest) {
              final isSelected = viewModel.selectedInterests.contains(interest);
              return GestureDetector(
                onTap: () => context
                    .read<CreateGroupViewModel>()
                    .toggleInterest(interest),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    interest,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              );
            }),
            if (viewModel.availableInterests.length > 6)
              GestureDetector(
                onTap: () => context
                    .read<CreateGroupViewModel>()
                    .toggleShowAllInterests(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    viewModel.showAllInterests ? 'Show Less' : 'Show More',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildHobbiesSection(BuildContext context) {
    final viewModel = context.watch<CreateGroupViewModel>();
    final displayedHobbies = viewModel.showAllHobbies 
        ? viewModel.availableHobbies 
        : viewModel.availableHobbies.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hobbies', style: style18B),
        SizedBox(height: 8.h),
        Text(
          "Select hobbies for your group",
          style: style14B.copyWith(color: greyColor),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ...displayedHobbies.map((hobby) {
              final isSelected = viewModel.selectedHobbies.contains(hobby);
              return GestureDetector(
                onTap: () => context
                    .read<CreateGroupViewModel>()
                    .toggleHobby(hobby),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    hobby,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              );
            }),
  
          if (viewModel.availableHobbies.length > 6)
              GestureDetector(
                onTap: () => context
                    .read<CreateGroupViewModel>()
                    .toggleShowAllHobbies(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    viewModel.showAllHobbies ? 'Show Less' : 'Show More',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    final viewModel = context.watch<CreateGroupViewModel>();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Location", style: style18B),
          SizedBox(height: 16.h),
          TextFormField(
            readOnly: true,
            controller: TextEditingController(text: viewModel.locationName ?? ''),
            decoration: authFieldDecoration.copyWith(
              prefixIcon: Icon(Icons.location_on, color: primaryColor),
              hintText: "Select Group Location",
              suffixIcon: viewModel.isLoading
                  ? Container(
                      margin: EdgeInsets.all(12),
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.my_location, color: primaryColor),
                      onPressed: () async {
                        if (await _checkLocationPermission(context)) {
                          viewModel.getCurrentLocation();
                        }
                      },
                    ),
            ),
          ),
          SizedBox(height: 16.h),
          Text('Allowed Radius (km)', style: style14B),
          Slider(
            value: viewModel.allowedRadius,
            min: 1,
            max: 1000,
            divisions: 100,
            label: '${viewModel.allowedRadius.round()} km',
            activeColor: primaryColor,
            inactiveColor: primaryColor.withOpacity(0.2),
            onChanged: (value) => viewModel.updateRadius(value),
          ),
          Text(
            '${viewModel.allowedRadius.round()} kilometers',
            style: style14B.copyWith(color: primaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection(BuildContext context) {
    final viewModel = context.watch<CreateGroupViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Group Media', style: style18B),
        SizedBox(height: 8.h),
        Text(
          "Add photos and videos for your group",
          style: style14B.copyWith(color: greyColor),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: viewModel.mediaKeys.length + 1,
          itemBuilder: (context, index) {
            if (index == viewModel.mediaKeys.length) {
              return InkWell(
                onTap: () => viewModel.uploadMediaFiles(),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: greyColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add_photo_alternate, 
                    size: 32.sp,
                    color: primaryColor,
                  ),
                ),
              );
            }

            final mediaKey = viewModel.mediaKeys[index];
            return FutureBuilder<String>(
              future: viewModel.getFileUrl(mediaKey),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _showImagePreview(context, mediaKey),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            viewModel.mediaKeys.removeAt(index);
                            
                            // viewModel.notifyListeners();
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMembersSection(BuildContext context) {
    final viewModel = context.watch<CreateGroupViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Members', style: style18B),
        SizedBox(height: 16.h),
        if (viewModel.nearbyUsers.isEmpty)
          Center(
            child: Text(
              'No nearby users found',
              style: style14B.copyWith(color: greyColor),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: viewModel.nearbyUsers.length,
            itemBuilder: (context, index) {
              final user = viewModel.nearbyUsers[index];
              return CheckboxListTile(
                title: Text(user.username ?? 'Unknown User'),
                subtitle: Text('${user.email}'),
                value: viewModel.selectedMembers.contains(user),
                onChanged: (selected) {
                  if (selected ?? false) {
                    context.read<CreateGroupViewModel>().addMember(user);
                  } else {
                    context.read<CreateGroupViewModel>().removeMember(user);
                  }
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return CustomButton(
      name: 'Create Group',
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          try {
            final viewModel = context.read<CreateGroupViewModel>();
            await viewModel.createGroup();
            Navigator.pop(context);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to create group: $e')),
            );
          }
        }
      },
    );
  }

  void _showImagePreview(BuildContext context, String imageKey) {
    final viewModel = context.read<CreateGroupViewModel>();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              FutureBuilder<String>(
                future: viewModel.getFileUrl(imageKey),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PhotoView(
                      imageProvider: NetworkImage(snapshot.data!),
                      heroAttributes: PhotoViewHeroAttributes(tag: imageKey),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
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
} 