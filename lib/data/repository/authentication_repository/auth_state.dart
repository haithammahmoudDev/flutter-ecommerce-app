// part of 'auth_cubit.dart';
//
// class AuthState extends Equatable {
//   const AuthState({
//     this.firebaseUser,
//     this.phoneNo = '',
//     this.phoneNoVerificationId = '',
//   });
//
//   final User? firebaseUser;
//   final String phoneNo;
//   final String phoneNoVerificationId;
//
//   AuthState copyWith({
//     User? firebaseUser,
//     bool clearFirebaseUser = false,
//     String? phoneNo,
//     String? phoneNoVerificationId,
//   }) {
//     return AuthState(
//       firebaseUser: clearFirebaseUser ? null : (firebaseUser ?? this.firebaseUser),
//       phoneNo: phoneNo ?? this.phoneNo,
//       phoneNoVerificationId: phoneNoVerificationId ?? this.phoneNoVerificationId,
//     );
//   }
//
//   @override
//   List<Object?> get props => [firebaseUser, phoneNo, phoneNoVerificationId];
// }