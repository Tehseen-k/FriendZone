import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/model/nearby_model.dart';
import 'package:code_structure/core/others/base_view_model.dart';

class NearbyScreeViewModel extends BaseViewModel {
  List<NearbyScreenModel> listNearbyScreen = [
    NearbyScreenModel(
        imgUrl: AppAssets().nearby1,
        groupName: "Hikking",
        day: "sunday",
        time: "12:00 PM ",
        message: "join us for local eventss"),
    NearbyScreenModel(
        imgUrl: AppAssets().nearby1,
        groupName: "Hikking",
        day: "sunday",
        time: "12:00 PM ",
        message: "join us for local eventss"),
    NearbyScreenModel(
        imgUrl: AppAssets().nearby1,
        groupName: "Hikking",
        day: "sunday",
        time: "12:00 PM ",
        message: "join us for local eventss"),
    NearbyScreenModel(
        imgUrl: AppAssets().nearby1,
        groupName: "Hikking",
        day: "sunday",
        time: "12:00 PM ",
        message: "join us for local eventss"),
  ];
}
