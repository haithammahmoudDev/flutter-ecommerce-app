import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_store/features/home/domain/entities/banners_entity.dart';
import 'package:fit_store/features/home/domain/repos/home_repo.dart';
import 'package:fit_store/features/store/data/models/brand_model.dart';
 import 'package:meta/meta.dart';

import '../../../../../common/preferences/loacal_storage_service.dart';
import '../../../../../utils/helpers/network_manager.dart';
import '../../../data/model/banners_model.dart';

part 'promo_slider_state.dart';

class PromoSliderCubit extends Cubit<PromoSliderState> {
  final HomeRepo _homeRepo;

  PromoSliderCubit({required HomeRepo homeRepo})
      : _homeRepo = homeRepo,
        super(PromoSliderState());

  void onPageChanged(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> fetchBanners() async {
    final List<BannerModel>? bannersListCached = LocalStorageService.bannersRepo.getData();
    final bool isConnectedInternet = await NetworkManager.instance
        .isConnected();
    if (isConnectedInternet) {
      final result = await _homeRepo.fetchBanners();
     print(bannersListCached);
      result.fold(
            (failure) {
          emit(state.copyWith(
            status: PromoSliderEnum.error,
            errorMessage: failure.message,
          ));
        },
            (success) {
          emit(state.copyWith(
            status: PromoSliderEnum.loaded,
            bannerEntityList: success,
          ));
        },
      );
    } else {
      if (bannersListCached != null && bannersListCached.isNotEmpty) {
        emit(state.copyWith(
          status: PromoSliderEnum.loaded,
          bannerEntityList: bannersListCached.map((e) => e.toEntity()).toList(),
        ));
      } else {
        emit(state.copyWith(
          status: PromoSliderEnum.error,
          errorMessage: "No internet connection, please check your network.",
        ));
      }
    }
  }
}