// ignore_for_file: deprecated_member_use

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/strings.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/friend_zone/key_factor_CS.dart';
import 'package:code_structure/main.dart';
import 'package:code_structure/models/ModelProvider.dart';
import 'package:code_structure/ui/screens/compatibility_screen/compatibility_score_view_model.dart';
import 'package:code_structure/ui/screens/home_screen/home_veiw_model.dart';
import 'package:code_structure/ui/screens/user_profile_screen/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CompatibiltyScore extends StatefulWidget {
  User matchedUser;
   CompatibiltyScore({super.key, required this.matchedUser});

  @override
  State<CompatibiltyScore> createState() => _CompatibiltyScoreState();
}

class _CompatibiltyScoreState extends State<CompatibiltyScore> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => KeyFactorCSViewModel(),
      child: Consumer<KeyFactorCSViewModel>(
        builder: (context, model, child) {
          final compatibilityScore = calculateCompatibilityScore(widget.matchedUser);
          
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///
                  /// Start from there
                  ///
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: blackColor,
                            )),
                        Text(
                          "Compatibility",
                          style: style24B.copyWith(color: blackColor),
                        ),
                      ],
                    ),
                  ),

                  ///
                  /// Header
                  ///

                  CompatibilityCard(
                    matchedUser: widget.matchedUser,
                    compatibilityScore: compatibilityScore,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Key Factors",
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),

                  ///
                  /// GridView Data Source
                  ///

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.5,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemCount: model.listKeyFactoCS.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: CustomKeyFactorCompatibilityScoreWidget(
                              Object_KeyFactorCS:
                                  model.listKeyFactoCS[index]),
                        );
                      },
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text(
                  //       "add user profile type info check in Figma i made a custom widget but ..."),
                  // ),
                  // 20.verticalSpace,

                  ///
                  /// Custom Button
                  ///
                  //   CustomButton(
                  //     name: "Add to Network",
                  //     onPressed: () {},
                  //     textColor: whiteCoolor,
                  //   ),

                  //   20.verticalSpace,
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Text(
                  //       "Actionable Tips",
                  //       style: GoogleFonts.nunito(
                  //           fontWeight: FontWeight.w800, fontSize: 17),
                  //     ),
                  //   ),

                  //   Center(
                  //     child: SizedBox(
                  //       width: 350.w,
                  //       child: Divider(
                  //         height: 1,
                  //         color: Colors.grey[300],
                  //       ),
                  //     ),
                  //   ),
                  //   SizedBox(
                  //     height: 400.h,
                  //     child: Text(
                  //         "add tips idk how dynamically it is add how many tips user want to add "),
                  //   ),
                  //   20.verticalSpace,
                  //   CustomExpend_Icon_Button(
                  //       icon: Icon(Icons.info_outline),
                  //       text: "View More Details"),
                  //   20.verticalSpace,
                  //   CustomExpend_Icon_Button(
                  //       icon: Icon(Icons.message), text: "Send a Message,"),
                  //   120.verticalSpace
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CompatibilityCard extends StatefulWidget {
  final User matchedUser;
  final double compatibilityScore;

  const CompatibilityCard({
    required this.matchedUser,
    required this.compatibilityScore,
    Key? key,
  }) : super(key: key);

  @override
  State<CompatibilityCard> createState() => _CompatibilityCardState();
}

class _CompatibilityCardState extends State<CompatibilityCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final compatibilityScore = widget.compatibilityScore;
    
    // Calculate common interests and hobbies
    final commonInterests = userModel?.interests
        ?.where((interest) => widget.matchedUser.interests?.contains(interest) ?? false)
        .toList() ?? [];
    
    final commonHobbies = userModel?.hobbies
        ?.where((hobby) => widget.matchedUser.hobbies?.contains(hobby) ?? false)
        .toList() ?? [];

    // Calculate distance
    final distance = calculateDistance(
      userModel?.latitude ?? 0,
      userModel?.longitude ?? 0,
      widget.matchedUser.latitude ?? 0,
      widget.matchedUser.longitude ?? 0,
    );

    return Column(
      children: [
        // Original compatibility card with updated score
        Container(
          width: double.infinity,
          height: 200,
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.0),
                Colors.black.withOpacity(0.60)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Background Blur Image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    '$staticAssets/image.png', // Add your background image in assets folder
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.80),
                        Colors.black.withOpacity(0.75),
                        Colors.white.withOpacity(0.50),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: blackColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Compatibility",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: blackColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Score",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                        widget.matchedUser.profileImageKey != null
                                  ?    FutureBuilder<String>(
                          future: getFileUrl(widget.matchedUser.profileImageKey!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return 
                              Hero(
                                tag: 'profileImage',
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!),
                                  radius: 25,
                                ),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            );
                          },
                        ):
                     
                            CircleAvatar(
                              radius: 25,
                            
                              child:Icon(Icons.person, color: Colors.white)
                                  ,
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.matchedUser.username ?? "User",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${compatibilityScore.toStringAsFixed(0)}% Match",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: buttonColor,
                              child: Icon(Icons.check, color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Match",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        ),
                        20.horizontalSpace,
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(2.5),
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

        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                buttonColor.withOpacity(0.05),
                Colors.white,
                buttonColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Distance indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: buttonColor, size: 20),
                  SizedBox(width: 4),
                  Text(
                    "${distance.toStringAsFixed(1)} km away",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: buttonColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Compact interests and hobbies section
              if (commonInterests.isNotEmpty || commonHobbies.isNotEmpty)
                AnimatedCrossFade(
                  firstChild: _buildCompactView(commonInterests, commonHobbies),
                  secondChild: _buildExpandedView(commonInterests, commonHobbies),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 300),
                ),

              SizedBox(height: 16),
              
              // Add the communication style card here
              _buildCommunicationStyleCard(commonInterests),
              
              SizedBox(height: 16),
              
              // View Full Profile button
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF6A11CB), // Deep purple
                        Color(0xFF2575FC), // Bright blue
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2575FC).withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfileScreen(matchedUser: widget.matchedUser,compatibilityScore: compatibilityScore,)));
                  
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "View Full Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactView(List<String> interests, List<String> hobbies) {
    final totalItems = interests.length + hobbies.length;
    final displayCount = 3;
    final remainingCount = totalItems - displayCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: [
            ...interests.take(displayCount).map((interest) => _buildChip(interest)),
            if (remainingCount > 0)
              GestureDetector(
                onTap: () => setState(() => _isExpanded = true),
                child: Chip(
                  label: Text('+$remainingCount more'),
                  backgroundColor: buttonColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: buttonColor),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedView(List<String> interests, List<String> hobbies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (interests.isNotEmpty) ...[
          Text(
            "Common Interests",
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: buttonColor,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: interests.map((i) => _buildChip(i)).toList(),
          ),
        ],
        if (hobbies.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            "Common Hobbies",
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: buttonColor,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: hobbies.map((h) => _buildChip(h)).toList(),
          ),
        ],
        Center(
          child: TextButton(
            onPressed: () => setState(() => _isExpanded = false),
            child: Text(
              "Show less",
              style: TextStyle(color: buttonColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: buttonColor, fontSize: 12),
      ),
      backgroundColor: buttonColor.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _suggestCommunicationStyle(List<String> commonInterests) {
    // Define communication style categories
    final Map<String, List<String>> communicationCategories = {
      'Intellectual': ['books', 'science', 'philosophy', 'education', 'technology', 'research'],
      'Creative': ['art', 'music', 'writing', 'photography', 'design', 'crafts'],
      'Active': ['sports', 'fitness', 'outdoor', 'adventure', 'travel', 'hiking'],
      'Social': ['networking', 'community', 'volunteering', 'events', 'socializing'],
      'Professional': ['business', 'career', 'entrepreneurship', 'leadership', 'finance']
    };

    // Count matches in each category
    Map<String, int> categoryScores = {};
    for (var interest in commonInterests) {
      for (var category in communicationCategories.entries) {
        if (category.value.any((keyword) => 
            interest.toLowerCase().contains(keyword.toLowerCase()))) {
          categoryScores[category.key] = (categoryScores[category.key] ?? 0) + 1;
        }
      }
    }

    // Default suggestion
    if (categoryScores.isEmpty) {
      return "Start with casual conversation to discover common ground";
    }

    // Get the dominant communication style
    var dominantStyle = categoryScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Return specific suggestions based on dominant style
    switch (dominantStyle) {
      case 'Intellectual':
        return "Share thought-provoking ideas and engage in deep discussions";
      case 'Creative':
        return "Express yourself through creative exchanges and artistic perspectives";
      case 'Active':
        return "Plan activity-based conversations and share experiences";
      case 'Social':
        return "Focus on building connections through shared social interests";
      case 'Professional':
        return "Exchange professional insights and career experiences";
      default:
        return "Start with casual conversation to discover common ground";
    }
  }

  Widget _buildCommunicationStyleCard(List<String> commonInterests) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE0C3FC), // Light purple
            Color(0xFF8EC5FC), // Light blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.chat_bubble_outline, 
                  color: Color(0xFF6A11CB), size: 20),
              SizedBox(width: 8),
              Text(
                "Suggested Communication Style",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF6A11CB),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            _suggestCommunicationStyle(commonInterests),
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
