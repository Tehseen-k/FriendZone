import 'dart:async';
import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:code_structure/core/model/chat/messages.dart';
import 'package:code_structure/models/ChatParticipant.dart';
import 'package:code_structure/models/ChatRoom.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/models/GroupEvent.dart';
import 'package:code_structure/models/GroupMember.dart';
import 'package:code_structure/models/Message.dart';
import 'package:code_structure/models/ReadReceipt.dart';
import 'package:code_structure/models/User.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatViewModel extends ChangeNotifier {
  final User currentUser;
  final List<User> participants;
  final bool isGroupChat;
  final String? groupName;
  final Group? group;

  ChatRoom? chatRoom;
  bool isAdmin = false;
  List<Message> messages = [];
  List<ChatParticipant> chatParticipants = [];
  bool isLoading = true;
  bool isUploading = false;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _participantSubscription;

  // Add this constant for the API endpoint
  static const String _openAiApiUrl =
      'https://api.openai.com/v1/chat/completions';

  // You'll need to add your API key here
  static const String _openAiApiKey =
      'YOUR_API_KEY_HERE'; // Replace with your actual API key

  ChatViewModel({
    required this.currentUser,
    required this.participants,
    this.isGroupChat = false,
    this.groupName,
    this.group,
  }) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      print('Initializing ChatViewModel...');
      print('Is Group Chat: $isGroupChat');
      print('Group: ${group?.id}');
      
      if (isGroupChat && group != null) {
        print('Initializing group chat...');
        isAdmin = group!.admin.id == currentUser.id;
        // Create or get chat room for group
        chatRoom = await _findOrCreateChatRoom();
        print('Chat room initialized: ${chatRoom?.id}');
        await _loadGroupMessages();
      } else {
        print('Initializing direct chat...');
        await _loadDirectMessages();
      }
    } catch (e, stackTrace) {
      print('Error in _initialize: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> _loadGroupMessages() async {
    try {
      print('Loading group messages...');
      isLoading = true;
      notifyListeners();

      if (chatRoom == null) {
        print('Error: Chat room is null');
        return;
      }

      final request = ModelQueries.list(
        Message.classType,
        where: Message.CHATROOM.contains(chatRoom!.id),
      );

      final response = await Amplify.API.query(request: request).response;
      messages = response.data?.items.whereType<Message>().toList() ?? [];
      
      // Sort messages by timestamp
      messages.sort((a, b) => 
        (b.createdAt ?? TemporalDateTime.now())
            .compareTo(a.createdAt ?? TemporalDateTime.now()));

      print('Loaded ${messages.length} messages');

    } catch (e) {
      print('Error loading group messages: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadDirectMessages() async {
    try {
      isLoading = true;
      notifyListeners();

      if (isGroupChat) {
        await _loadGroupMessages();
      } else {
        final otherUser = participants.first;
        final room = await _findOrCreateOneToOneChat();
        chatRoom = room;
        await loadInitialMessages();
      }
    } catch (e) {
      print('Error loading messages: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<ChatRoom> _findOrCreateChatRoom() async {
    print('DEBUG: _findOrCreateChatRoom - isGroupChat: $isGroupChat');
    if (isGroupChat) {
      return await _createGroupChat();
    }
    return await _findOrCreateOneToOneChat();
  }

  Future<ChatRoom> _createGroupChat() async {
    // Check for existing group chat room
    final existingRoomRequest = ModelQueries.list(
      ChatParticipant.classType,
      where: ChatParticipant.USER.contains(currentUser.id),
    );

    final response = await Amplify.API.query(request: existingRoomRequest).response;
    final myParticipations = response.data?.items ?? [];
    
    for (final participation in myParticipations) {
      final room = participation!.chatRoom;
      if (room.isGroupChat && room.name == (groupName ?? 'Group Chat')) {
        print('DEBUG: Found existing group chat room: ${room.id}');
        return room; // Return existing room if found
      }
    }

    // If no existing room found, create a new one
    final chatRoom = ChatRoom(
      name: groupName ?? 'Group Chat',
      isGroupChat: true,
      admin: currentUser,
      lastMessage: '',
      lastMessageTimestamp: TemporalDateTime.now(),
      createdAt: TemporalDateTime.now(),
    );

    final createResponse = await Amplify.API
        .mutate(
          request: ModelMutations.create(chatRoom),
        )
        .response;

    final createdRoom = createResponse.data!;
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
    print(
        'DEBUG: Finding/Creating 1-1 chat between currentUser: ${currentUser.id} and otherUser: ${otherUser.id}');

    // Try to find existing chat room
    final existingRoomRequest = ModelQueries.list(
      ChatParticipant.classType,
      where: ChatParticipant.USER.contains(currentUser.id),
    );

    final response =
        await Amplify.API.query(request: existingRoomRequest).response;
    final myParticipations = response.data?.items ?? [];
    print(
        'DEBUG: Found ${myParticipations.length} existing chat participations for current user');

    for (final participation in myParticipations) {
      print(
          'DEBUG: Checking participation in room: ${participation!.chatRoom.id}');
      final otherParticipant =
          await _findChatParticipant(participation.chatRoom, otherUser);

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

    final createResponse = await Amplify.API
        .mutate(
          request: ModelMutations.create(newRoom),
        )
        .response;

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

  Future<ChatParticipant?> _findChatParticipant(
      ChatRoom chatRoom, User user) async {
    final request = ModelQueries.list(
      ChatParticipant.classType,
      where: ChatParticipant.USER
          .contains(user.id)
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

  Future<void> _createChatParticipant(
      ChatRoom chatRoom, User user, String role) async {
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
    String? mediaKey,
    String? mediaType,
    String? eventId,
  }) async {
    Message? message;
    try {
      print('Starting to send message...');
      print('Content: $content');
      print('Is Group Chat: $isGroupChat');
      print('Group ID: ${group?.id}');
      print('Chat Room ID: ${chatRoom?.id}');

      if (chatRoom == null) {
        print('Creating chat room before sending message...');
        chatRoom = await _findOrCreateChatRoom();
      }

      if (chatRoom == null) {
        throw Exception('Failed to initialize chat room');
      }

      message = Message(
        content: content,
        sender: currentUser,
        mediaKey: mediaKey,
        mediaType: mediaType,
        group: isGroupChat ? group : null,
        chatRoom: chatRoom!,
        createdAt: TemporalDateTime(DateTime.now()),
      );

      print('Message created with ID: ${message.id}');

      messages.insert(0, message);
      notifyListeners();

      print('Saving message to backend...');
      final savedMessage = await Amplify.API.mutate(
        request: ModelMutations.create(message)
      ).response;

      if (savedMessage.hasErrors) {
        print('Error saving message: ${savedMessage.errors}');
        messages.removeWhere((m) => m.id == message?.id);
        notifyListeners();
        throw Exception('Failed to save message');
      }

      print('Message saved successfully');

      // Update chat room's last message
      final updatedChatRoom = chatRoom!.copyWith(
        lastMessage: content,
        lastMessageTimestamp: TemporalDateTime(DateTime.now()),
      );

      await Amplify.API.mutate(
        request: ModelMutations.update(updatedChatRoom)
      ).response;
      print('Chat room updated successfully');

    } catch (e, stackTrace) {
      print('Error sending message: $e');
      print('Stack trace: $stackTrace');
      if (message != null) {
        messages.removeWhere((m) => m.id == message?.id);
        notifyListeners();
      }
      rethrow;
    }
  }

  // Future<void> sendMessage({
  //   required String content,
  //   String? mediaKey,
  //   String? mediaType,
  //   String? eventId,
  // }) async {
  //   try {
  //     final message = Message(
  //       content: content,
  //       sender: currentUser,
  //       mediaKey: mediaKey,
  //       mediaType: mediaType,
  //      // eventId: eventId,
  //       group: isGroupChat ? group : null,
  //       chatRoom: chatRoom!,
  //       createdAt: TemporalDateTime(DateTime.now()),
  //     );

  //     // Optimistically add message
  //     messages.insert(0, message);
  //     notifyListeners();

  //     // Send to backend
  //     final response = await Amplify.API.mutate(
  //       request: ModelMutations.create(message),
  //     ).response;

  //     if (!isGroupChat && chatRoom != null) {
  //       await _updateChatRoomLastMessage(content);
  //     }

  //   } catch (e) {
  //     print('Error sending message: $e');
  //     messages.removeAt(0);
  //     notifyListeners();
  //   }
  // }

  Future<void> _updateChatRoomLastMessage(String content) async {
    try {
      if (chatRoom == null) return;

      final updatedRoom = chatRoom!.copyWith(
        lastMessage: content,
        lastMessageTimestamp: TemporalDateTime.now(),
      );

      await Amplify.API.mutate(
        request: ModelMutations.update(updatedRoom),
      );
    } catch (e) {
      print('Error updating last message: $e');
    }
  }

  void _subscribeToMessages() {
    print('DEBUG: Setting up message subscription');
    final request = ModelSubscriptions.onCreate(Message.classType);
    _messageSubscription = Amplify.API
        .subscribe(
      request,
      onEstablished: () => print('DEBUG: Message subscription established'),
    )
        .listen(
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
        readAt: TemporalDateTime.now(),
        message: message,
        user: currentUser,
      );

      await Amplify.API.mutate(
        request: ModelMutations.create(readReceipt),
      );
    } catch (e) {
      print('Error creating read receipt: $e');
    }
  }

  Future<void> loadInitialMessages() async {
    print('Loading initial messages...');
    try {
      if (chatRoom == null) {
        print('Error: Cannot load messages - chat room is null');
        return;
      }

      final request = ModelQueries.list(
        Message.classType,
        where: Message.CHATROOM.contains(chatRoom!.id),
        limit: 50,
      );
      
      final response = await Amplify.API.query(request: request).response;
      messages = response.data?.items.map((e) => e!).toList() ?? [];
      print('Loaded ${messages.length} initial messages');
      
      messages.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return -1;
        if (b.createdAt == null) return 1;
        return b.createdAt!.getDateTimeInUtc().compareTo(a.createdAt!.getDateTimeInUtc());
      });
      notifyListeners();
    } catch (e, stackTrace) {
      print('Error loading initial messages: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _subscribeToParticipants() {
    final request = ModelSubscriptions.onCreate(ChatParticipant.classType);
    _participantSubscription = Amplify.API
        .subscribe(
      request,
      onEstablished: () => print('Participant subscription established'),
    )
        .listen(
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

  Future<String?> _uploadAttachment(PlatformFile file) async {
    try {
      final userId = await _getUserId();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Generate unique file path in chat-specific folder
      final filePath =
          'public/chats/${chatRoom!.id}/attachments/$timestamp-${file.name}';

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
    } on StorageException catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<String?> handleAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: false,
        withReadStream: true,
      );

      if (result != null) {
        final file = result.files.first;
        final mediaKey = await _uploadAttachment(file);

        if (mediaKey != null) {
          // Determine media type based on file extension
          String mediaType = 'file';
          final extension = file.extension?.toLowerCase() ?? '';

          if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
            mediaType = 'image';
          } else if (['mp4', 'mov', 'avi'].contains(extension)) {
            mediaType = 'video';
          } else if (['mp3', 'wav', 'm4a'].contains(extension)) {
            mediaType = 'audio';
          }

          // Send message with attachment
          await sendMessage(
            content: file.name,
            mediaType: mediaType,
            mediaKey: mediaKey,
          );

          return mediaKey;
        }
      }
    } catch (e) {
      print('Error handling attachment: $e');
    }
    return null;
  }

  Future<String> _getUserId() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user.userId;
  }

  Future<List<String>> getIceBreakerSuggestions(
      List<String> interests, List<String> hobbies) async {
    try {
      final interestsText =
          interests.isNotEmpty ? interests.join(", ") : 'unknown interests';

      final hobbiesText =
          hobbies.isNotEmpty ? hobbies.join(", ") : 'unknown hobbies';

      final prompt =
          "Generate 3 different friendly, conversational ice breaker questions based on these interests: $interestsText and hobbies: $hobbiesText. The questions should be natural, engaging, and help start a conversation. Format your response as a numbered list with each question on a new line, starting with 1., 2., and 3.";

      final response = await _callOpenAiApi(prompt);
      if (response != null) {
        // Parse the numbered list into separate suggestions
        final suggestions = response
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map((line) => line.replaceAll(RegExp(r'^\d+\.\s*'), '').trim())
            .toList();

        // Ensure we have at least one suggestion
        if (suggestions.isEmpty) {
          return [response]; // Return the whole response if parsing failed
        }

        return suggestions;
      }

      // Fallback suggestions
      return [
        "I noticed you're interested in $interestsText. What got you started with that?",
        "I see you enjoy $hobbiesText. What's your favorite thing about it?",
        "Would you recommend $hobbiesText to someone just starting out? Why or why not?"
      ];
    } catch (e) {
      print('Error getting ice breaker suggestions: $e');
      // Fallback suggestions
      return [
        "What's something you're passionate about that most people don't know?",
        "What's been the highlight of your week so far?",
        "If you could pick up a new skill instantly, what would it be and why?"
      ];
    }
  }

  Future<List<String>> getReplyHelp(String recentMessages) async {
    try {
      final prompt =
          "Here are the most recent messages in a conversation:\n\n$recentMessages\n\nBased on this conversation, suggest 3 different thoughtful, natural-sounding replies that continue the conversation in a friendly way. Format your response as a numbered list with each reply on a new line, starting with 1., 2., and 3.";

      final response = await _callOpenAiApi(prompt);
      if (response != null) {
        // Parse the numbered list into separate suggestions
        final suggestions = response
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map((line) => line.replaceAll(RegExp(r'^\d+\.\s*'), '').trim())
            .toList();

        // Ensure we have at least one suggestion
        if (suggestions.isEmpty) {
          return [response]; // Return the whole response if parsing failed
        }

        return suggestions;
      }

      // Fallback suggestions
      return [
        "That's really interesting! Could you tell me more about that?",
        "I've been thinking about something similar recently. What do you think about...?",
        "Thanks for sharing that with me. It reminds me of..."
      ];
    } catch (e) {
      print('Error getting reply help: $e');
      // Fallback suggestions
      return [
        "I'd love to hear more about that! Could you tell me more?",
        "That's fascinating! What made you think of that?",
        "I appreciate you sharing that with me. How long have you felt that way?"
      ];
    }
  }

  Future<String?> _callOpenAiApi(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_openAiApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAiApiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a helpful assistant that provides concise, friendly conversation suggestions.'
            },
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('API error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error calling OpenAI API: $e');
      return null;
    }
  }

  // Alternative implementation using DeepSeek API if you prefer
  Future<String?> _callDeepSeekApi(String prompt) async {
    try {
      // Replace with the actual DeepSeek API endpoint
      const apiUrl = 'https://api.deepseek.com/v1/chat/completions';

      // Replace with your DeepSeek API key
      const apiKey = 'YOUR_DEEPSEEK_API_KEY';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a helpful assistant that provides concise, friendly conversation suggestions.'
            },
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Adjust this based on DeepSeek's actual response format
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('API error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error calling DeepSeek API: $e');
      return null;
    }
  }

  Future<String?> uploadMedia(File file, String type) async {
    try {
      isUploading = true;
      notifyListeners();

      final key =
          'group/${group?.id}/media/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(file.path),
        path: StoragePath.fromString(key),
        onProgress: (progress) {
          print('Upload progress: ${progress.fractionCompleted}');
        },
      ).result;

      return key;
    } catch (e) {
      print('Error uploading media: $e');
      return null;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  Future<void> createGroupEvent({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required String location,
    double? latitude,
    double? longitude,
    List<String>? mediaKeys,
  }) async {
    try {
      if (!isGroupChat || group == null) return;

      final event = GroupEvent(
          title: title,
          description: description,
          startTime: TemporalDateTime(startTime),
          endTime: TemporalDateTime(endTime),
          location: location,
          latitude: latitude,
          longitude: longitude,
          mediaKeys: mediaKeys,
          group: group!,
          creator: currentUser,
          eventType: title);

      final response = await Amplify.API
          .mutate(
            request: ModelMutations.create(event),
          )
          .response;

      if (response.data != null) {
        // Send a message about the new event
        await sendMessage(
          content: 'New event: $title',
          eventId: response.data!.id,
          mediaType: 'event',
        );
      }
    } catch (e) {
      print('Error creating event: $e');
      rethrow;
    }
  }

  Future<void> updateGroupMembers({
    required List<User> addUsers,
    required List<User> removeUsers,
  }) async {
    try {
      if (!isAdmin || !isGroupChat || group == null) return;

      // Add new members
      for (final user in addUsers) {
        final member = GroupMember(
          user: user,
          group: group!,
          role: 'member',
          status: 'active',
          joinedAt: TemporalDateTime(DateTime.now()),
        );
        await Amplify.API
            .mutate(
              request: ModelMutations.create(member),
            )
            .response;
      }

      // Remove members
      for (final user in removeUsers) {
        final request = ModelQueries.list(
          GroupMember.classType,
          where: GroupMember.USER
              .contains(user.id)
              .and(GroupMember.GROUP.contains(group!.id)),
        );
        final response = await Amplify.API.query(request: request).response;

        if (response.data?.items.isNotEmpty ?? false) {
          final member = response.data!.items.first as GroupMember;
          await Amplify.API
              .mutate(
                request: ModelMutations.delete(member),
              )
              .response;
        }
      }
    } catch (e) {
      print('Error updating group members: $e');
      rethrow;
    }
  }
}
