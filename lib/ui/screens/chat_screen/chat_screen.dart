import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/models/GroupEvent.dart';
import 'package:code_structure/models/Message.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/ui/screens/chat_screen/chat_view_model.dart';
import 'package:code_structure/ui/screens/chat_screen/video_player_widget.dart';
import 'package:code_structure/ui/screens/group/create_event_dialog.dart';
import 'package:code_structure/ui/screens/group/group_info_screen.dart';
import 'package:code_structure/ui/screens/home_screen/home_veiw_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class ChatScreen extends StatefulWidget {
  final User currentUser;
  final List<User> participants; // For both group members and one-to-one chat
  final bool isGroupChat;
  final String? groupName;
  final Group? group;

  const ChatScreen({
    required this.currentUser,
    required this.participants, // This will contain all members for group chat or single user for one-to-one
    this.isGroupChat = false,
    this.groupName,
    this.group,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatViewModel _viewModel;
  final TextEditingController _messageController = TextEditingController();
  bool _showSuggestionOptions = false;

  @override
  void initState() {
    super.initState();
    _viewModel = ChatViewModel(
      currentUser: widget.currentUser,
      participants: widget.participants,
      isGroupChat: widget.isGroupChat,
      groupName: widget.groupName,
      group: widget.group,
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
            if (_showSuggestionOptions) _buildSuggestionOptions(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: widget.isGroupChat
          ? _buildGroupChatTitle()
          : _buildOneToOneChatTitle(),
      actions: widget.isGroupChat
          ? [
              IconButton(
                icon: Icon(Icons.event, color: primaryColor),
                onPressed: _showCreateEventDialog,
                tooltip: 'Create Event',
              ),
              IconButton(
                icon: Icon(Icons.info_outline, color: primaryColor),
                onPressed: () => _showGroupInfo(context),
                tooltip: 'Group Info',
              ),
            ]
          : null,
    );
  }

  Widget _buildGroupChatTitle() {
    return GestureDetector(
      onTap: () => _showGroupInfo(context),
      child: Row(
        children: [
          if (widget.group?.groupImageKey != null)
            FutureBuilder<String>(
              future: getFileUrl(widget.group!.groupImageKey!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: Icon(Icons.group, color: primaryColor),
                );
              },
            )
          else
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Icon(Icons.group, color: primaryColor),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.groupName ?? 'Group Chat',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.participants.length} members',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOneToOneChatTitle() {
    final otherUser = widget.participants.first;
    return Row(
      children: [
        FutureBuilder<String>(
          future: getFileUrl(otherUser.profileImageKey!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CircleAvatar(
                backgroundImage:
                    snapshot.data != null ? NetworkImage(snapshot.data!) : null,
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          },
        ),
        // CircleAvatar(
        //   backgroundImage: otherUser.profileImageKey != null
        //     ?  NetworkImage(otherUser.profileImageKey!)
        //     : null,
        // ),
        SizedBox(width: 8),
        Text(otherUser.username ?? '',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
      ],
    );
  }

  void _showGroupInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: GroupInfoScreen(
            group: widget.group!,
            currentUser: widget.currentUser,
            // participants: widget.participants,
            // scrollController: controller,
            // onAddMembers: _viewModel.isAdmin ? _showAddMembersDialog : null,
            // onRemoveMembers: _viewModel.isAdmin ? _showRemoveMembersDialog : null,
          ),
        ),
      ),
    );
  }
  List<GroupEvent> events = [];
  Future<void> _loadEvents() async {
    try {
      final request = ModelQueries.list(
        GroupEvent.classType,
        where: GroupEvent.GROUP.contains(widget.group!.id),
      );
      final response = await Amplify.API.query(request: request).response;
      events = response.data?.items.whereType<GroupEvent>().toList() ?? [];
      
      // Sort events by start time
      events.sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  void _showCreateEventDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateEventDialog(
        group: widget.group!,
        currentUser: widget.currentUser,
        onCreateEvent: (title, description, startTime, endTime, eventType, location) async {
          try {
            final event = GroupEvent(
              title: title,
              description: description,
              location: location,
              startTime: TemporalDateTime(startTime),
              endTime: TemporalDateTime(endTime),
              eventType: eventType,
              group: widget.group!,
              creator: widget.currentUser,
            );

            await Amplify.API.mutate(
              request: ModelMutations.create(event),
            ).response;

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

  Widget _buildMessagesList() {
    return Consumer<ChatViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: primaryColor),
                SizedBox(height: 16),
                Text('Loading messages...'),
              ],
            ),
          );
        }
        if (viewModel.messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Start a conversation!',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'),
                  onPressed: viewModel.loadInitialMessages,
                ),
              ],
            ),
          );
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
              sender: isMyMessage
                  ? widget.currentUser
                  : widget.participants
                      .firstWhere((p) => p.id == message.sender.id),
            );
          },
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.attach_file, color: primaryColor),
                onPressed: _handleAttachment,
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.lightbulb_outline,
                        color: _showSuggestionOptions ? primaryColor : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _showSuggestionOptions = !_showSuggestionOptions;
                        });
                      },
                      tooltip: 'Get suggestions',
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: primaryColor),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionOptions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Suggestions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() {
                    _showSuggestionOptions = false;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.ice_skating,color: Colors.black,),
                  label: Text('Ice Breakers'),
                  onPressed: _getIceBreakerSuggestions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    foregroundColor: Colors.blue[800],
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.question_answer),
                  label: Text('Reply Help'),
                  onPressed: _getReplyHelp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[100],
                    foregroundColor: Colors.green[800],
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
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
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      await _viewModel.handleAttachment();
      
      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();
    } catch (e) {
      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();
      
      print('Error handling attachment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload attachment')),
      );
    }
  }

  Future<void> _getIceBreakerSuggestions() async {
    try {
      final otherUser = widget.participants.first;
      final interests = otherUser.interests ?? [];
      final hobbies = otherUser.hobbies ?? [];
      
      setState(() {
        _showSuggestionOptions = false;
      });
      
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LoadingDialog(message: 'Generating ice breakers...'),
      );
      
      final suggestions = await _viewModel.getIceBreakerSuggestions(interests, hobbies);
      
      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();
      
      if (suggestions.isNotEmpty) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => MultipleSuggestionsSheet(
            title: 'Ice Breaker Suggestions',
            suggestions: suggestions,
            onSelect: (suggestion) {
              _messageController.text = suggestion;
              Navigator.pop(context);
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not generate suggestions. Please try again.')),
        );
      }
    } catch (e) {
      // Make sure to close the loading dialog if there's an error
      Navigator.of(context, rootNavigator: true).pop();
      print('Error getting ice breakers: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get suggestions. Please check your connection.')),
      );
    }
  }

  Future<void> _getReplyHelp() async {
    try {
      if (_viewModel.messages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No messages to analyze')),
        );
        return;
      }
      
      setState(() {
        _showSuggestionOptions = false;
      });
      
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LoadingDialog(message: 'Generating reply suggestions...'),
      );
      
      // Get last few messages for context
      final recentMessages = _viewModel.messages
          .where((m) => m.mediaType == 'text')
          .take(5)
          .map((m) => '${m.sender.username}: ${m.content}')
          .join('\n');
      
      final suggestions = await _viewModel.getReplyHelp(recentMessages);
      
      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();
      
      if (suggestions.isNotEmpty) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => MultipleSuggestionsSheet(
            title: 'Reply Suggestions',
            suggestions: suggestions,
            onSelect: (suggestion) {
              _messageController.text = suggestion;
              Navigator.pop(context);
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not generate suggestions. Please try again.')),
        );
      }
    } catch (e) {
      // Make sure to close the loading dialog if there's an error
      Navigator.of(context, rootNavigator: true).pop();
      print('Error getting reply help: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get suggestions. Please check your connection.')),
      );
    }
  }

  void _showAddMembersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Members'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add your user selection UI here
            // This could be a list of users or a search field
            Text('Select users to add to the group'),
            // Example: List of users to add
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Get selected users from your UI
                List<User> selectedUsers = []; // Populate this from your UI
                await _viewModel.updateGroupMembers(
                  addUsers: selectedUsers,
                  removeUsers: [],
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Members added successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add members: $e')),
                );
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showRemoveMembersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Members'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.participants.isEmpty)
              Text('No members to remove')
            else
              ...widget.participants.map((user) => CheckboxListTile(
                title: Text(user.username ?? 'Unknown User'),
                subtitle: Text(user.email ?? ''),
                value: false, // You might want to track selection state
                onChanged: (bool? value) {
                  // Handle selection
                },
              )).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Get selected users from your UI
                List<User> selectedUser = []; // Populate this from your UI
                await _viewModel.updateGroupMembers(
                  addUsers: [],
                  removeUsers: selectedUser,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Members removed successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to remove members: $e')),
                );
              }
            },
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class LoadingDialog extends StatelessWidget {
  final String message;
  
  const LoadingDialog({
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: primaryColor),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class MultipleSuggestionsSheet extends StatelessWidget {
  final String title;
  final List<String> suggestions;
  final Function(String) onSelect;

  const MultipleSuggestionsSheet({
    required this.title,
    required this.suggestions,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: suggestions.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return SuggestionCard(
                  suggestion: suggestions[index],
                  onSelect: () => onSelect(suggestions[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestionCard extends StatelessWidget {
  final String suggestion;
  final VoidCallback onSelect;

  const SuggestionCard({
    required this.suggestion,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              suggestion,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onSelect,
                child: Text('Use This'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupInfoSheet extends StatelessWidget {
  final Group group;
  final User currentUser;
  final List<User> participants;
  final ScrollController scrollController;
  final Function()? onAddMembers;
  final Function()? onRemoveMembers;

  const GroupInfoSheet({
    required this.group,
    required this.currentUser,
    required this.participants,
    required this.scrollController,
    this.onAddMembers,
    this.onRemoveMembers,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.all(16),
      children: [
        _buildHeader(),
        SizedBox(height: 24),
        _buildGroupDetails(),
        SizedBox(height: 24),
        _buildMembersList(),
        SizedBox(height: 24),
        _buildEventsList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 4,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        if (group.groupImageKey != null)
          FutureBuilder<String>(
            future: getFileUrl(group.groupImageKey!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(snapshot.data!),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          )
        else
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: Icon(Icons.group, size: 50, color: primaryColor),
          ),
        SizedBox(height: 16),
        Text(
          group.name ?? 'Group Chat',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          group.description ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildGroupDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        if (group.interests != null && group.interests!.isNotEmpty)
          _buildDetailSection('Interests', group.interests!),
        if (group.hobbies != null && group.hobbies!.isNotEmpty)
          _buildDetailSection('Hobbies', group.hobbies!),
        if (group.locationName != null)
          ListTile(
            leading: Icon(Icons.location_on, color: primaryColor),
            title: Text('Location'),
            subtitle: Text(group.locationName!),
          ),
      ],
    );
  }

  Widget _buildDetailSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => Chip(
            label: Text(item),
            backgroundColor: primaryColor.withOpacity(0.1),
          )).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMembersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Members',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onAddMembers != null)
              TextButton.icon(
                icon: Icon(Icons.person_add),
                label: Text('Add'),
                onPressed: onAddMembers,
              ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: participants.length,
          itemBuilder: (context, index) {
            final user = participants[index];
            final isAdmin = user.id == group.admin.id;
            
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.profileImageKey != null
                    ? NetworkImage(user.profileImageKey!)
                    : null,
                child: user.profileImageKey == null
                    ? Text(user.username?[0] ?? '')
                    : null,
              ),
              title: Text(user.username ?? ''),
              subtitle: Text(isAdmin ? 'Admin' : 'Member'),
              trailing: onRemoveMembers != null &&
                      !isAdmin &&
                      user.id != currentUser.id
                  ? IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: onRemoveMembers,
                    )
                  : null,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventsList() {
    // TODO: Implement events list
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Events',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Text(
            'No events scheduled',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

// class CreateEventDialog extends StatefulWidget {
//   final Function(String title, String description, DateTime startTime,
//       DateTime endTime, String location) onCreateEvent;

//   const CreateEventDialog({
//     required this.onCreateEvent,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<CreateEventDialog> createState() => _CreateEventDialogState();
// }

// class _CreateEventDialogState extends State<CreateEventDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _locationController = TextEditingController();
//   DateTime? _startTime;
//   DateTime? _endTime;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Create Event'),
//       content: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter a title' : null,
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter a description' : null,
//               ),
//               TextFormField(
//                 controller: _locationController,
//                 decoration: InputDecoration(labelText: 'Location'),
//                 validator: (value) =>
//                     value?.isEmpty ?? true ? 'Please enter a location' : null,
//               ),
//               ListTile(
//                 title: Text('Start Time'),
//                 subtitle: Text(_startTime?.toString() ?? 'Not set'),
//                 onTap: () async {
//                   final date = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime.now().add(Duration(days: 365)),
//                   );
//                   if (date != null) {
//                     final time = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.now(),
//                     );
//                     if (time != null) {
//                       setState(() {
//                         _startTime = DateTime(
//                           date.year,
//                           date.month,
//                           date.day,
//                           time.hour,
//                           time.minute,
//                         );
//                       });
//                     }
//                   }
//                 },
//               ),
//               ListTile(
//                 title: Text('End Time'),
//                 subtitle: Text(_endTime?.toString() ?? 'Not set'),
//                 onTap: () async {
//                   final date = await showDatePicker(
//                     context: context,
//                     initialDate: _startTime ?? DateTime.now(),
//                     firstDate: _startTime ?? DateTime.now(),
//                     lastDate: DateTime.now().add(Duration(days: 365)),
//                   );
//                   if (date != null) {
//                     final time = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.now(),
//                     );
//                     if (time != null) {
//                       setState(() {
//                         _endTime = DateTime(
//                           date.year,
//                           date.month,
//                           date.day,
//                           time.hour,
//                           time.minute,
//                         );
//                       });
//                     }
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (_formKey.currentState?.validate() ?? false) {
//               if (_startTime == null || _endTime == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Please select start and end times')),
//                 );
//                 return;
//               }
//               widget.onCreateEvent(
//                 _titleController.text,
//                 _descriptionController.text,
//                 _startTime!,
//                 _endTime!,
//                 _locationController.text,
//               );
//             }
//           },
//           child: Text('Create'),
//         ),
//       ],
//     );
//   }
// }

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
      child: Column(
        crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMyMessage) ...[
                FutureBuilder<String>(
                  future: getFileUrl(sender.profileImageKey!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data!),
                        radius: 16,
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.mediaType == 'image' 
                        ? Colors.transparent 
                        : (isMyMessage ? Colors.blue : Colors.grey[200]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _buildMessageContent(),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, left: 8, right: 8),
            child: Text(
              _formatDateTime(message.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(TemporalDateTime? dateTime) {
    if (dateTime == null) {
      // Return current time as a fallback for existing messages without timestamps
      final now = DateTime.now();
      return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }
    
    try {
      final now = DateTime.now();
      final messageDate = dateTime.getDateTimeInUtc();
      final difference = now.difference(messageDate);
      
      if (difference.inDays == 0) {
        // Today, show time only
        return '${messageDate.hour.toString().padLeft(2, '0')}:${messageDate.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        // Yesterday
        return 'Yesterday, ${messageDate.hour.toString().padLeft(2, '0')}:${messageDate.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays < 7) {
        // Within a week
        final weekday = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][messageDate.weekday - 1];
        return '$weekday, ${messageDate.hour.toString().padLeft(2, '0')}:${messageDate.minute.toString().padLeft(2, '0')}';
      } else {
        // Older messages
        return '${messageDate.day}/${messageDate.month}/${messageDate.year}, ${messageDate.hour.toString().padLeft(2, '0')}:${messageDate.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      print('Error formatting date: $e');
      return 'Just now'; // Fallback text
    }
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
      return FutureBuilder<String>(
        future: getFileUrl(message.mediaKey!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () => _showImagePreview(snapshot.data!, context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        },
      );
    } else if (message.mediaType == 'video' && message.mediaKey != null) {
      return FutureBuilder<String>(
        future: getFileUrl(message.mediaKey!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () => _showVideoPlayer(snapshot.data!, context),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.video_library),
                    SizedBox(width: 8),
                    Flexible(child: Text(message.content ?? 'Video')),
                  ],
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        },
      );
    } else {
      // For other file types (documents, audio, etc.)
      return FutureBuilder<String>(
        future: getFileUrl(message.mediaKey!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () => _openFile(snapshot.data!, message.content ?? '', context),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file),
                    SizedBox(width: 8),
                    Flexible(child: Text(message.content ?? 'File')),
                  ],
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        },
      );
    }
  }

  void _showImagePreview(String imageUrl, context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PhotoView(
                imageProvider: NetworkImage(imageUrl),
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

  void _showVideoPlayer(String videoUrl, context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: VideoPlayerWidget(videoUrl: videoUrl),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openFile(String fileUrl, String fileName, context) async {
    // Implement file opening logic using url_launcher or other plugins
    // You might want to download the file first for certain file types
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $fileName...')),
    );
  }
}
