import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/models/GroupEvent.dart';
import 'package:intl/intl.dart';

class CreateEventDialog extends StatefulWidget {
  final Group group;
  final User currentUser;
  final Future<bool> Function(String title, String description, DateTime startTime, 
      DateTime endTime, String eventType, String location) onCreateEvent;

  const CreateEventDialog({
    required this.group,
    required this.currentUser,
    required this.onCreateEvent,
    Key? key,
  }) : super(key: key);

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(hours: 2));
  String _eventType = 'meetup';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _eventTypes = [
    {
      'type': 'meetup',
      'icon': Icons.people,
      'title': 'Meetup',
      'description': 'Casual gathering to meet and socialize'
    },
    {
      'type': 'activity',
      'icon': Icons.sports,
      'title': 'Activity',
      'description': 'Sports, games, or other group activities'
    },
    {
      'type': 'workshop',
      'icon': Icons.school,
      'title': 'Workshop',
      'description': 'Learning and skill-sharing sessions'
    },
    {
      'type': 'other',
      'icon': Icons.event,
      'title': 'Other',
      'description': 'Custom event type'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: 0.9.sw,
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                SizedBox(height: 24.h),
                _buildEventTypeSelector(),
                SizedBox(height: 24.h),
                _buildBasicInfo(),
                SizedBox(height: 24.h),
                _buildDateTimePickers(),
                SizedBox(height: 24.h),
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
        Icon(
          Icons.event_available,
          size: 48.sp,
          color: primaryColor,
        ),
        SizedBox(height: 16.h),
        Text(
          'Create Group Event',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Plan something amazing with your group members!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEventTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Type',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _eventTypes.length,
            itemBuilder: (context, index) {
              final type = _eventTypes[index];
              final isSelected = _eventType == type['type'];
              
              return GestureDetector(
                onTap: () => setState(() => _eventType = type['type']),
                child: Container(
                  width: 100.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        type['icon'],
                        color: isSelected ? Colors.white : Colors.grey[600],
                        size: 32.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        type['title'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          _eventTypes.firstWhere((t) => t['type'] == _eventType)['description'],
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Event Title',
            hintText: 'Give your event a catchy name',
            prefixIcon: Icon(Icons.title),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter an event title';
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
            hintText: 'What\'s this event about?',
            prefixIcon: Icon(Icons.description),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter an event description';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Location',
            hintText: 'Where will this event take place?',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter an event location';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateTimePickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Schedule',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildDateTimeTile(
                icon: Icons.event,
                title: 'Start',
                value: _formatDateTime(_startDate),
                onTap: () => _selectDateTime(true),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildDateTimeTile(
                icon: Icons.event_available,
                title: 'End',
                value: _formatDateTime(_endDate),
                onTap: () => _selectDateTime(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateTimeTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16.sp, color: primaryColor),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}\n${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDateTime(bool isStart) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: isStart ? DateTime.now() : _startDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStart ? _startDate : _endDate),
      );

      if (time != null) {
        setState(() {
          final newDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          
          if (isStart) {
            _startDate = newDateTime;
            if (_endDate.isBefore(_startDate)) {
              _endDate = _startDate.add(Duration(hours: 2));
            }
          } else {
            _endDate = newDateTime;
          }
        });
      }
    }
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        SizedBox(width: 16.w),
        ElevatedButton(
          onPressed: _isLoading ? null : _createEvent,
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
              : Text('Create Event'),
        ),
      ],
    );
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final success = await widget.onCreateEvent(
        _titleController.text,
        _descriptionController.text,
        _startDate,
        _endDate,
        _eventType,
        _locationController.text,
      );

      if (success) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error creating event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating event')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
} 