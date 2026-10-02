import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_store/common/network/firebase/database_services.dart';
import 'package:fit_store/common/preferences/preferences_manager.dart';
import 'package:fit_store/common/preferences/local_reo.dart';
import 'package:fit_store/common/widgets/success_screen/success_screen.dart';
import 'package:fit_store/features/auth/data/models/user_model.dart';
import 'package:fit_store/features/auth/domain/repos/verify_email_repo.dart';
import 'package:fit_store/features/auth/presentation/screens/login/login_screen.dart';
import 'package:fit_store/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../common/preferences/loacal_storage_service.dart';
import '../../../../settings/data/models/user_model.dart';

part 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final VerifyEmailRepo _verifyEmailRepo;
  final DatabaseServices _databaseServices;
  VerifyEmailCubit({required this._verifyEmailRepo, required this._databaseServices}) : super(VerifyEmailState());

  Future<void> sendVerificationEmail() async{
   final result =  await _verifyEmailRepo.sendEmailVerification();
  result.fold((error){
    emit(state.copyWith(status: VerifyEmailStatus.failure, message: error.message));
  }, (right){
    emit(state.copyWith(status: VerifyEmailStatus.sent,
        message:'A verification email has been sent. Please check your'
            ' inbox and verify your email.',
    ));
  });
  }

  Future<void> resendVerificationEmail() async{
    emit(state.copyWith(status: VerifyEmailStatus.resendLoading));
    final result =  await _verifyEmailRepo.sendEmailVerification();
    result.fold((error){
      emit(state.copyWith(status: VerifyEmailStatus.failure, message: error.message));
    }, (right){
      emit(state.copyWith(status: VerifyEmailStatus.sent,
        message:'A verification email has been sent. Please check your'
            ' inbox and verify your email.',
      ));
    });
  }

  // Future<void> setTimerForAutoRedirect(BuildContext context, VerifyEmailCubit controller)async {
  //   Timer.periodic(const Duration(seconds: 1), (timer) async{
  //    await FirebaseAuth.instance.currentUser?.reload();
  //    final user = FirebaseAuth.instance.currentUser;
  //    if(user?.emailVerified ?? false){
  //      timer.cancel();
  //      Navigator.pushReplacementNamed(
  //        context,
  //        SuccessScreen.routeName,
  //        arguments: {
  //          'image': TImages.successfullyRegisterAnimation,
  //          'title': AppTexts.yourAccountCreatedTitle,
  //          'subTitle': AppTexts.yourAccountCreatedSubTitle,
  //          'onPressed': () {
  //            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
  //          },
  //        },
  //      );
  //
  //    }
  //   });
  // }

  Future<void> checkEmailVerificationStatus(BuildContext context, VerifyEmailCubit controller) async {
    emit(state.copyWith(status: VerifyEmailStatus.checkLoading));
    try {
      await FirebaseAuth.instance.currentUser?.reload(); // ✅ السطر المهم
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
       final userData = await _databaseServices.getData(path: 'user', docId: user.uid);
       final UserModel userModel = UserModel.fromJson(userData as Map<String, dynamic>);
       await LocalStorageService.userRepo.saveData(userModel);
       emit(state.copyWith(status: VerifyEmailStatus.verified));
      } else {
        emit(state.copyWith(
          status: VerifyEmailStatus.failure,
          message: 'Email is not verified yet.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: VerifyEmailStatus.failure,
        message: 'حدث خطأ أثناء التحقق: ${e.toString()}',
      ));
    }
  }
}
