import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/ui/screens/group/create_group_screen.dart';
import 'package:code_structure/ui/screens/home_screen/home_veiw_model.dart';
import 'package:flutter/material.dart';
import 'package:code_structure/models/ChatRoom.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/ui/screens/chat_screen/chat_screen.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'chats_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatsListScreen extends StatelessWidget {
  final User currentUser;

  const ChatsListScreen({
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ChangeNotifierProvider(
        create: (_) => ChatsListViewModel(currentUser: currentUser),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Messages',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            bottom: TabBar(
            
              tabs: [
                Tab(text: 'Chats'),
                Tab(text: 'Groups'),
              ],
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: primaryColor),
                onPressed: () {
                  // Implement search functionality
                },
              ),
              IconButton(
                icon: Icon(Icons.group_add, color: primaryColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateGroupScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              _ChatsList(),
              _GroupsList(),
            ],
          ),
          floatingActionButton: _buildFloatingActionButton(context),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Builder(
      builder: (context) {
        final tabController = DefaultTabController.of(context);
        return FloatingActionButton(
          onPressed: () {
            final isGroupTab = tabController.index == 1;
            if (isGroupTab) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateGroupScreen(),
                ),
              );
            } else {
              // Navigate to new chat screen
            }
          },
          backgroundColor: primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class _ChatsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatsListViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (viewModel.chatRooms.isEmpty) {
          return _EmptyChatsView();
        }

        return RefreshIndicator(
          onRefresh: viewModel.refreshChats,
          color: primaryColor,
          child: ListView.builder(
            itemCount: viewModel.chatRooms.length,
            itemBuilder: (context, index) {
              return _ChatTile(chatRoom: viewModel.chatRooms[index]);
            },
          ),
        );
      },
    );
  }
}

class _ChatTile extends StatelessWidget {
  final ChatRoom chatRoom;
  Group? group;

   _ChatTile({
    required this.chatRoom,
    this.group,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ChatsListViewModel>();

    return Dismissible(
      key: Key(chatRoom.id),
      background: _buildDismissBackground(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Chat'),
            content: Text('Are you sure you want to delete this chat?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        viewModel.deleteChat(chatRoom);
      },
      child: InkWell(
        onTap: () {
          print("is group chat ${chatRoom.isGroupChat}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                currentUser: viewModel.currentUser,
                participants: viewModel.getChatParticipants(chatRoom),
                isGroupChat: chatRoom.isGroupChat,
                groupName: chatRoom.name,
                group:chatRoom.isGroupChat? viewModel.groups.firstWhere((grp)=>grp.name==chatRoom.name):null,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildAvatar(chatRoom, viewModel),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _getChatTitle(chatRoom, viewModel),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatTimestamp(chatRoom.lastMessageTimestamp),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chatRoom.lastMessage ?? 'No messages yet',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (viewModel.getUnreadCount(chatRoom) > 0)
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              viewModel.getUnreadCount(chatRoom).toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ChatRoom chatRoom, ChatsListViewModel viewModel) {
    if (chatRoom.isGroupChat) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.group, color: Colors.grey[600], size: 30),
      );
    }

    final otherUser = viewModel.getChatParticipants(chatRoom).first;
    return FutureBuilder<String>(
      future: getFileUrl(otherUser.profileImageKey!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                snapshot.data != null ? NetworkImage(snapshot.data!) : null,
            child: otherUser.profileImageKey == null
                ? Text(
                    otherUser.username[0].toUpperCase() ?? '?',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  )
                : null,
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      },
    );
  }

  String _getChatTitle(ChatRoom chatRoom, ChatsListViewModel viewModel) {
    if (chatRoom.isGroupChat) {
      return chatRoom.name ?? 'Group Chat';
    }
    final otherUser = viewModel.getChatParticipants(chatRoom).first;
    return otherUser.username ?? 'Unknown User';
  }

  String _formatTimestamp(TemporalDateTime? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.getDateTimeInUtc();
    return timeago.format(date, allowFromNow: true);
  }

  Widget _buildDismissBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}

class _EmptyChatsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No chats yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start a conversation with someone!',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to new chat/contact selection screen
            },
            icon: Icon(Icons.add),
            label: Text('Start New Chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatsListViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }

        if (viewModel.groups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.group_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Groups Yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Create or join a group to get started',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateGroupScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text('Create New Group'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: viewModel.groups.length,
          itemBuilder: (context, index) {
            final group = viewModel.groups[index];
            return _GroupTile(group: group);
          },
        );
      },
    );
  }
}

class _GroupTile extends StatelessWidget {
  final Group group;

  const _GroupTile({required this.group});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatsListViewModel>();

    return ListTile(
      onTap: () async {
        final members = await viewModel.getGroupMembers(group);
        print("hereeeeeeeee");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              currentUser: viewModel.currentUser,
              participants: members,
              isGroupChat: true,
              groupName: group.name,
              group: group,
            ),
          ),
        );
      },
      leading: FutureBuilder<String?>(
        future: group.mediaKeys?.isNotEmpty == true 
            ? getFileUrl(group.mediaKeys!.first)
            : Future.value(null),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data!),
              radius: 25,
            );
          }
          return CircleAvatar(
            child: Icon(Icons.group),
            radius: 25,
          );
        },
      ),
      title: Text(
        group.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        group.description ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: group.admin?.id == viewModel.currentUser.id
          ? Icon(Icons.admin_panel_settings, color: primaryColor)
          : null,
    );
  }
}

// For one-to-one chat navigation
void _navigateToChat(BuildContext context, ChatRoom chatRoom) {
  final viewModel = context.read<ChatsListViewModel>();
  final otherUser = viewModel.getChatParticipants(chatRoom).first;
  
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(
        currentUser: viewModel.currentUser,
        participants: [otherUser], // Pass single user for one-to-one chat
        isGroupChat: false,
      ),
    ),
  );
}
