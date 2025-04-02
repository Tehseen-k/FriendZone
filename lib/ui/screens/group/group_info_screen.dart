import 'package:amplify_api/amplify_api.dart';
import 'package:code_structure/models/ChatParticipant.dart';
import 'package:code_structure/ui/screens/chats_list/chats_list_screen.dart';
import 'package:code_structure/ui/screens/group/create_event_dialog.dart';
import 'package:code_structure/ui/screens/group/edit_group_screen.dart';
import 'package:code_structure/ui/screens/group/manage_members_dialog.dart';
import 'package:code_structure/ui/screens/home_screen/home_veiw_model.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/models/GroupEvent.dart';
import 'package:code_structure/models/GroupMember.dart';
import 'package:code_structure/models/ChatRoom.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';

class GroupInfoScreen extends StatefulWidget {
  final Group group;
  final User currentUser;

  const GroupInfoScreen({
    required this.group,
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  List<GroupMember> members = [];
  List<GroupEvent> events = [];
  bool isLoading = true;
  bool isMember = false;
  bool isAdmin = false;
  ChatRoom? groupChat;

  @override
  void initState() {
    super.initState();
    _loadGroupData();
  }

  Future<void> _loadGroupData() async {
    try {
      setState(() => isLoading = true);
      await Future.wait([
        _loadMembers(),
        _loadEvents(),
        _loadGroupChat(),
      ]);
      _checkMembershipStatus();
    } catch (e) {
      print('Error loading group data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _checkMembershipStatus() {
    try{
         final currentUserMember = members.firstWhere(
      (member) =>
          member.user.id == widget.currentUser.id && member.status == 'active',
      orElse: () => null as GroupMember,
    );

    isAdmin = widget.group.admin.id == widget.currentUser.id;
    isMember = currentUserMember != null;
    }catch(e){
      print("error occured in _checkMembershipStatus $e");
    }
 
  }

  Future<void> _loadMembers() async {
    try {
      final request = ModelQueries.list(
        GroupMember.classType,
        where: GroupMember.GROUP.eq(widget.group.id),
      );
      final response = await Amplify.API.query(request: request).response;
      members = response.data?.items
              .whereType<GroupMember>()
              .where((member) => member.status == 'active')
              .toList() ??
          [];
    } catch (e) {
      print('Error loading members: $e');
    }
  }

  Future<void> _loadEvents() async {
    try {
      final request = ModelQueries.list(
        GroupEvent.classType,
        where: GroupEvent.GROUP.eq(widget.group.id),
      );
      final response = await Amplify.API.query(request: request).response;
      events = response.data?.items.whereType<GroupEvent>().toList() ?? [];
      events.sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  Future<void> _loadGroupChat() async {
    try {
      final request = ModelQueries.list(
        ChatRoom.classType,
        where: ChatRoom.NAME
            .eq(widget.group.name)
            .and(ChatRoom.ISGROUPCHAT.eq(true)),
      );
      final response = await Amplify.API.query(request: request).response;
      groupChat = response.data?.items.firstOrNull as ChatRoom?;
    } catch (e) {
      print('Error loading group chat: $e');
    }
  }

  Future<void> _joinGroup() async {
    try {
      setState(() => isLoading = true);

      // First create the group member
      final member = GroupMember(
        user: widget.currentUser,
        group: widget.group,
        role: 'member',
        status: 'active',
        joinedAt: TemporalDateTime(DateTime.now()),
      );

      await Amplify.API.mutate(
        request: ModelMutations.create(member),
      ).response;

      // Find or create the group chat room
      final chatRoomRequest = ModelQueries.list(
        ChatRoom.classType,
        where: ChatRoom.NAME.eq(widget.group.name).and(ChatRoom.ISGROUPCHAT.eq(true)),
      );

      final chatRoomResponse = await Amplify.API.query(request: chatRoomRequest).response;
      final existingRooms = chatRoomResponse.data?.items.whereType<ChatRoom>().toList() ?? [];
      
      ChatRoom chatRoom;
      if (existingRooms.isNotEmpty) {
        chatRoom = existingRooms.first;
      } else {
        // Create new chat room if none exists
        final newChatRoom = ChatRoom(
          name: widget.group.name,
          isGroupChat: true,
          admin: widget.group.admin,
          lastMessage: '',
          lastMessageTimestamp: TemporalDateTime.now(),
          createdAt: TemporalDateTime.now(),
        );

        final createResponse = await Amplify.API.mutate(
          request: ModelMutations.create(newChatRoom),
        ).response;
        
        chatRoom = createResponse.data!;
      }

      // Add user as chat participant
      final chatParticipant = ChatParticipant(
        user: widget.currentUser,
        chatRoom: chatRoom,
        role: 'member',
        lastReadAt: TemporalDateTime.now(),
      );

      await Amplify.API.mutate(
        request: ModelMutations.create(chatParticipant),
      ).response;

      await _loadGroupData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully joined the group')),
      );
    } catch (e) {
      print('Error joining group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join group')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _leaveGroup() async {
    try {
      setState(() => isLoading = true);

      // Remove group membership
      final member = members.firstWhere(
        (m) => m.user.id == widget.currentUser.id,
      );

      await Amplify.API.mutate(
        request: ModelMutations.delete(member),
      ).response;

      // Remove from chat room if exists
      if (groupChat != null) {
        final participantRequest = ModelQueries.list(
          ChatParticipant.classType,
          where: ChatParticipant.USER.contains(widget.currentUser.id)
            .and(ChatParticipant.CHATROOM.contains(groupChat!.id)),
        );

        final participantResponse = await Amplify.API.query(request: participantRequest).response;
        final participants = participantResponse.data?.items ?? [];

        for (final participant in participants) {
          if (participant == null) continue;
          await Amplify.API.mutate(
            request: ModelMutations.delete(participant),
          ).response;
        }
      }

      await _loadGroupData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully left the group')),
      );
    } catch (e) {
      print('Error leaving group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to leave group')),
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
                      _buildGroupDetails(),
                      _buildActionButtons(),
                      _buildMembersList(),
                      _buildEventsList(),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showCreateEventDialog(),
              icon: Icon(Icons.add,color: Colors.white,),
              label: Text('Create Event',style: TextStyle(color: Colors.white),),
              backgroundColor: primaryColor,
            )
          : null,
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: widget.group.groupImageKey != null
            ? FutureBuilder<String>(
                future: getFileUrl(widget.group.groupImageKey!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                        onTap: () => _showMediaPreview(snapshot.data!),
                        child: Image.network(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ));
                  }
                  return Container(
                    width: 120.w,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.grey[200],
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              )
          
            : Container(
                color: primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.group,
                  size: 64.sp,
                  color: primaryColor,
                ),
              ),
      ),
      actions: [
        if (isMember && groupChat != null)
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatsListScreen(
                    //   chatRoom: groupChat!,
                    currentUser: widget.currentUser,
                  ),
                ),
              );
            },
          ),
        if (isAdmin)
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showGroupSettings(),
          ),
      ],
    );
  }

  Widget _buildGroupDetails() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGroupDescription(),
          SizedBox(height: 24.h),
          _buildInterestsAndHobbies(),
          SizedBox(height: 24.h),
          _buildLocation(),
          SizedBox(height: 24.h),
          _buildMediaGallery(),
        ],
      ),
    );
  }

  Widget _buildGroupDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          widget.group.description,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsAndHobbies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.group.interests != null &&
            widget.group.interests!.isNotEmpty)
          _buildChipSection('Interests', widget.group.interests!),
        SizedBox(height: 16.h),
        if (widget.group.hobbies != null && widget.group.hobbies!.isNotEmpty)
          _buildChipSection('Hobbies', widget.group.hobbies!),
      ],
    );
  }

  Widget _buildChipSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: items
              .map((item) => Chip(
                    label: Text(item),
                    backgroundColor: primaryColor.withOpacity(0.1),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        ListTile(
          leading: Icon(Icons.location_on, color: primaryColor),
          title: Text(widget.group.locationName ?? 'Location not specified'),
          subtitle:
              Text('Allowed radius: ${widget.group.allowedRadius.round()} km'),
        ),
      ],
    );
  }

  Widget _buildMediaGallery() {
    if (widget.group.mediaKeys == null || widget.group.mediaKeys!.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Media Gallery',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.group.mediaKeys!.length,
            itemBuilder: (context, index) {
              return FutureBuilder<String>(
                future: getFileUrl(widget.group.mediaKeys![index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: () => _showMediaPreview(snapshot.data!),
                      child: Container(
                        width: 120.w,
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }
                  return Container(
                    width: 120.w,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.grey[200],
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMembersList() {
    return Padding(padding: EdgeInsets.all(10),child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Members (${members.length})',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.group.admin.id == widget.currentUser.id)
              TextButton.icon(
                onPressed: _showAddMembersDialog,
                icon: Icon(Icons.person_add),
                label: Text('Add'),
              ),
          ],
        ),
      
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return member.user.profileImageKey != null
                ? FutureBuilder<String>(
                    future: getFileUrl(member.user.profileImageKey??''),
                    builder: (context, snapshot) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: snapshot.hasData
                              ? NetworkImage(snapshot.data!)
                              : null,
                          child: snapshot.hasData
                              ? null
                              : Text(member.user.username[0].toUpperCase()),
                        ),
                        title: Text(member.user.username),
                        subtitle: Text(member.role),
                        trailing: widget.group.admin.id == widget.currentUser.id &&
                                member.user.id != widget.currentUser.id
                            ? IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () => _removeMember(member),
                              )
                            : null,
                      );
                    },
                  )
                : ListTile(
                    leading: CircleAvatar(
                      child: Text(member.user.username[0].toUpperCase()),
                    ),
                    title: Text(member.user.username),
                    subtitle: Text(member.role),
                    trailing: widget.group.admin.id == widget.currentUser.id &&
                            member.user.id != widget.currentUser.id
                        ? IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () => _removeMember(member),
                          )
                        : null,
                  );
          },
        ),
     
      ],
    )
   ,);
    
  }

  Widget _buildEventsList() {
    return Padding(padding: EdgeInsets.all(10),child:    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Events',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            if(isMember)
             ElevatedButton.icon(
              onPressed: _showCreateEventDialog,
              icon: Icon(Icons.add, size: 20.sp,color: Colors.white,),
              label: Text('Create Event'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),

            
           
          ],
        ),
        SizedBox(height: 16.h),
        if (events.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.event_busy,
                  size: 48.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 8.h),
                Text(
                  'No events scheduled',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Create an event to get started!',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _buildEventCard(event);
            },
          ),
      ],
    )
 ,);
    


  }

  Widget _buildEventCard(GroupEvent event) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () => _showEventDetails(event),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _getEventTypeIcon(event.eventType),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (event.creator.id == widget.currentUser.id)
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.grey[600]),
                      onPressed: () => _editEvent(event),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16.sp, color: primaryColor),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      event.location,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16.sp, color: primaryColor),
                  SizedBox(width: 4.w),
                  Text(
                    _formatEventDateTime(event.startTime, event.endTime),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getEventTypeIcon(String eventType) {
    IconData iconData;
    Color iconColor;

    switch (eventType.toLowerCase()) {
      case 'meetup':
        iconData = Icons.people;
        iconColor = Colors.blue;
        break;
      case 'activity':
        iconData = Icons.sports;
        iconColor = Colors.green;
        break;
      case 'workshop':
        iconData = Icons.school;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.event;
        iconColor = Colors.purple;
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24.sp,
      ),
    );
  }

  String _formatEventDateTime(TemporalDateTime start, TemporalDateTime end) {
    final startDate = start.getDateTimeInUtc();
    final endDate = end.getDateTimeInUtc();

    final dateFormat = DateFormat('MMM d');
    final timeFormat = DateFormat('h:mm a');

    if (startDate.day == endDate.day) {
      return '${dateFormat.format(startDate)} · ${timeFormat.format(startDate)} - ${timeFormat.format(endDate)}';
    } else {
      return '${dateFormat.format(startDate)} ${timeFormat.format(startDate)} - ${dateFormat.format(endDate)} ${timeFormat.format(endDate)}';
    }
  }

  void _showMediaPreview(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PhotoView(
                imageProvider: NetworkImage(url),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
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

  Future<void> _addMember(User user) async {
    try {
      final member = GroupMember(
        user: user,
        group: widget.group,
        role: 'member',
        status: 'active',
        joinedAt: TemporalDateTime(DateTime.now()),
      );

      await Amplify.API
          .mutate(
            request: ModelMutations.create(member),
          )
          .response;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.username} added to group')),
      );
    } catch (e) {
      print('Error adding member: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add member')),
      );
    }
  }

  Future<void> _removeMember(GroupMember member) async {
    try {
      // Show confirmation dialog
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Remove Member'),
          content: Text(
              'Are you sure you want to remove ${member.user.username} from the group?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      await Amplify.API
          .mutate(
            request: ModelMutations.delete(member),
          )
          .response;

      setState(() {
        members.remove(member);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${member.user.username} removed from group')),
      );
    } catch (e) {
      print('Error removing member: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove member')),
      );
    }
  }

  void _showCreateEventDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateEventDialog(
        group: widget.group,
        currentUser: widget.currentUser,
        onCreateEvent: (title, description, startTime, endTime, eventType,
            location) async {
          try {
            final event = GroupEvent(
              title: title,
              description: description,
              location: location,
              startTime: TemporalDateTime(startTime),
              endTime: TemporalDateTime(endTime),
              eventType: eventType,
              group: widget.group,
              creator: widget.currentUser,
            );

            await Amplify.API
                .mutate(
                  request: ModelMutations.create(event),
                )
                .response;

            // Refresh events list
            await _loadEvents();
            return true;
          } catch (e) {
            print('Error creating event: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to create event')),
            );
            return false;
          }
        },
      ),
    );
  }

  void _showAddMembersDialog() {
    showDialog(
      context: context,
      builder: (context) => ManageMembersDialog(
        group: widget.group,
        currentMembers: members,
        onMembersAdded: (users) async {
          for (final user in users) {
            await _addMember(user);
          }
          await _loadMembers();
        },
        onMemberRemoved: _removeMember,
      ),
    );
  }

  void _showEventDetails(GroupEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event header
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),

                  // Event title
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Event details
                  _buildEventDetailItem(
                    Icons.description,
                    'Description',
                    event.description,
                  ),
                  _buildEventDetailItem(
                    Icons.location_on,
                    'Location',
                    event.location,
                  ),
                  _buildEventDetailItem(
                    Icons.access_time,
                    'Time',
                    '${_formatEventDateTime(event.startTime, event.endTime)} - ${_formatEventDateTime(event.endTime, event.endTime)}',
                  ),
                  _buildEventDetailItem(
                    Icons.category,
                    'Type',
                    event.eventType.toUpperCase(),
                  ),

                  // Event media
                  if (event.mediaKeys != null &&
                      event.mediaKeys!.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    Text(
                      'Event Media',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 120.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: event.mediaKeys!.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<String>(
                            future: getFileUrl(event.mediaKeys![index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return GestureDetector(
                                  onTap: () =>
                                      _showMediaPreview(snapshot.data!),
                                  child: Container(
                                    width: 120.w,
                                    margin: EdgeInsets.only(right: 8.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      image: DecorationImage(
                                        image: NetworkImage(snapshot.data!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                width: 120.w,
                                margin: EdgeInsets.only(right: 8.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.grey[200],
                                ),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editEvent(GroupEvent event) async {
    // Only allow editing if the user is the creator
    if (event.creator.id != widget.currentUser.id) return;

    // Implement edit event functionality
    // You can reuse the CreateEventDialog with pre-filled data
  }

  Widget _buildActionButtons() {
    if (isAdmin) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showManageMembersDialog(),
                icon: Icon(Icons.people),
                label: Text('Manage Members'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showGroupSettings(),
                icon: Icon(Icons.settings),
                label: Text('Settings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (!isMember) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: ElevatedButton.icon(
          onPressed: _joinGroup,
          icon: Icon(Icons.group_add,color: Colors.white,),
          label: Text('Join Group'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            minimumSize: Size(double.infinity, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          if (groupChat != null)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatsListScreen(
                        //   chatRoom: groupChat!,
                        currentUser: widget.currentUser,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.chat,color: Colors.white),
                label: Text('Group Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          if (groupChat != null) SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showLeaveGroupDialog(),
              icon: Icon(Icons.exit_to_app),
              label: Text('Leave Group'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[100],
                foregroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLeaveGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Leave Group'),
        content: Text('Are you sure you want to leave this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _leaveGroup();
            },
            child: Text(
              'Leave',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showManageMembersDialog() {
    // showDialog(
    //   context: context,
    //   builder: (context) => ManageMembersDialog(
    //     group: widget.group,
    //     currentMembers: members,
    //     onMembersUpdated: () => _loadMembers(),
    //   ),
    // );
  }

  void _showGroupSettings()async {
   if (!isAdmin) return;
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditGroupScreen(
          group: widget.group,
          currentUser: widget.currentUser,
        ),
      ),
    );

    if (result == true) {
      // Refresh group data if changes were made
      await _loadGroupData();
    }
  }
}

//Future<String> getFileUrl(String key) async {
//   try {
//     final result = await Amplify.Storage.getUrl(
//       path: Stora key,
//       options: StorageGetUrlOptions(
//         expires: 60 * 60 * 24, // 24 hours
//       ),
//     ).result;
//     return result.url.toString();
//   } catch (e) {
//     print('Error getting file URL: $e');
//     throw e;
//   }
// }
