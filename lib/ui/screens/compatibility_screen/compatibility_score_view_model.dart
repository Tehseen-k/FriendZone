import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/model/key_factor_CS.dart';
import 'package:code_structure/core/others/base_view_model.dart';

class KeyFactorCSViewModel extends BaseViewModel {
  List<KeyFactorComapatibiltyScoreModel> listKeyFactoCS = [
    KeyFactorComapatibiltyScoreModel(imgUrl: AppAssets().group1),
    KeyFactorComapatibiltyScoreModel(imgUrl: AppAssets().group1),
    KeyFactorComapatibiltyScoreModel(imgUrl: AppAssets().group1),
    KeyFactorComapatibiltyScoreModel(imgUrl: AppAssets().group1),
    KeyFactorComapatibiltyScoreModel(imgUrl: AppAssets().group1),
    KeyFactorComapatibiltyScoreModel(imgUrl: AppAssets().group1)
  ];
}
