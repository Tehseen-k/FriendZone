import 'dart:io';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:code_structure/ui/screens/home_screen/home_veiw_model.dart';
import 'package:flutter/material.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';

class EditGroupScreen extends StatefulWidget {
  final Group group;
  final User currentUser;

  const EditGroupScreen({
    required this.group,
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _radiusController;
  List<String> _interests = [];
  List<String> _hobbies = [];
  String? _newGroupImageKey;
  bool _isLoading = false;
  bool _isUploading = false;
  String? _selectedImagePath;

  // Predefined lists
  final List<String> _availableInterests = [
    'Sports', 'Music', 'Art', 'Technology', 'Gaming',
    'Reading', 'Travel', 'Food', 'Fashion', 'Movies',
    'Photography', 'Fitness', 'Dance', 'Cooking', 'Nature',
    'Science', 'History', 'Languages', 'Pets', 'Cars'
  ];

  final List<String> _availableHobbies = [
    'Football', 'Basketball', 'Tennis', 'Guitar', 'Piano',
    'Painting', 'Programming', 'Writing', 'Hiking', 'Swimming',
    'Yoga', 'Meditation', 'Gardening', 'Chess', 'Singing',
    'Dancing', 'Photography', 'Cycling', 'Running', 'Cooking'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
    _descriptionController = TextEditingController(text: widget.group.description);
    _locationController = TextEditingController(text: widget.group.locationName);
    _radiusController = TextEditingController(text: widget.group.allowedRadius.toString());
    _interests = List.from(widget.group.interests ?? []);
    _hobbies = List.from(widget.group.hobbies ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: false,
        withReadStream: true,
      );

      if (result != null) {
        setState(() {
          _selectedImagePath = result.files.first.path;
        });
        
        // Upload the image
        await _uploadGroupImage(result.files.first);
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  Future<void> _uploadGroupImage(PlatformFile file) async {
    try {
      setState(() => _isUploading = true);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final key = 'group_images/${widget.group.id}/$timestamp-${file.name}';

      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromStream(file.readStream!, size: file.size),
        path:StoragePath.fromString(key) ,
        options: StorageUploadFileOptions(
        //  accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3UploadFilePluginOptions(),
        ),
        onProgress: (progress) {
          print('Upload progress: ${progress.fractionCompleted * 100}%');
        },
      ).result;

      setState(() => _newGroupImageKey = key);
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _saveGroup() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final updatedGroup = widget.group.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        locationName: _locationController.text,
        allowedRadius: double.parse(_radiusController.text),
        interests: _interests,
        hobbies: _hobbies,
        groupImageKey: _newGroupImageKey ?? widget.group.groupImageKey,
      );

      await Amplify.API.mutate(
        request: ModelMutations.update(updatedGroup),
      ).response;

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Group updated successfully')),
        );
      }
    } catch (e) {
      print('Error updating group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update group')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSelectionDialog(bool isInterests) {
    final availableItems = isInterests 
        ? _availableInterests.where((i) => !_interests.contains(i)).toList()
        : _availableHobbies.where((h) => !_hobbies.contains(h)).toList();
    
    final currentItems = isInterests ? _interests : _hobbies;
    final title = isInterests ? 'Interests' : 'Hobbies';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select $title',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'Current $title',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: currentItems.map((item) => Chip(
                label: Text(item),
                onDeleted: () {
                  setState(() {
                    if (isInterests) {
                      _interests.remove(item);
                    } else {
                      _hobbies.remove(item);
                    }
                  });
                },
                backgroundColor: primaryColor.withOpacity(0.1),
                deleteIconColor: Colors.red,
              )).toList(),
            ),
            SizedBox(height: 16.h),
            Text(
              'Available $title',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemCount: availableItems.length,
                itemBuilder: (context, index) {
                  final item = availableItems[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isInterests) {
                          _interests.add(item);
                        } else {
                          _hobbies.add(item);
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Group'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBasicInfo(),
                          SizedBox(height: 24.h),
                          _buildLocationInfo(),
                          SizedBox(height: 24.h),
                          _buildTagsSection(),
                          SizedBox(height: 32.h),
                          _buildSubmitButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildGroupImage(),
          SizedBox(height: 16.h),
          Text(
            'Edit Group Details',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: (_isLoading || _isUploading) ? null : _saveGroup,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 2,
        ),
        child: _isLoading || _isUploading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests & Hobbies',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildTagButton(
                'Interests',
                _interests.length,
                () => _showSelectionDialog(true),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildTagButton(
                'Hobbies',
                _hobbies.length,
                () => _showSelectionDialog(false),
              ),
            ),
          ],
        ),
        if (_interests.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _interests.map((interest) => Chip(
              label: Text(interest),
              backgroundColor: primaryColor.withOpacity(0.1),
              onDeleted: () {
                setState(() => _interests.remove(interest));
              },
            )).toList(),
          ),
        ],
        if (_hobbies.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _hobbies.map((hobby) => Chip(
              label: Text(hobby),
              backgroundColor: Colors.green.withOpacity(0.1),
              onDeleted: () {
                setState(() => _hobbies.remove(hobby));
              },
            )).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildTagButton(String title, int count, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 150.w,
            height: 150.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: _selectedImagePath != null
                ? ClipOval(
                    child: Image.file(
                      File(_selectedImagePath!),
                      fit: BoxFit.cover,
                    ),
                  )
                : widget.group.groupImageKey != null
                    ? FutureBuilder<String>(
                        future: getFileUrl(widget.group.groupImageKey!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ClipOval(
                              child: Image.network(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                          return Icon(Icons.group, size: 64.sp, color: Colors.grey);
                        },
                      )
                    : Icon(Icons.group, size: 64.sp, color: Colors.grey),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: primaryColor,
              child: IconButton(
                icon: Icon(
                  _isUploading ? Icons.hourglass_empty : Icons.camera_alt,
                  color: Colors.white,
                ),
                onPressed: _isUploading ? null : _pickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Group Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter a group name';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Location Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter a location';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _radiusController,
          decoration: InputDecoration(
            labelText: 'Allowed Radius (km)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter allowed radius';
            }
            if (double.tryParse(value!) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }
}