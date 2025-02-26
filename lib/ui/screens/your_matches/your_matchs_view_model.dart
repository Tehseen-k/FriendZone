import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/model/your_matches_comment.dart';
import 'package:code_structure/core/model/your_matches_model.dart';
import 'package:code_structure/core/others/base_view_model.dart';

class YourMatchesViewModel extends BaseViewModel {
  ///
  ///            swipable Profile View model
  ///
  ///            profiles
  ///
  List<YourMatchesModel> listYourMatches = [
    YourMatchesModel(
        ImgUrl: AppAssets().score1, name: "shayan zahid", location: "Mardan"),
    YourMatchesModel(
        ImgUrl: AppAssets().score2, name: "shayan zahid", location: "Mardan"),
    YourMatchesModel(
        ImgUrl: AppAssets().score1, name: "shayan zahid", location: "Mardan"),
    YourMatchesModel(
        ImgUrl: AppAssets().score2, name: "shayan zahid", location: "Mardan"),
    YourMatchesModel(
        ImgUrl: AppAssets().score1, name: "shayan zahid", location: "Mardan"),
    YourMatchesModel(
        ImgUrl: AppAssets().score2, name: "shayan zahid", location: "Mardan"),
    YourMatchesModel(
        ImgUrl: AppAssets().score1, name: "shayan zahid", location: "Mardan"),
    YourMatchesModel(
        ImgUrl: AppAssets().score2, name: "shayan zahid", location: "Mardan"),
  ];

  ///
  ///            swipable Profile View model
  ///
  ///            commentss
  ///
  List<YourMatchesCommentModel> listYourMatchesComment = [
    YourMatchesCommentModel(
        ProfilrImgUrl: AppAssets().FacebookIcon,
        UserNamere: "Shanzoo",
        Comment: "kun tala kun talha ",
        time: "6:00 Am"),
    YourMatchesCommentModel(
        ProfilrImgUrl: AppAssets().GoogleIcon,
        UserNamere: "Shanzoo",
        Comment: "kun tala kun talha ",
        time: "6:00 Am"),
    YourMatchesCommentModel(
        ProfilrImgUrl: AppAssets().GoogleIcon,
        UserNamere: "Shanzoo",
        Comment: "kun tala kun talha ",
        time: "6:00 Am"),
    YourMatchesCommentModel(
        ProfilrImgUrl: AppAssets().GoogleIcon,
        UserNamere: "Shanzoo",
        Comment: "kun tala kun talha ",
        time: "6:00 Am"),
    YourMatchesCommentModel(
        ProfilrImgUrl: AppAssets().FacebookIcon,
        UserNamere: "Shanzoo",
        Comment: "kun tala kun talha ",
        time: "6:00 Am"),
    YourMatchesCommentModel(
        ProfilrImgUrl: AppAssets().FacebookIcon,
        UserNamere: "Shanzoo",
        Comment: "kun tala kun talha ",
        time: "6:00 Am"),
    YourMatchesCommentModel(
        ProfilrImgUrl: AppAssets().FacebookIcon,
        UserNamere: "Shanzoo",
        Comment: "kun tala kun talha ",
        time: "6:00 Am"),
    YourMatchesCommentModel(
        ProfilrImgUrl: AppAssets().FacebookIcon,
        UserNamere: "Shanzoo",
        Comment: "kun tala kun talha ",
        time: "6:00 Am"),
    YourMatchesCommentModel(
        ProfilrImgUrl: AppAssets().FacebookIcon,
        UserNamere: "Shanzoo",
        Comment: "kun tala kun talha ",
        time: "6:00 Am"),
    YourMatchesCommentModel(
        ProfilrImgUrl: AppAssets().FacebookIcon,
        UserNamere: "Shanzoo",
        Comment: "kun tala kun talha ",
        time: "6:00 Am"),
    YourMatchesCommentModel(
        ProfilrImgUrl: AppAssets().FacebookIcon,
        UserNamere: "Shanzoo",
        Comment: "kun tala kun talha ",
        time: "6:00 Am")
  ];
}
