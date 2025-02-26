import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/model/dashbord_Score_model.dart';
import 'package:code_structure/core/others/base_view_model.dart';

class SheduleViewModel extends BaseViewModel {
  List<DashBordCompatitbiltyScoreModel> listcompatibilityscore = [
    DashBordCompatitbiltyScoreModel(
        imgUrl: AppAssets().nearby1,
        tiitle: "shayan zahid",
        subTittle: "10 new connection"),
    DashBordCompatitbiltyScoreModel(
        imgUrl: AppAssets().match2,
        tiitle: "shayan zahid",
        subTittle: "10 new connection"),
    DashBordCompatitbiltyScoreModel(
        imgUrl: AppAssets().score1,
        tiitle: "shayan zahid",
        subTittle: "10 new connection"),
    DashBordCompatitbiltyScoreModel(
        imgUrl: AppAssets().match1,
        tiitle: "shayan zahid",
        subTittle: "10 new connection"),
    DashBordCompatitbiltyScoreModel(
        imgUrl: AppAssets().score1,
        tiitle: "shayan zahid",
        subTittle: "10 new connection")
  ];
}
