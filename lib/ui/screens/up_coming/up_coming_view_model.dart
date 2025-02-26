import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/model/up_coming_model.dart';
import 'package:code_structure/core/others/base_view_model.dart';

class UpComingViewModel extends BaseViewModel {
  List<UpComingModel> listUpComing = [
    UpComingModel(
        imgUrl: AppAssets().nearby1,
        GroupName: "Hikking",
        day: "sunday",
        time: "12:00 PM ",
        message: "join us for local eventss"),
    UpComingModel(
        imgUrl: AppAssets().nearby1,
        GroupName: "Hikking",
        day: "sunday",
        time: "12:00 PM ",
        message: "join us for local eventss"),
    UpComingModel(
        imgUrl: AppAssets().nearby1,
        GroupName: "Hikking",
        day: "sunday",
        time: "12:00 PM ",
        message: "join us for local eventss"),
    UpComingModel(
        imgUrl: AppAssets().nearby1,
        GroupName: "Hikking",
        day: "sunday",
        time: "12:00 PM ",
        message: "join us for local eventss"),
  ];
}
