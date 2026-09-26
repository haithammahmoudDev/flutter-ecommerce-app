// import 'package:hive_ce/hive.dart';
// import '../../../../utils/constants/enums.dart';
// // 👇 أضف مسار ملف الـ UserModel الخاص بك هنا بشكل صحيح حسب مكان وجوده في مشروعك:
// import '../../features/auth/data/models/user_model.dart';
//
// class UserModelAdapter extends TypeAdapter<UserModel> {
//   @override
//   final int typeId = 0;
//
//   @override
//   UserModel read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//
//     return UserModel(
//       id: fields[0] as String? ?? '',
//       fullName: fields[1] as String? ?? '',
//       userName: fields[2] as String? ?? '',
//       email: fields[3] as String? ?? '',
//       phoneNumber: fields[4] as String? ?? '',
//       profilePicture: fields[5] as String? ?? '',
//       role: fields[6] != null ? AppRole.values[fields[6] as int] : AppRole.user,
//       createdAt: fields[7] as DateTime?,
//       updatedAt: fields[8] as DateTime?,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, UserModel obj) {
//     writer
//       ..writeByte(9)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.fullName)
//       ..writeByte(2)
//       ..write(obj.userName)
//       ..writeByte(3)
//       ..write(obj.email)
//       ..writeByte(4)
//       ..write(obj.phoneNumber)
//       ..writeByte(5)
//       ..write(obj.profilePicture)
//       ..writeByte(6)
//       ..write(obj.role.index)
//       ..writeByte(7)
//       ..write(obj.createdAt)
//       ..writeByte(8)
//       ..write(obj.updatedAt);
//   }
// }