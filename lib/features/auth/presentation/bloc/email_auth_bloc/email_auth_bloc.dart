import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_store/utils/popups/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/helpers/network_manager.dart';
import '../../../domain/repos/email_auth_repo.dart';

part 'email_auth_event.dart';
part 'email_auth_state.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
   final EmailAuthRepo _emailAuthRepo;
  EmailAuthBloc({required this._emailAuthRepo}) : super(EmailAuthInitial()) {
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
  }

   Future<void> _onSignInWithEmail(
       SignInWithEmailEvent event,
       Emitter<EmailAuthState> emit,
       ) async{
     emit(EmailAuthLoading());
     final result =await _emailAuthRepo.login(email: event.email, password: event.password);

     result.fold(
             (failure){
           emit(EmailAuthFailure(errorMessage: failure.message));
         }, (success){
               if(FirebaseAuth.instance.currentUser?.emailVerified ?? false){
                 emit(EmailAuthSuccess());
               }else{
                 emit(EmailNotVerified());
               }
     });
   }

   Future<void> _onSignUpWithEmail(
       SignUpWithEmailEvent event,
       Emitter<EmailAuthState> emit,
       ) async{
    emit(EmailAuthLoading());
    final result =await _emailAuthRepo.signUp
      (userName: event.userName,
        email: event.email,
        password: event.password,
        phoneNumber: event.phoneNumber);
    result.fold(
            (failure){
          emit(EmailAuthFailure(errorMessage: failure.message));
        }, (success){
      emit(EmailAuthSuccess());
    });
 }

}

