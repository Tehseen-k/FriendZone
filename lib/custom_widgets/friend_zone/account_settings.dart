import 'package:code_structure/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomAccountSettingWidget extends StatefulWidget {
  final Icon icon;
  final String? title;
  CustomAccountSettingWidget({required this.icon, this.title});

  @override
  State<CustomAccountSettingWidget> createState() =>
      _CustomAccountSettingWidgetState();
}

class _CustomAccountSettingWidgetState
    extends State<CustomAccountSettingWidget> {
  bool _IsSelected = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void OnClick() {
    setState(() {
      _IsSelected = !_IsSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: GestureDetector(
          onTap: () {
            OnClick();
          },
          child: widget.icon,
        ),
        iconColor: _IsSelected ? buttonColor : Colors.grey[800],
        title: Text(widget.title!));
  }
}
