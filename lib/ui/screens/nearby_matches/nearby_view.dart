import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/friend_zone/nearby_screen.dart';
import 'package:code_structure/ui/screens/nearby_matches/nearby_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NearbyScreeViewModel(),
      child: Consumer<NearbyScreeViewModel>(
          builder: (context, model, child) => Scaffold(
                ///
                /// App Bar
                ///
                appBar: _appBar(context),

                ///
                /// Start Body
                ///
                body: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 1.2),
                  itemCount: model.listNearbyScreen.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: CustomNearbyWidget(
                          Object_nearby: model.listNearbyScreen[index]),
                    );
                  },
                ),
              )),
    );
  }
}

_appBar(BuildContext context) {
  return AppBar(
    backgroundColor: whiteColor,
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: blackColor,
        )),
    title: Text(
      "Nearby Matches",
      style: style24B.copyWith(color: blackColor),
    ),
  );
}
