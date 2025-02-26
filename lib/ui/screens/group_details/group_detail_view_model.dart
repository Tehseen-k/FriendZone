import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/model/Upcoming_events_detail.dart';
import 'package:code_structure/core/model/detail_idk.dart';
import 'package:code_structure/core/others/base_view_model.dart';

class GroupDetailsViewModel extends BaseViewModel {
  ///
  ///
  ///         Details screen first grid view
  ///
  ///
  List<DetailsIdkModel> listDetailIdk = [
    DetailsIdkModel(
      imgUrl: AppAssets().group1,
    ),
    DetailsIdkModel(
      imgUrl: AppAssets().detail1,
    ),
    DetailsIdkModel(
      imgUrl: AppAssets().detail22,
    ),
    DetailsIdkModel(
      imgUrl: AppAssets().detail22,
    ),
    DetailsIdkModel(
      imgUrl: AppAssets().detail1,
    ),
    DetailsIdkModel(
      imgUrl: AppAssets().detail22,
    ),
    DetailsIdkModel(
      imgUrl: AppAssets().detail4,
    ),
    DetailsIdkModel(
      imgUrl: AppAssets().detail1,
    ),
    DetailsIdkModel(
      imgUrl: AppAssets().detail22,
    ),
    DetailsIdkModel(
      imgUrl: AppAssets().detail4,
    ),
  ];

  ///
  ///
  ///      UpComing events
  List<UpcomingEventsDetailModel> listUpcomingEvents = [
    UpcomingEventsDetailModel(
        imgUrl: AppAssets().nearby1,
        GroupName: "Mountain Hike",
        day: "jun 20",
        time: "10:00 AM",
        message: "join us for hike in the mountain"),
    UpcomingEventsDetailModel(
        imgUrl: AppAssets().nearby1,
        GroupName: "Mountain Hike",
        day: "jun 20",
        time: "10:00 AM",
        message: "join us for hike in the mountain"),
    UpcomingEventsDetailModel(
        imgUrl: AppAssets().nearby1,
        GroupName: "Mountain Hike",
        day: "jun 20",
        time: "10:00 AM",
        message: "join us for hike in the mountain"),
    UpcomingEventsDetailModel(
        imgUrl: AppAssets().nearby1,
        GroupName: "Mountain Hike",
        day: "jun 20",
        time: "10:00 AM",
        message: "join us for hike in the mountain"),
    UpcomingEventsDetailModel(
        imgUrl: AppAssets().nearby1,
        GroupName: "Mountain Hike",
        day: "jun 20",
        time: "10:00 AM",
        message: "join us for hike in the mountain"),
    UpcomingEventsDetailModel(
        imgUrl: AppAssets().nearby1,
        GroupName: "Mountain Hike",
        day: "jun 20",
        time: "10:00 AM",
        message: "join us for hike in the mountain"),
  ];
}
