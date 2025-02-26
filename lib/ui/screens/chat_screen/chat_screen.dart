import 'package:code_structure/models/Message.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/ui/screens/chat_screen/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final User currentUser;
  final List<User> participants; // Can be one user or multiple
  final bool isGroupChat;
  final String? groupName; // Optional, for group chats
  
  const ChatScreen({
    required this.currentUser,
    required this.participants,
    this.isGroupChat = false,
    this.groupName,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatViewModel _viewModel;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = ChatViewModel(
      currentUser: widget.currentUser,
      participants: widget.participants,
      isGroupChat: widget.isGroupChat,
      groupName: widget.groupName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: _buildMessagesList(),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: widget.isGroupChat 
        ? _buildGroupChatTitle()
        : _buildOneToOneChatTitle(),
      actions: widget.isGroupChat ? [
        IconButton(
          icon: Icon(Icons.group),
          onPressed: _showGroupInfo,
        ),
      ] : null,
    );
  }

  Widget _buildGroupChatTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.groupName ?? 'Group Chat'),
        Text(
          '${widget.participants.length} members',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildOneToOneChatTitle() {
    final otherUser = widget.participants.first;
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: otherUser.profileImageKey != null
            ? NetworkImage(otherUser.profileImageKey!)
            : null,
        ),
        SizedBox(width: 8),
        Text(otherUser.username ?? ''),
      ],
    );
  }

  void _showGroupInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) => GroupInfoSheet(
        participants: widget.participants,
        currentUser: widget.currentUser,
        onAddMember: _viewModel.isAdmin ? _addMember : null,
        onRemoveMember: _viewModel.isAdmin ? _removeMember : null,
      ),
    );
  }

  Widget _buildMessagesList() {
    return Consumer<ChatViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        return ListView.builder(
          reverse: true,
          itemCount: viewModel.messages.length,
          itemBuilder: (context, index) {
            final message = viewModel.messages[index];
            final isMyMessage = message.sender.id == widget.currentUser.id;
            
            return MessageBubble(
              message: message,
              isMyMessage: isMyMessage,
              sender: isMyMessage ? widget.currentUser : 
                widget.participants.firstWhere((p) => p.id == message.sender.id),
            );
          },
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: _handleAttachment,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    
    await _viewModel.sendMessage(
      content: _messageController.text,
      mediaType: 'text',
    );
    
    _messageController.clear();
  }

  Future<void> _handleAttachment() async {
    // Implement file attachment logic
    // You can show a bottom sheet with options like image, video, etc.
  }

  Future<void> _addMember(User user) async {
    await _viewModel.addMember(user);
    Navigator.pop(context); // Close the dialog
  }

  Future<void> _removeMember(User user) async {
    await _viewModel.removeMember(user);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

// Add GroupInfoSheet widget
class GroupInfoSheet extends StatelessWidget {
  final List<User> participants;
  final User currentUser;
  final Function(User)? onAddMember;
  final Function(User)? onRemoveMember;

  const GroupInfoSheet({
    required this.participants,
    required this.currentUser,
    this.onAddMember,
    this.onRemoveMember,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Group Members',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: participants.length + (onAddMember != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == participants.length) {
                  return ListTile(
                    leading: CircleAvatar(child: Icon(Icons.add)),
                    title: Text('Add Member'),
                    onTap: () => _showAddMemberDialog(context),
                  );
                }

                final participant = participants[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: participant.profileImageKey != null
                      ? NetworkImage(participant.profileImageKey!)
                      : null,
                  ),
                  title: Text(participant.username ?? ''),
                  trailing: onRemoveMember != null && participant.id != currentUser.id
                    ? IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () => onRemoveMember!(participant),
                      )
                    : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    // Implement member addition dialog
  }
}

// Add MessageBubble widget
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMyMessage;
  final User sender;

  const MessageBubble({
    required this.message,
    required this.isMyMessage,
    required this.sender,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMyMessage) ...[
            CircleAvatar(
              backgroundImage: sender.profileImageKey != null
                ? NetworkImage(sender.profileImageKey!)
                : null,
              radius: 16,
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMyMessage ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: _buildMessageContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    if (message.mediaType == 'text' || message.mediaType == null) {
      return Text(
        message.content ?? '',
        style: TextStyle(
          color: isMyMessage ? Colors.white : Colors.black,
        ),
      );
    } else if (message.mediaType == 'image' && message.mediaKey != null) {
      return Image.network(
        message.mediaKey!,
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      );
    }
    // Add more media type handlers as needed
    return Text('Unsupported message type');
  }
} 