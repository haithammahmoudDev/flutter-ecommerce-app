// import 'dart:async';
//
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:fit_store/data/services/navigation_service.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//  import 'package:get_storage/get_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
//
// import '../../../features/dashboard/course/screens/dashboard/coursesDashboard.dart';
//
//  import '../../../routes/routes.dart';
//
// import '../../../utils/exceptions/firebase_auth_exceptions.dart';
// import '../../../utils/exceptions/firebase_exceptions.dart';
// import '../../../utils/exceptions/format_exceptions.dart';
// import '../../../utils/exceptions/platform_exceptions.dart';
// import '../../../utils/local_storage/storage_utility.dart';
// import '../../../utils/popups/loaders.dart';
//
// import '../user_repository/user_repository.dart';
//
// part 'auth_state.dart';
//
// class AuthCubit extends Cubit<AuthState> {
//   AuthCubit()
//       : super(
//     AuthState(
//       firebaseUser: FirebaseAuth.instance.currentUser,
//     ),
//   ) {
//     _firebaseUserSubscription = _auth.userChanges().listen((user) {
//       emit(
//         state.copyWith(
//           firebaseUser: user,
//           clearFirebaseUser: user == null,
//         ),
//       );
//     });
//
//   // WidgetsBinding.instance.addPostFrameCallback((_) {
//   //   screenRedirect(state.firebaseUser);
//   // });
//   }
//
//   final deviceStorage = GetStorage();
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   StreamSubscription<User?>? _firebaseUserSubscription;
//
//   int? _resendToken;
//
//   bool isPhoneAutoVerified = false;
//
//   //=========================
//   // Getters
//   //=========================
//
//   User? get firebaseUser => state.firebaseUser;
//
//   String get getUserID => firebaseUser?.uid ?? '';
//
//   String get getUserEmail => firebaseUser?.email ?? '';
//
//   String get getDisplayName => firebaseUser?.displayName ?? '';
//
//   String get getPhoneNo => firebaseUser?.phoneNumber ?? '';
//
//   //=========================
//   // Screen Redirect
//   //=========================
//
//   Future<void> screenRedirect(BuildContext context) async {
//     if (!context.mounted) return;
//
//     final user = firebaseUser;
//
//     if (user != null) {
//       final idTokenResult = await user.getIdTokenResult();
//
//       if (!context.mounted) return;
//
//       if (user.emailVerified ||
//           user.phoneNumber != null ||
//           idTokenResult.claims?['admin'] == true) {
//         await TLocalStorage.init(user.uid);
//
//         if (!context.mounted) return;
//
//         Navigator.of(context).pushNamedAndRemoveUntil(
//           TRoutes.coursesDashboard,
//               (route) => false,
//         );
//       } else {
//         Navigator.of(context).pushNamedAndRemoveUntil(
//           TRoutes.verifyEmailScreen,
//               (route) => false,
//           arguments: user.email,
//         );
//       }
//     } else {
//       deviceStorage.writeIfNull('isFirstTime', true);
//
//       final bool isFirstTime =
//           deviceStorage.read('isFirstTime') ?? true;
//
//       if (!context.mounted) return;
//
//       if (isFirstTime) {
//         deviceStorage.write('isFirstTime', false);
//
//         Navigator.of(context).pushNamedAndRemoveUntil(
//           TRoutes.onboarding,
//               (route) => false,
//         );
//       } else {
//         Navigator.of(context).pushNamedAndRemoveUntil(
//           TRoutes.welcome,
//               (route) => false,
//         );
//       }
//     }
//   }
//
//   //=========================
//   // Phone Verification
//   //=========================
//
//   void clearPhoneNoVerificationId() {
//     emit(
//       state.copyWith(
//         phoneNoVerificationId: '',
//       ),
//     );
//   }
//   /* ----------------------------
//    * Email & Password Authentication
//    * ---------------------------- */
//
//   /// Login
//   Future<UserCredential> loginWithEmailAndPassword(
//       String email,
//       String password,
//       ) async {
//     try {
//       return await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (_) {
//       throw 'Something went wrong. Please try again';
//     }
//   }
//
//   /// Register
//   Future<UserCredential> registerWithEmailAndPassword(
//       String email,
//       String password,
//       ) async {
//     try {
//       return await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (_) {
//       throw 'Something went wrong. Please try again';
//     }
//   }
//
//   /// Reauthenticate
//   Future<void> reAuthenticateWithEmailAndPassword(
//       String email,
//       String password,
//       ) async {
//     try {
//       final credential = EmailAuthProvider.credential(
//         email: email,
//         password: password,
//       );
//
//       await _auth.currentUser!
//           .reauthenticateWithCredential(credential);
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (_) {
//       throw 'Something went wrong. Please try again';
//     }
//   }
//
//   /// Send Email Verification
//   Future<void> sendEmailVerification() async {
//     try {
//       await _auth.currentUser?.sendEmailVerification();
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (_) {
//       throw 'Something went wrong. Please try again';
//     }
//   }
//
//   /// Forgot Password
//   Future<void> sendPasswordResetEmail(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(
//         email: email,
//       );
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (_) {
//       throw 'Something went wrong. Please try again';
//     }
//   }
//   /* ----------------------------
//    * Google Authentication
//    * ---------------------------- */
//
//   // Future<UserCredential?> signInWithGoogle() async {
//   //   try {
//   //     //final GoogleSignInAccount? googleUser =
//   //    // await GoogleSignIn().signIn();
//   //
//   //     if (googleUser == null) return null;
//   //
//   //     final GoogleSignInAuthentication googleAuth =
//   //     await googleUser.authentication;
//   //
//   //     final credential = GoogleAuthProvider.credential(
//   //       //accessToken: googleAuth.accessToken,
//   //       idToken: googleAuth.idToken,
//   //     );
//   //
//   //     return await _auth.signInWithCredential(credential);
//   //   } on FirebaseAuthException catch (e) {
//   //     throw TFirebaseAuthException(e.code).message;
//   //   } on FirebaseException catch (e) {
//   //     throw TFirebaseException(e.code).message;
//   //   } on FormatException {
//   //     throw const TFormatException();
//   //   } on PlatformException catch (e) {
//   //     throw TPlatformException(e.code).message;
//   //   } catch (e) {
//   //     debugPrint(e.toString());
//   //     return null;
//   //   }
//   // }
//
//   /* ----------------------------
//    * Phone Authentication
//    * ---------------------------- */
//
//   Future<void> loginWithPhoneNo(String phoneNumber) async {
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         forceResendingToken: _resendToken,
//         timeout: const Duration(minutes: 2),
//
//         verificationFailed: (FirebaseAuthException e) async {
//           debugPrint('verificationFailed => $e');
//
//           await FirebaseCrashlytics.instance
//               .recordError(e, e.stackTrace);
//
//           if (e.code == 'too-many-requests') {
//             NavigationService.pushNamedAndRemoveUntil(
//               TRoutes.welcome,
//             );
//
//             // TLoaders.warningSnackBar(
//             //   title: 'Too many attempts',
//             //   message:
//             //   'Oops! Too many tries. Take a short break and try again soon!',
//             // );
//             return;
//           }
//
//           if (e.code == 'unknown') {
//             NavigationService.pop(false);
//
//             // TLoaders.warningSnackBar(
//             //   title: 'SMS not Sent',
//             //   message:
//             //   'An internal error has occurred, We are working on it!',
//             // );
//             return;
//           }
//
//           // TLoaders.warningSnackBar(
//           //   title: 'Oh Snap',
//           //   message: e.message ?? '',
//           // );
//         },
//
//         codeSent: (
//             String verificationId,
//             int? resendToken,
//             ) {
//           emit(
//             state.copyWith(
//               phoneNoVerificationId: verificationId,
//             ),
//           );
//
//           _resendToken = resendToken;
//         },
//
//         verificationCompleted:
//             (PhoneAuthCredential credential) async {
//           final signedInUser =
//           await _auth.signInWithCredential(
//             credential,
//           );
//
//           isPhoneAutoVerified =
//               signedInUser.user != null;
//
//          // await screenRedirect(_auth.currentUser);
//         },
//
//         codeAutoRetrievalTimeout: (verificationId) {
//           debugPrint(
//             'AutoRetrievalTimeout: $verificationId',
//           );
//         },
//       );
//
//       emit(
//         state.copyWith(
//           phoneNo: phoneNumber,
//         ),
//       );
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (_) {
//       throw 'Something went wrong. Please try again';
//     }
//   }
//
//   Future<bool> verifyOTP(String otp) async {
//     try {
//       final credential =
//       PhoneAuthProvider.credential(
//         verificationId:
//         state.phoneNoVerificationId,
//         smsCode: otp,
//       );
//
//       final result =
//       await _auth.signInWithCredential(
//         credential,
//       );
//
//       return result.user != null;
//     } on FirebaseAuthException catch (e) {
//       await FirebaseCrashlytics.instance
//           .recordError(e, e.stackTrace);
//
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (_) {
//       throw 'Something went wrong. Please try again';
//     } finally {
//       emit(
//         state.copyWith(
//           phoneNo: '',
//         ),
//       );
//
//       isPhoneAutoVerified = false;
//     }
//   }
//   /* ----------------------------
//    * Logout
//    * ---------------------------- */
//
//   Future<void> logout() async {
//     try {
//       await _auth.signOut();
//      // await GoogleSignIn().signOut();
//
//       NavigationService.pushNamedAndRemoveUntil(
//         TRoutes.welcome,
//       );
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (_) {
//       throw 'Something went wrong. Please try again';
//     }
//   }
//
//   /* ----------------------------
//    * Delete Account
//    * ---------------------------- */
//
//   Future<void> deleteAccount() async {
//     try {
//       await UserRepository().removeUserRecord(
//         _auth.currentUser!.uid,
//       );
//
//       await _auth.currentUser?.delete();
//     } on FirebaseAuthException catch (e) {
//       throw TFirebaseAuthException(e.code).message;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (_) {
//       throw 'Something went wrong. Please try again';
//     }
//   }
//
//   @override
//   Future<void> close() async {
//     await _firebaseUserSubscription?.cancel();
//     return super.close();
//   }
// }