import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/model/profile_2_list_model.dart';
import 'package:code_structure/core/model/profile_multimedia.dart';
import 'package:code_structure/core/others/base_view_model.dart';

class ProfileViewModel extends BaseViewModel {
  List<ProfileMultimediaModel> listProfileMultiMedia = [
    ProfileMultimediaModel(
        imgUrl: AppAssets().media, title: "Introduction Vedio"),
    ProfileMultimediaModel(
        imgUrl: AppAssets().media, title: "Introduction Vedio"),
    ProfileMultimediaModel(
        imgUrl: AppAssets().media, title: "Introduction Vedio"),
    ProfileMultimediaModel(
        imgUrl: AppAssets().media, title: "Introduction Vedio"),
    ProfileMultimediaModel(
        imgUrl: AppAssets().media, title: "Introduction Vedio"),
    ProfileMultimediaModel(
        imgUrl: AppAssets().media, title: "Introduction Vedio"),
    ProfileMultimediaModel(
        imgUrl: AppAssets().media, title: "Introduction Vedio"),
    ProfileMultimediaModel(
        imgUrl: AppAssets().media, title: "Introduction Vedio"),
    ProfileMultimediaModel(
        imgUrl: AppAssets().media, title: "Introduction Vedio"),
  ];
  List<Profile2ListModel> listProfile_2_list = [
    Profile2ListModel(imgUrl: AppAssets().verified, tiitle: "Verified"),
    Profile2ListModel(
        imgUrl: AppAssets().topcontributor, tiitle: "Top ContributorV"),
    Profile2ListModel(imgUrl: AppAssets().verified, tiitle: "Verified"),
    Profile2ListModel(
        imgUrl: AppAssets().topcontributor, tiitle: "Top ContributorV"),
    Profile2ListModel(imgUrl: AppAssets().verified, tiitle: "Verified"),
    Profile2ListModel(
        imgUrl: AppAssets().topcontributor, tiitle: "Top ContributorV")
  ];
}
