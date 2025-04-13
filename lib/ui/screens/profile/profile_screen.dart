import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:code_structure/main.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/ui/screens/setup_profile/setup_profile_screen.dart';
import 'package:code_structure/ui/screens/home_screen/home_veiw_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.grey[700]),
            onPressed: () {
              // TODO: Add settings functionality later
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              // Profile Image Section
              _buildProfileImageWithPreview(context, userModel!),
              SizedBox(height: 20.h),

              // User Info Section
              Text(
                userModel?.username ?? 'User Name',
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                userModel?.email ?? 'user@example.com',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16.h),

              // Bio Section
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  userModel?.introduction ?? 'No bio added yet.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32.h),

              // Action Buttons
              _buildActionButton(
                icon: Icons.edit,
                text: 'View Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetupProfileScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              _buildActionButton(
                icon: Icons.help_outline,
                text: 'Help & Support',
                onPressed: () {
                  launchURL(
                      'https://www.freeprivacypolicy.com/live/644989b1-30df-4fa9-946b-09e7359ca508');
                },
              ),
              SizedBox(height: 32.h),

              // Legal Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLinkButton(
                    text: 'Privacy Policy',
                    onTap: () => launchURL(
                        'https://www.freeprivacypolicy.com/live/644989b1-30df-4fa9-946b-09e7359ca508'),
                  ),
                  _buildLinkButton(
                    text: 'Terms',
                    onTap: () => launchURL(
                        'https://www.freeprivacypolicy.com/live/644989b1-30df-4fa9-946b-09e7359ca508'),
                  ),
                ],
              ),
              SizedBox(height: 40.h),

              // Logout Button
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Profile Image Widget
  Widget _buildProfileImageWithPreview(BuildContext context, User userModel) {
    return userModel.profileImageKey != null
        ? FutureBuilder<String>(
            future: getFileUrl(userModel.profileImageKey!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () => showImagePreview(snapshot.data!, context),
                  child: Hero(
                    tag: 'profileImage',
                    child: CircleAvatar(
                      radius: 70.r,
                      backgroundImage: NetworkImage(snapshot.data!),
                    ),
                  ),
                );
              }
              return CircleAvatar(
                radius: 70.r,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 50, color: Colors.white),
              );
            },
          )
        : CircleAvatar(
            radius: 70.r,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 50, color: Colors.white),
          );
  }

  // Action Button Widget (Edit Profile, Help & Support)
  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue[600]),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Link Button Widget (Privacy, Terms)
  Widget _buildLinkButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.blue[600]!),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.blue[600],
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Logout Button Widget
  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _signOut();
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[600],
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        'Logout',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper Functions
  Future<void> _signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
