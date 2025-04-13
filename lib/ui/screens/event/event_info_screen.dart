import 'package:amplify_api/amplify_api.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/models/GroupMember.dart';
import 'package:code_structure/ui/screens/group/group_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:code_structure/models/GroupEvent.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/models/EventAttendee.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class EventInfoScreen extends StatefulWidget {
  final GroupEvent event;
  final User currentUser;

  const EventInfoScreen({
    required this.event,
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  @override
  State<EventInfoScreen> createState() => _EventInfoScreenState();
}

class _EventInfoScreenState extends State<EventInfoScreen> {
  bool isLoading = true;
  List<EventAttendee> attendees = [];
  String? currentUserStatus;
  bool isGroupMember = false;

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  Future<void> _loadEventData() async {
    try {
      setState(() => isLoading = true);
      await Future.wait([
        _loadAttendees(),
        _checkGroupMembership(),
        getgroup(),
      ]);
    } catch (e) {
      print('Error loading event data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadAttendees() async {
    try {
      final request = ModelQueries.list(
        EventAttendee.classType,
        where: EventAttendee.EVENT.eq(widget.event.id),
      );
      final response = await Amplify.API.query(request: request).response;
      attendees =
          response.data?.items.whereType<EventAttendee>().toList() ?? [];

      // Get current user's status
      final userAttendee = attendees.firstWhere(
        (a) => a.user.id == widget.currentUser.id,
        orElse: () => null as EventAttendee,
      );
      currentUserStatus = userAttendee?.status;
    } catch (e) {
      print('Error loading attendees: $e');
    }
  }

  Future<void> _checkGroupMembership() async {
    try {
      final request = ModelQueries.list(
        GroupMember.classType,
        where: GroupMember.GROUP
            .eq(widget.event.group.id)
            .and(GroupMember.USER.eq(widget.currentUser.id))
            .and(GroupMember.STATUS.eq('active')),
      );
      final response = await Amplify.API.query(request: request).response;
      isGroupMember = response.data?.items.isNotEmpty ?? false;
    } catch (e) {
      print('Error checking group membership: $e');
    }
  }

  Group? group;
  Future<void> getgroup() async {
    try {
      final request = ModelQueries.get(
          Group.classType, GroupModelIdentifier(id: widget.event.group.id));
      final response = await Amplify.API.query(request: request).response;
      final grp = response.data;
      group = grp;
    } catch (e) {
      print('Error checking group membership: $e');
    }
  }

  Future<void> _updateAttendanceStatus(String status) async {
    try {
      if (!isGroupMember) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Join the group to attend events')),
        );
        return;
      }

      setState(() => isLoading = true);

      // Delete existing attendance if any
      if (currentUserStatus != null) {
        final existingAttendee = attendees.firstWhere(
          (a) => a.user.id == widget.currentUser.id,
        );
        await Amplify.API
            .mutate(
              request: ModelMutations.delete(existingAttendee),
            )
            .response;
      }

      // Create new attendance
      final attendee = EventAttendee(
        user: widget.currentUser,
        event: widget.event,
        status: status,
      );

      await Amplify.API
          .mutate(
            request: ModelMutations.create(attendee),
          )
          .response;

      await _loadAttendees();
    } catch (e) {
      print('Error updating attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update attendance')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEventDetails(),
                      _buildAttendanceSection(),
                      _buildMediaGallery(),
                      _buildAttendeesSection(),
                      SizedBox(height: 100.h), // Space for FAB
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: _buildAttendanceFAB(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: widget.event.mediaKeys?.isNotEmpty ?? false
            ? Image.network(
                widget.event.mediaKeys!.first,
                fit: BoxFit.cover,
              )
            : Container(
                color:
                    _getEventTypeColor(widget.event.eventType).withOpacity(0.1),
                child: Icon(
                  _getEventTypeIcon(widget.event.eventType),
                  size: 64.sp,
                  color: _getEventTypeColor(widget.event.eventType),
                ),
              ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            // Implement share functionality
          },
        ),
      ],
    );
  }

  Widget _buildEventDetails() {
    final startTime = widget.event.startTime.getDateTimeInUtc();
    final endTime = widget.event.endTime.getDateTimeInUtc();

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Title and Type
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.event.title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: _getEventTypeColor(widget.event.eventType),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  widget.event.eventType.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Date and Time
          _buildInfoRow(
            Icons.access_time,
            _formatDateTime(startTime, endTime),
          ),
          SizedBox(height: 8.h),

          // Location
          _buildInfoRow(
            Icons.location_on,
            widget.event.location,
          ),
          SizedBox(height: 8.h),

          // Organizing Group
          _buildInfoRow(
            Icons.group,
            'Organized by ${widget.event.group.name}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupInfoScreen(
                    group: group!,
                    currentUser: widget.currentUser,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16.h),

          // Description
          Text(
            'About the Event',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            widget.event.description,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: primaryColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: onTap != null ? primaryColor : Colors.grey[800],
                decoration: onTap != null ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceSection() {
    final going = attendees.where((a) => a.status == 'going').length;
    final maybe = attendees.where((a) => a.status == 'maybe').length;
    final notGoing = attendees.where((a) => a.status == 'not_going').length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildAttendanceCount('Going', going, Colors.green),
          _buildAttendanceCount('Maybe', maybe, Colors.orange),
          _buildAttendanceCount('Not Going', notGoing, Colors.red),
        ],
      ),
    );
  }

  Widget _buildAttendanceCount(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaGallery() {
    if (widget.event.mediaKeys?.isEmpty ?? true) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            'Event Photos',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: widget.event.mediaKeys!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showMediaGallery(index),
                child: Container(
                  width: 120.w,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: NetworkImage(widget.event.mediaKeys![index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAttendeesSection() {
    final goingAttendees = attendees.where((a) => a.status == 'going').toList();
    if (goingAttendees.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            'Who\'s Going',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: goingAttendees.length,
          itemBuilder: (context, index) {
            final attendee = goingAttendees[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: attendee.user.profileImageKey != null
                    ? NetworkImage(attendee.user.profileImageKey!)
                    : null,
                child: attendee.user.profileImageKey == null
                    ? Icon(Icons.person)
                    : null,
              ),
              title: Text(attendee.user.username),
              trailing: attendee.user.id == widget.event.creator.id
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Organizer',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    )
                  : null,
            );
          },
        ),
      ],
    );
  }

  Widget _buildAttendanceFAB() {
    if (!isGroupMember) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupInfoScreen(
                group: group!,
                currentUser: widget.currentUser,
              ),
            ),
          );
        },
        icon: Icon(Icons.group_add),
        label: Text('Join Group to Attend'),
        backgroundColor: primaryColor,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttendanceButton(
            'Going',
            Icons.check_circle,
            Colors.green,
            currentUserStatus == 'going',
          ),
          _buildAttendanceButton(
            'Maybe',
            Icons.help,
            Colors.orange,
            currentUserStatus == 'maybe',
          ),
          _buildAttendanceButton(
            'Not Going',
            Icons.cancel,
            Colors.red,
            currentUserStatus == 'not_going',
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceButton(
    String label,
    IconData icon,
    Color color,
    bool isSelected,
  ) {
    return FloatingActionButton.extended(
      onPressed: () => _updateAttendanceStatus(label.toLowerCase()),
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : color,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : color,
        ),
      ),
      backgroundColor: isSelected ? color : color.withOpacity(0.1),
    );
  }

  void _showMediaGallery(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: widget.event.mediaKeys!.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.event.mediaKeys![index]),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                scrollPhysics: BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(color: Colors.black),
                pageController: PageController(initialPage: initialIndex),
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

  String _formatDateTime(DateTime start, DateTime end) {
    final dateFormat = DateFormat('EEEE, MMMM d');
    final timeFormat = DateFormat('h:mm a');

    if (start.day == end.day) {
      return '${dateFormat.format(start)}\n${timeFormat.format(start)} - ${timeFormat.format(end)}';
    } else {
      return '${dateFormat.format(start)} ${timeFormat.format(start)} -\n${dateFormat.format(end)} ${timeFormat.format(end)}';
    }
  }

  IconData _getEventTypeIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'meetup':
        return Icons.people;
      case 'activity':
        return Icons.sports;
      case 'workshop':
        return Icons.school;
      default:
        return Icons.event;
    }
  }

  Color _getEventTypeColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'meetup':
        return Colors.blue;
      case 'activity':
        return Colors.green;
      case 'workshop':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }
}
