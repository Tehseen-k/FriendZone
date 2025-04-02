import 'package:code_structure/ui/screens/home_screen/home_veiw_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:code_structure/models/Group.dart';
import 'package:code_structure/core/constants/colors.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final double matchScore;
  final VoidCallback onTap;

  const GroupCard({
    required this.group,
    required this.matchScore,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("group interest ${group.interests?.length}");
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
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
              child: group.groupImageKey != null
                  ? FutureBuilder(
                      future: getFileUrl(group.groupImageKey!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.network(
                            snapshot.data!,
                            height: 120.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      })
                  : Container(
                      height: 120.h,
                      alignment: Alignment.center,
                      color: primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 48.sp,
                        color: primaryColor,
                      ),
                    ),
            ),

            // Group Image
            // ClipRRect(
            //   borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            //   child: group.groupImageKey != null
            //       ? Image.network(
            //           group.groupImageKey!,
            //           height: 120.h,
            //           width: double.infinity,
            //           fit: BoxFit.cover,
            //         )
            //       : Container(
            //           height: 120.h,
            //           color: primaryColor.withOpacity(0.1),
            //           child: Icon(Icons.group, size: 48.sp, color: primaryColor),
            //         ),
            // ),

            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group Name and Match Score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          group.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (matchScore > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '${matchScore.toStringAsFixed(0)}% Match',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          group.locationName ?? 'No location',
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
                  SizedBox(height: 8.h),

                  // Interests and Hobbies
                  if (group.interests?.isNotEmpty ?? false) ...[
                    Wrap(
                      spacing: 4.w,
                      runSpacing: 4.h,
                      children: group.interests!.take(3).map((interest) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            interest,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: primaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
