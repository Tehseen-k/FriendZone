import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/strings.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class OrganizeActivityScreen extends StatefulWidget {
  @override
  State<OrganizeActivityScreen> createState() => _OrganizeActivityScreenState();
}

class _OrganizeActivityScreenState extends State<OrganizeActivityScreen> {
  // Checkbox states for the summary section
  bool isActivityNameChecked = false;
  bool isDescriptionChecked = false;
  bool isDateTimeChecked = false;
  bool isMembersChecked = false;
  bool isRemindersChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Organize Your Activity",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Name Input
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.title),
                hintText: "Enter activity name (e.g., Weekend Hike)",
                filled: true,
                fillColor: blackColor.withOpacity(0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Activity Description Input
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.info_outline),
                hintText: "Add a description or agenda for the activity",
                filled: true,
                fillColor: blackColor.withOpacity(0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Select Date and Time
            GestureDetector(
              onTap: () {
                // Handle Date Picker
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: blackColor.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Select Date and Time",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      "Date & Time Picker",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Invite Members Section
            const Text(
              "Invite Members",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search Members",
                filled: true,
                fillColor: blackColor.withOpacity(0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1,
              ),
              itemCount: 8, // Number of members
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                          "$dynamicAssets/match2.png"), // Replace with your images
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Member ${index + 1}",
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            // Reminder Settings
            const Text(
              "Reminder Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildToggleRow("Send Reminder 1 Hour Before", true),
            const SizedBox(height: 8),
            _buildToggleRow("Send Reminder 1 Day Before", false),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Handle Custom Reminder
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: blackColor.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Custom Reminder",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      "Set Time",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Handle Notification Method
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: blackColor.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Notification Method",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      "Push/Email",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Summary Section
            const Text(
              "Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildSummaryRow("Activity Name", isActivityNameChecked),
            _buildSummaryRow("Description", isDescriptionChecked),
            _buildSummaryRow("Date & Time", isDateTimeChecked),
            _buildSummaryRow("Members", isMembersChecked),
            _buildSummaryRow("Reminders", isRemindersChecked),
            const SizedBox(height: 24),
            // Buttons
            // Buttons
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                "Send Invites",
                style: style16B.copyWith(color: whiteColor),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                "Save as Draft",
                style: style16B.copyWith(color: blueColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool isEnabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(
          value: isEnabled,
          onChanged: (value) {
            // Handle toggle change
          },
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String title, bool isChecked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  if (title == "Activity Name") isActivityNameChecked = value!;
                  if (title == "Description") isDescriptionChecked = value!;
                  if (title == "Date & Time") isDateTimeChecked = value!;
                  if (title == "Members") isMembersChecked = value!;
                  if (title == "Reminders") isRemindersChecked = value!;
                });
              },
            ),
            Text(title),
          ],
        ),
        Text(
          title == "Activity Name"
              ? "Weekend Hike"
              : title == "Description"
                  ? "A hike through the mountains"
                  : title == "Date & Time"
                      ? "12th Dec, 10:00 AM"
                      : title == "Members"
                          ? "3 Selected"
                          : "1 Hour Before, 1 Day Before",
        ),
      ],
    );
  }
}
