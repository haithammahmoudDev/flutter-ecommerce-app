import 'package:dartz/dartz.dart';
import 'package:fit_store/common/errors/exceptions.dart';
import 'package:fit_store/common/errors/failure.dart';
import 'package:fit_store/common/network/firebase/database_services.dart';
import 'package:fit_store/features/auth/data/data_source/social_auth_datasource.dart';
import 'package:fit_store/features/auth/domain/entities/user_entity.dart';

import '../../../../common/preferences/loacal_storage_service.dart';
import '../../../settings/data/models/user_model.dart';
import '../../../settings/domain/entities/user_entity.dart';
import '../../domain/repos/social_auth_repo.dart';
import '../models/user_model.dart';

class SocialAuthRepoImple implements SocialAuthRepo {
  final SocialAuthDatasource _socialAuthDatasource;
  final DatabaseServices _databaseServices;

  SocialAuthRepoImple({
    required SocialAuthDatasource socialAuthDatasource,
    required DatabaseServices databaseServices,
  })  : _socialAuthDatasource = socialAuthDatasource,
        _databaseServices = databaseServices;

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final UserModel user = await _socialAuthDatasource.signInWithGoogle();

      // Save to Firebase Database
      await _databaseServices.setData(
        path: 'users',
        docId: user.id,
        data: user.toJson(
          userName: user.fullName,
          phoneNum: user.phoneNumber,
        ),
      );

      await LocalStorageService.userRepo.saveData(user);

      // Convert to domain entity only at the return boundary
      return right(user.toEntity());
    } on AuthException catch (e) {
      return left(AuthFailure(e.toString()));
    } on ServerException catch (e) {
      return left(ServerFailure(e.toString()));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}