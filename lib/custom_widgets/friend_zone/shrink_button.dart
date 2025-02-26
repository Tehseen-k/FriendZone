import 'package:flutter/material.dart';

import 'package:code_structure/core/constants/colors.dart';

class CustomShrinkButton extends StatefulWidget {
  final String text; // String for the button text
  final Icon icon; // Icon for the button

  const CustomShrinkButton({
    super.key,
    required this.icon, // Required icon
    required this.text, // Required text
  });

  @override
  State<CustomShrinkButton> createState() => _CustomShrinkButtonState();
}

class _CustomShrinkButtonState extends State<CustomShrinkButton> {
  bool _isSelected = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onClick() {
    setState(() {
      _isSelected = !_isSelected;
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
                height: screenHeight * 0.06,
                width: screenWidth * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: borderColor.withOpacity(0.20),
                  ),
                  color: _isSelected ? buttonColor : Colors.grey[500],
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
