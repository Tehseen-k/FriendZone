import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/foundation.dart';
import 'package:code_structure/models/ChatRoom.dart';
import 'package:code_structure/models/ChatParticipant.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/models/GroupMember.dart';

class ChatsListViewModel extends ChangeNotifier {
  final User currentUser;
  List<ChatRoom> chatRooms = [];
  List<Group> groups = [];
  bool isLoading = true;
  Map<String, List<User>> _chatParticipants = {};
  Map<String, int> _unreadCounts = {};

  ChatsListViewModel({required this.currentUser}) {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadChatsAndGroups();
  }

 Future<void> loadChatsAndGroups() async {
  try {
    print('Starting loadChatsAndGroups...');
    isLoading = true;
    notifyListeners();

    // Load personal chats (non-group chats only)
    print('Loading personal chats...');
    await loadChats();
    print('Personal chats loaded successfully');

    // Load groups where user is admin
    print('Loading admin groups for user ${currentUser.id}...');
    final adminGroupsRequest = ModelQueries.list(
      Group.classType,
      where: Group.ADMIN.contains(currentUser.id),
    );
    final adminGroupsResponse = await Amplify.API.query(
      request: adminGroupsRequest
    ).response;
    print('Admin groups response received: ${adminGroupsResponse.data?.items.length ?? 0} groups found');

    // Load group memberships
    print('Loading group memberships...');
    final membershipRequest = ModelQueries.list(
      GroupMember.classType,
      where: GroupMember.USER.contains(currentUser.id),
    );
    final membershipResponse = await Amplify.API.query(
      request: membershipRequest
    ).response;
    final memberships = membershipResponse.data?.items.whereType<GroupMember>().toList() ?? [];
    print('Found ${memberships.length} group memberships');

    // Fetch complete group data for each membership
    print('Fetching complete group data for each membership...');
    final memberGroups = <Group>[];
    
    for (final membership in memberships) {
      if (membership.status == 'active' && membership.group != null) {
        final groupRequest = ModelQueries.get(
          Group.classType,
          GroupModelIdentifier(id: membership.group!.id)
        );
        final groupResponse = await Amplify.API.query(request: groupRequest).response;
        if (groupResponse.data != null) {
          final group = groupResponse.data as Group;
          memberGroups.add(group);
        }
      }
    }

    // Combine groups
    final Set<Group> uniqueGroups = {
      ...adminGroupsResponse.data?.items.whereType<Group>() ?? [],
      ...memberGroups
    };
    groups = uniqueGroups.toList();

  } catch (e, stackTrace) {
    print('Error loading chats and groups:');
    print('Error: $e');
    print('Stack trace: $stackTrace');
  } finally {
    isLoading = false;
    notifyListeners();
  }
}
  Future<void> loadChats() async {
    try {
      isLoading = true;
      notifyListeners();

      // Get all chat participants for current user
      final participantsRequest = ModelQueries.list(
        ChatParticipant.classType,
        where: ChatParticipant.USER.contains(currentUser.id),
      );

      final participantsResponse = await Amplify.API.query(
        request: participantsRequest,
      ).response;

      final participants = participantsResponse.data?.items ?? [];

      // Get all chat rooms but filter out group chats
      chatRooms = [];
      for (final participant in participants) {
        if (participant == null) continue;
        
        final chatRoom = participant.chatRoom;
        // Only add non-group chats to the chat list
        if (!chatRoom.isGroupChat) {
          chatRooms.add(chatRoom);
          
          // Load other participants for this chat room
          await _loadChatParticipants(chatRoom);
          
          // Load unread count
          await _loadUnreadCount(chatRoom);
        }
      }

      // Sort chat rooms by last message timestamp
      chatRooms.sort((a, b) {
        final aTime = a.lastMessageTimestamp?.getDateTimeInUtc();
        final bTime = b.lastMessageTimestamp?.getDateTimeInUtc();
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

    } catch (e) {
      print('Error loading chats: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadChatParticipants(ChatRoom chatRoom) async {
    try {
      final request = ModelQueries.list(
        ChatParticipant.classType,
        where: ChatParticipant.CHATROOM.contains(chatRoom.id),
      );

      final response = await Amplify.API.query(request: request).response;
      final participants = response.data?.items ?? [];

      _chatParticipants[chatRoom.id] = participants
          .where((p) => p?.user.id != currentUser.id)
          .map((p) => p!.user)
          .toList();

    } catch (e) {
      print('Error loading chat participants: $e');
    }
  }

  Future<void> _loadUnreadCount(ChatRoom chatRoom) async {
    // Implement unread count logic based on your ReadReceipt model
    _unreadCounts[chatRoom.id] = 0; // Placeholder
  }

  List<User> getChatParticipants(ChatRoom chatRoom) {
    return _chatParticipants[chatRoom.id] ?? [];
  }

  int getUnreadCount(ChatRoom chatRoom) {
    return _unreadCounts[chatRoom.id] ?? 0;
  }

  Future<void> refreshChats() async {
    await loadChats();
  }

  Future<void> deleteChat(ChatRoom chatRoom) async {
    try {
      // Remove from local list first
      chatRooms.remove(chatRoom);
      notifyListeners();

      // Delete chat participants first
      final participantsRequest = ModelQueries.list(
        ChatParticipant.classType,
        where: ChatParticipant.CHATROOM.contains(chatRoom.id),
      );

      final participantsResponse = await Amplify.API.query(
        request: participantsRequest,
      ).response;

      for (final participant in participantsResponse.data?.items ?? []) {
        if (participant == null) continue;
        await Amplify.API.mutate(
          request: ModelMutations.delete(participant as ChatParticipant),
        ).response;
      }

      // Then delete the chat room
      await Amplify.API.mutate(
        request: ModelMutations.delete(chatRoom),
      ).response;

    } catch (e) {
      print('Error deleting chat: $e');
      // Reload chats in case of error
      await loadChats();
    }
  }

  // Future<String?> getGroupImageUrl(String? imageKey) async {
  //   if (imageKey == null) return null;
  //   try {
  //     final result = await Amplify.Storage.getUrl(
  //       key: imageKey,
  //       options: StorageGetUrlOptions(
  //         pluginOptions: S3GetUrlPluginOptions(
  //           expires: 60 * 60 * 24,
  //         ),
  //       ),
  //     ).result;
  //     return result.url.toString();
  //   } catch (e) {
  //     print('Error getting group image: $e');
  //     return null;
  //   }
  // }

  Future<List<User>> getGroupMembers(Group group) async {
    try {
      final request = ModelQueries.list(
        GroupMember.classType,
        where: GroupMember.GROUP.contains(group.id),
      );
      
      final response = await Amplify.API.query(request: request).response;
      final members = response.data?.items
          .whereType<GroupMember>()
          .where((member) => member.status == 'active')
          .map((member) => member.user)
          .toList() ?? [];

      return members;
    } catch (e) {
      print('Error getting group members: $e');
      return [];
    }
  }
} 