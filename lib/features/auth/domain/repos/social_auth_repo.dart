import 'package:dartz/dartz.dart';
import 'package:fit_store/common/errors/failure.dart';
import 'package:fit_store/features/auth/domain/entities/user_entity.dart';

import '../../../settings/domain/entities/user_entity.dart';

abstract interface class SocialAuthRepo {
  Future<Either<Failure, UserEntity>> signInWithGoogle();
}