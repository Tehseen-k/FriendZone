import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:code_structure/models/GroupEvent.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final GroupEvent event;
  final VoidCallback onTap;
  final bool isUpcoming;

  const EventCard({
    required this.event,
    required this.onTap,
    this.isUpcoming = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startTime = event.startTime.getDateTimeInUtc();
    final endTime = event.endTime.getDateTimeInUtc();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image or Type Icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: event.mediaKeys?.isNotEmpty ?? false
                      ? Image.network(
                          event.mediaKeys!.first,
                          height: 120.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 120.h,
                          width: double.infinity,
                          color: _getEventTypeColor(event.eventType).withOpacity(0.1),
                          child: Icon(
                            _getEventTypeIcon(event.eventType),
                            size: 48.sp,
                            color: _getEventTypeColor(event.eventType),
                          ),
                        ),
                ),
                // Event Type Badge
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getEventTypeColor(event.eventType),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      event.eventType.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  
                  // Date and Time
                  SizedBox(width: 250.w,child:      Row(
                    children: [
                      Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      SizedBox(width: 200.w,child:  Text(
                        _formatDateTime(startTime, endTime),
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),)
                     ,
                    ],
                  ),),
             
                  SizedBox(height: 4.h),
                  
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  // Group Name
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.group, size: 16.sp, color: primaryColor),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          'By ${event.group.name}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  String _formatDateTime(DateTime start, DateTime end) {
    final dateFormat = DateFormat('MMM d');
    final timeFormat = DateFormat('h:mm a');
    
    if (start.day == end.day) {
      return '${dateFormat.format(start)} · ${timeFormat.format(start)} - ${timeFormat.format(end)}';
    } else {
      return '${dateFormat.format(start)} ${timeFormat.format(start)} - ${dateFormat.format(end)} ${timeFormat.format(end)}';
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