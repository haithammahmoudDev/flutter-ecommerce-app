// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fit_store/common/network/firebase/auth_client.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../common/errors/exceptions.dart';
// import '../../../common/network/firebase/database_services.dart';
// import '../../../common/network/firebase/storage_service.dart';
// import '../../../features/auth/data/models/user_model.dart';
//
// class ProfileDatasource {
//   final DatabaseServices _databaseServices;
//   final AuthClient _authClient;
//   final StorageService _storageService;
//   ProfileDatasource(this._databaseServices, {required this._authClient, required this._storageService});
//
//   Future<UserModel> getUserData() async {
//     try {
//       final data = await _databaseServices.getData(
//         path: 'users',
//         docId: FirebaseAuth.instance.currentUser!.uid,
//       );
//
//       return UserModel.fromJson(data);
//     } on FirebaseException catch (e) {
//       throw ServerException(
//         e.message ?? 'Failed to get user data',
//       );
//     } catch (e) {
//       throw ServerException(
//         'Unexpected error: $e',
//       );
//     }
//   }
//
//   Future<void> updateUser(UserModel user) async {
//     try {
//       await _databaseServices.setData(
//         path: 'users',
//         docId: FirebaseAuth.instance.currentUser!.uid,
//         data: user.toJson(userName: user.fullName, phoneNum: user.phoneNumber),
//       );
//     } on FirebaseException catch (e) {
//       throw ServerException(
//         e.message ?? 'Failed to update user data',
//       );
//     } catch (e) {
//       throw ServerException(
//         'Unexpected error: $e',
//       );
//     }
//   }
//
//   Future<void> logOut() async{
//     try {
//       await _authClient.signOut();
//     }on FirebaseAuthException catch(e){
//       throw AuthException(e.toString());
//     }catch(e){
//       throw ServerException(
//         e.toString(),
//       );
//     }
//   }
//
//   Future<String> uploadImageProfile({required File file}) async{
//     try{
//      return await _storageService.uploadFile(file: file, path: 'image_profile');
//     } catch (e) {
//       throw ServerException(
//         'Unexpected error: $e',
//       );
//     }
//   }
//
// Future<void> deleteAcount()async {
//     try{
//      await _authClient.deleteAccount();
//     }catch(e){
//       throw ServerException(e.toString());
//     }
// }
//
// Future<void> reAuthenticateEmailAndPassword(
//   {
//     required String email,
//     required String password,
// }
//     ) async{
//     try{
//       await _authClient.reAuthenticateWithEmailAndPassword(email: email,
//           password: password);
//     }on FirebaseAuthException catch(e){
//       throw AuthException(e.toString());
//     }catch(e){
//       throw ServerException(
//         e.toString(),
//       );
//     }
// }
//
// }