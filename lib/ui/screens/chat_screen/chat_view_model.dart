import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:code_structure/core/model/chat/messages.dart';
import 'package:code_structure/models/ChatParticipant.dart';
import 'package:code_structure/models/ChatRoom.dart';
import 'package:code_structure/models/Message.dart';
import 'package:code_structure/models/ReadReceipt.dart';
import 'package:code_structure/models/User.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  final User currentUser;
  final List<User> participants;
  final bool isGroupChat;
  final String? groupName;
  
  ChatRoom? chatRoom;
  bool isAdmin = false;
  List<Message> messages = [];
  List<ChatParticipant> chatParticipants = [];
  bool isLoading = false;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _participantSubscription;

  ChatViewModel({
    required this.currentUser,
    required this.participants,
    required this.isGroupChat,
    this.groupName,
  }) {
    _initialize();
  }

  Future<void> _initialize() async {
    print('DEBUG: Starting initialization with currentUser: ${currentUser.id}, participants: ${participants.map((p) => p.id).join(", ")}');
    isLoading = true;
    notifyListeners();

    try {
      print('DEBUG: Finding or creating chat room for ${isGroupChat ? "group chat" : "1-1 chat"}');
      final room = await _findOrCreateChatRoom();
      chatRoom = room;
      isAdmin = room.admin?.id == currentUser.id;
      print('DEBUG: Chat room details - ID: ${room.id}, name: ${room.name}, isAdmin: $isAdmin, lastMessage: ${room.lastMessage}');

      print('DEBUG: Loading chat participants for room: ${room.id}');
      await _loadChatParticipants();
      print('DEBUG: Loaded ${chatParticipants.length} participants: ${chatParticipants.map((p) => p.user.id).join(", ")}');
      
      print('DEBUG: Loading initial messages');
      await _loadInitialMessages();
      print('DEBUG: Loaded ${messages.length} messages');
      
      print('DEBUG: Setting up subscriptions');
      _subscribeToMessages();
      _subscribeToParticipants();
    } catch (e, stackTrace) {
      print('DEBUG: Error in initialization: $e');
      print('DEBUG: Stack trace: $stackTrace');
    }

    isLoading = false;
    print('DEBUG: Initialization complete');
    notifyListeners();
  }

  Future<ChatRoom> _findOrCreateChatRoom() async {
    print('DEBUG: _findOrCreateChatRoom - isGroupChat: $isGroupChat');
    if (isGroupChat) {
      return await _createGroupChat();
    }
    return await _findOrCreateOneToOneChat();
  }

  Future<ChatRoom> _createGroupChat() async {
    print('DEBUG: Creating group chat with name: $groupName');
    final chatRoom = ChatRoom(
      name: groupName,
      isGroupChat: true,
      admin: currentUser,
      lastMessage: '',
      lastMessageTimestamp: TemporalDateTime.now(),
    );

    final response = await Amplify.API.mutate(
      request: ModelMutations.create(chatRoom),
    ).response;

    final createdRoom = response.data!;
    print('DEBUG: Group chat created with ID: ${createdRoom.id}');
    
    print('DEBUG: Creating chat participants for group');
    await Future.wait([
      ...participants.map((user) {
        print('DEBUG: Creating participant for user: ${user.id}');
        return _createChatParticipant(createdRoom, user, 'member');
      }),
      _createChatParticipant(createdRoom, currentUser, 'admin'),
    ]);

    return createdRoom;
  }

  Future<ChatRoom> _findOrCreateOneToOneChat() async {
    final otherUser = participants.first;
    print('DEBUG: Finding/Creating 1-1 chat between currentUser: ${currentUser.id} and otherUser: ${otherUser.id}');
    
    // Try to find existing chat room
    final existingRoomRequest = ModelQueries.list(
      ChatParticipant.classType,
      where: ChatParticipant.USER.contains(currentUser.id),
    );
    
    final response = await Amplify.API.query(request: existingRoomRequest).response;
    final myParticipations = response.data?.items ?? [];
    print('DEBUG: Found ${myParticipations.length} existing chat participations for current user');
    
    for (final participation in myParticipations) {
      print('DEBUG: Checking participation in room: ${participation!.chatRoom.id}');
      final otherParticipant = await _findChatParticipant(participation.chatRoom, otherUser);
      
      if (otherParticipant != null) {
        print('DEBUG: Found existing chat room: ${participation.chatRoom.id}');
        final room = participation.chatRoom;
        if (!room.isGroupChat) {
          return room;
        }
      }
    }
    
    print('DEBUG: Creating new 1-1 chat room');
    // Create new chat room if not found
    final newRoom = ChatRoom(
      isGroupChat: false,
      lastMessage: '',
      lastMessageTimestamp: TemporalDateTime.now(),
      createdAt: TemporalDateTime.now(),
    );

    final createResponse = await Amplify.API.mutate(
      request: ModelMutations.create(newRoom),
    ).response;

    final createdRoom = createResponse.data;
    print("dataaaa ${createResponse.errors}");
    print('DEBUG: Created new chat room: ${createdRoom?.id}');
    // Create chat participants
    await Future.wait([
      _createChatParticipant(createdRoom!, currentUser, 'member'),
      _createChatParticipant(createdRoom, otherUser, 'member'),
    ]);

    return createdRoom;
  }

  Future<ChatParticipant?> _findChatParticipant(ChatRoom chatRoom, User user) async {
    final request = ModelQueries.list(
      ChatParticipant.classType,
      where: ChatParticipant.USER.contains(user.id)
             .and(ChatParticipant.CHATROOM.contains(chatRoom.id)),
    );
    
    final response = await Amplify.API.query(request: request).response;
    return response.data?.items.firstOrNull;
  }

  Future<ChatRoom?> _getChatRoom(String roomId) async {
    try {
      final request = ModelQueries.get(
        ChatRoom.classType,
        ChatRoomModelIdentifier(id: roomId),
      );
      
      final response = await Amplify.API.query(request: request).response;
      return response.data;
    } catch (e) {
      print('Error getting chat room: $e');
      return null;
    }
  }

  Future<void> _createChatParticipant(ChatRoom chatRoom, User user, String role) async {
    final participant = ChatParticipant(
      user: user,
      chatRoom: chatRoom,
      role: role,
      lastReadAt: TemporalDateTime.now(),
    );
    
    await Amplify.API.mutate(
      request: ModelMutations.create(participant),
    );
  }

  Future<void> _loadChatParticipants() async {
    final request = ModelQueries.list(
      ChatParticipant.classType,
      where: ChatParticipant.CHATROOM.contains(chatRoom!.id),
    );
    
    final response = await Amplify.API.query(request: request).response;
    chatParticipants = response.data?.items.map((e) => e!).toList() ?? [];
    notifyListeners();
  }

  Future<void> addMember(User user) async {
    if (!isAdmin || !isGroupChat) return;

    try {
    //  await _createChatParticipant(chatRoomId!, user.id, 'member');
    } catch (e) {
      print('Error adding member: $e');
    }
  }

  Future<void> removeMember(User user) async {
    if (!isAdmin || !isGroupChat) return;

    try {
      final participant = await _findChatParticipant(chatRoom!, user);
      if (participant != null) {
        await Amplify.API.mutate(
          request: ModelMutations.delete(participant),
        );
      }
    } catch (e) {
      print('Error removing member: $e');
    }
  }

  Future<void> sendMessage({
    required String content,
    required String mediaType,
    String? mediaKey,
  }) async {
    print('DEBUG: Sending message - content: "${content.substring(0, content.length.clamp(0, 50))}${content.length > 50 ? "..." : ""}"');
    print('DEBUG: Message details - mediaType: $mediaType, mediaKey: $mediaKey, chatRoomId: ${chatRoom?.id}');
    
    if (chatRoom == null) {
      print('DEBUG: Error - Chat room is null');
      throw Exception('Chat room not initialized');
    }
    
    try {
      final message = Message(
        chatRoom: chatRoom!,
        sender: currentUser,
        content: content,
        mediaType: mediaType,
        mediaKey: mediaKey,
      );
      
      print('DEBUG: Creating message in chat room: ${chatRoom!.id}');
      final response = await Amplify.API.mutate(
        request: ModelMutations.create(message),
      ).response;

      print('DEBUG: Message creation response: ${response.data?.id}');

      if (response.data != null) {
        print('DEBUG: Message created successfully, updating chat room last message');
        await _updateChatRoomLastMessage(content);
      }
    } catch (e, stackTrace) {
      print('DEBUG: Error sending message: $e');
      print('DEBUG: Stack trace: $stackTrace');
    }
  }

  Future<void> _updateChatRoomLastMessage(String content) async {
    try {
      final room = await _getChatRoom(chatRoom!.id);
      if (room != null) {
        final updatedRoom = room.copyWith(
          lastMessage: content,
          lastMessageTimestamp: TemporalDateTime.now(),
        );
        
        await Amplify.API.mutate(
          request: ModelMutations.update(updatedRoom),
        );
      }
    } catch (e) {
      print('Error updating last message: $e');
    }
  }

  void _subscribeToMessages() {
    print('DEBUG: Setting up message subscription');
    final request = ModelSubscriptions.onCreate(Message.classType);
    _messageSubscription = Amplify.API.subscribe(
      request,
      onEstablished: () => print('DEBUG: Message subscription established'),
    ).listen(
      (event) {
        if (event.data != null) {
          final message = event.data!;
          print('DEBUG: New message received - ID: ${message.id}');
          if (message.chatRoom.id == chatRoom!.id) {
            messages.insert(0, message);
            _createReadReceipt(message);
            notifyListeners();
          }
        }
      },
      onError: (error) => print('DEBUG: Message subscription error: $error'),
    );
  }

  Future<void> _createReadReceipt(Message message) async {
    try {
      final readReceipt = ReadReceipt(
       
        readAt: TemporalDateTime.now(), message: message, user: currentUser,
      );
      
      await Amplify.API.mutate(
        request: ModelMutations.create(readReceipt),
      );
    } catch (e) {
      print('Error creating read receipt: $e');
    }
  }

  Future<void> _loadInitialMessages() async {
    print('DEBUG: Loading initial messages for chat room: ${chatRoom?.id}');
    try {
      final request = ModelQueries.list(
        Message.classType,
        where: Message.CHATROOM.contains(chatRoom!.id),
        limit: 50,
      );
      
      final response = await Amplify.API.query(request: request).response;
      messages = response.data?.items.map((e) => e!).toList() ?? [];
      print('DEBUG: Loaded ${messages.length} messages');
      messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      print('DEBUG: Messages sorted by date, latest message: ${messages.isNotEmpty ? messages.first.content?.substring(0, messages.first.content?.length.clamp(0, 50) ?? 0) : "none"}');
      
      // Create read receipts for unread messages
      for (final message in messages) {
        _createReadReceipt(message);
      }
      
      notifyListeners();
    } catch (e, stackTrace) {
      print('DEBUG: Error loading messages: $e');
      print('DEBUG: Stack trace: $stackTrace');
    }
  }

  void _subscribeToParticipants() {
    final request = ModelSubscriptions.onCreate(ChatParticipant.classType);
    _participantSubscription = Amplify.API.subscribe(
      request,
      onEstablished: () => print('Participant subscription established'),
    ).listen(
      (event) {
        // Handle participant changes
        notifyListeners();
      },
      onError: (error) => print('Participant subscription error: $error'),
    );
  }

  @override
  void dispose() {
    print('DEBUG: Disposing ChatViewModel');
    _messageSubscription?.cancel();
    _participantSubscription?.cancel();
    super.dispose();
  }
} 