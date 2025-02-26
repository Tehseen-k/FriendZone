import 'package:code_structure/core/others/base_view_model.dart';

class UpcomingEventsDetailModel extends BaseViewModel {
  String? imgUrl;
  String? GroupName;
  String? day;
  String? time;
  String? message;
  UpcomingEventsDetailModel(
      {this.imgUrl, this.GroupName, this.day, this.time, this.message});
}
