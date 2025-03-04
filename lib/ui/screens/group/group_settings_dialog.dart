import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'dart:io';

class GroupSettingsDialog extends StatefulWidget {
  final Group group;
  final VoidCallback onGroupUpdated;

  const GroupSettingsDialog({
    required this.group,
    required this.onGroupUpdated,
    Key? key,
  }) : super(key: key);

  @override
  State<GroupSettingsDialog> createState() => _GroupSettingsDialogState();
}

class _GroupSettingsDialogState extends State<GroupSettingsDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late double _allowedRadius;
  List<String> _interests = [];
  List<String> _hobbies = [];
  File? _newGroupImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
    _descriptionController = TextEditingController(text: widget.group.description);
    _locationController = TextEditingController(text: widget.group.locationName);
    _allowedRadius = widget.group.allowedRadius;
    _interests = List.from(widget.group.interests ?? []);
    _hobbies = List.from(widget.group.hobbies ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: 0.9.sw,
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildGroupImageSection(),
                _buildFormFields(),
                _buildInterestsSection(),
                _buildHobbiesSection(),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Group Settings',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Manage your group details',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildGroupImageSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 120.h,
          width: 120.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: _newGroupImage != null
                ? DecorationImage(
                    image: FileImage(_newGroupImage!),
                    fit: BoxFit.cover,
                  )
                : widget.group.groupImageKey != null
                    ? DecorationImage(
                        image: NetworkImage(widget.group.groupImageKey!),
                        fit: BoxFit.cover,
                      )
                    : null,
            color: Colors.grey[200],
          ),
          child: (_newGroupImage == null && widget.group.groupImageKey == null)
              ? Icon(Icons.group, size: 48.sp, color: Colors.grey[400])
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: primaryColor,
            child: IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.white),
              onPressed: _pickImage,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        SizedBox(height: 16.h),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Group Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
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
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Location',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Text('Allowed Radius: ${_allowedRadius.toStringAsFixed(1)} km'),
            Expanded(
              child: Slider(
                value: _allowedRadius,
                min: 1,
                max: 100,
                divisions: 99,
                label: '${_allowedRadius.toStringAsFixed(1)} km',
                onChanged: (value) {
                  setState(() => _allowedRadius = value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ..._interests.map((interest) => Chip(
              label: Text(interest),
              onDeleted: () {
                setState(() => _interests.remove(interest));
              },
            )),
            ActionChip(
              label: Icon(Icons.add),
              onPressed: () => _showAddItemDialog('Interest', _interests),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHobbiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hobbies',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ..._hobbies.map((hobby) => Chip(
              label: Text(hobby),
              onDeleted: () {
                setState(() => _hobbies.remove(hobby));
              },
            )),
            ActionChip(
              label: Icon(Icons.add),
              onPressed: () => _showAddItemDialog('Hobby', _hobbies),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _showDeleteConfirmation,
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: Text('Delete Group'),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            SizedBox(width: 8.w),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Save Changes'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    // if (pickedFile != null) {
    //   setState(() => _newGroupImage = File(pickedFile.path));
    // }
  }

  Future<void> _showAddItemDialog(String type, List<String> items) async {
    final controller = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $type'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter $type',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => items.add(result));
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? newImageKey;
      if (_newGroupImage != null) {
        // final key = 'group-images/${DateTime.now().millisecondsSinceEpoch}.jpg';
        // await Amplify.Storage.uploadFile(
        //   local: _newGroupImage!,
        //   key: key,
        //   options: StorageUploadFileOptions(
        //     accessLevel: StorageAccessLevel.public,
        //   ),
        // ).result;
        // newImageKey = key;
      }

      final updatedGroup = widget.group.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        locationName: _locationController.text,
        allowedRadius: _allowedRadius,
        interests: _interests,
        hobbies: _hobbies,
        groupImageKey: newImageKey ?? widget.group.groupImageKey,
      );

      await Amplify.API.mutate(
        request: ModelMutations.update(updatedGroup),
      ).response;

      widget.onGroupUpdated();
      Navigator.pop(context);
    } catch (e) {
      print('Error updating group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update group')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Group'),
        content: Text('Are you sure you want to delete this group? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: _deleteGroup,
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteGroup() async {
    try {
      await Amplify.API.mutate(
        request: ModelMutations.delete(widget.group),
      ).response;

      Navigator.of(context)
        ..pop() // Close confirmation dialog
        ..pop() // Close settings dialog
        ..pop(); // Close group screen
    } catch (e) {
      print('Error deleting group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete group')),
      );
    }
  }
} 