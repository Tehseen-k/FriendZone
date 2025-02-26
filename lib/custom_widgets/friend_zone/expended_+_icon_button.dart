import 'package:flutter/material.dart';

import 'package:code_structure/core/constants/colors.dart';

class CustomExpend_Icon_Button extends StatefulWidget {
  final String text; // String for the button text
  final Icon icon; // Icon for the button

  const CustomExpend_Icon_Button({super.key, 
    required this.icon, // Required icon
    required this.text, // Required text
  });

  @override
  State<CustomExpend_Icon_Button> createState() => _CustomExpendButtonState();
}

class _CustomExpendButtonState extends State<CustomExpend_Icon_Button> {
  bool isSelected = true;
  @override
  void initState() {
    super.initState();
  }

  void onClick() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: GestureDetector(
        onTap: () {
          onClick();
        }, // Call the onTap function passed during widget creation
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            children: [
              Container(
                height: screenHeight * 0.05,
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: borderColor.withOpacity(0.20),
                  ),
                  color: isSelected ? buttonColor : Colors.grey,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.icon,
                      SizedBox(width: 8),
                      Text(
                        widget.text,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
