import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/models/GroupMember.dart';

class ManageMembersDialog extends StatefulWidget {
  final Group group;
  final List<GroupMember> currentMembers;
  final Function(List<User>) onMembersAdded;
  final Function(GroupMember) onMemberRemoved;

  const ManageMembersDialog({
    required this.group,
    required this.currentMembers,
    required this.onMembersAdded,
    required this.onMemberRemoved,
    Key? key,
  }) : super(key: key);

  @override
  State<ManageMembersDialog> createState() => _ManageMembersDialogState();
}

class _ManageMembersDialogState extends State<ManageMembersDialog> {
  List<User> _nearbyUsers = [];
  List<User> _selectedUsers = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNearbyUsers();
  }

  Future<void> _loadNearbyUsers() async {
    try {
      setState(() => _isLoading = true);

      // Query users within the group's allowed radius
      final request = ModelQueries.list(
        User.classType,
        where: User.VISIBLE.eq(true),
      );

      final response = await Amplify.API.query(request: request).response;
      final allUsers = response.data?.items.whereType<User>().toList() ?? [];

      // Filter out existing members
      final existingMemberIds = widget.currentMembers.map((m) => m.user.id).toSet();
      _nearbyUsers = allUsers.where((user) {
        if (existingMemberIds.contains(user.id)) return false;

        // Calculate distance between user and group
        final userLat = user.latitude ?? 0;
        final userLng = user.longitude ?? 0;
        final groupLat = widget.group.latitude;
        final groupLng = widget.group.longitude;

        final distance = _calculateDistance(
          userLat, userLng, groupLat, groupLng);

        return distance <= widget.group.allowedRadius;
      }).toList();

    } catch (e) {
      print('Error loading nearby users: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  double _calculateDistance(
    double lat1, double lon1, double lat2, double lon2) {
    // Implement distance calculation (Haversine formula)
    // Return distance in kilometers
    return 0; // Placeholder
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: 0.9.sw,
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            SizedBox(height: 16.h),
            _buildSearchBar(),
            SizedBox(height: 16.h),
            _buildUsersList(),
            SizedBox(height: 16.h),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Add Members',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Select users to add to the group',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search users...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      onChanged: (value) {
        setState(() => _searchQuery = value);
      },
    );
  }

  Widget _buildUsersList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final filteredUsers = _nearbyUsers.where((user) {
      return user.username.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredUsers.isEmpty) {
      return Center(
        child: Text(
          'No users found nearby',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 0.5.sh),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          final isSelected = _selectedUsers.contains(user);

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: user.profileImageKey != null
                  ? NetworkImage(user.profileImageKey!)
                  : null,
              child: user.profileImageKey == null
                  ? Text(user.username[0].toUpperCase())
                  : null,
            ),
            title: Text(user.username),
            subtitle: Text(user.email),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value ?? false) {
                    _selectedUsers.add(user);
                  } else {
                    _selectedUsers.remove(user);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        SizedBox(width: 8.w),
        ElevatedButton(
          onPressed: _selectedUsers.isEmpty ? null : () {
            widget.onMembersAdded(_selectedUsers);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
          ),
          child: Text('Add Selected'),
        ),
      ],
    );
  }
} 