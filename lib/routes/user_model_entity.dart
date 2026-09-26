// import 'package:hive_ce_flutter/adapters.dart';
//
// import '../features/auth/data/models/user_model.dart';
//
// class UserModelAdapter extends TypeAdapter<UserModel> {
//   @override
//   final int typeId = 0; // رقم فريد لهذا النموذج
//
//   @override
//   UserModel read(BinaryReader reader) {
//     // قراءة الحقول بنفس ترتيب كتابتها وبناءً على الـ reader.readByte()
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//
//     return UserModel(
//       id: fields[0] as String,
//       fullName: fields[1] as String,
//       email: fields[2] as String,
//       phoneNumber: fields[3] as String,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, UserModel obj) {
//     // كتابة عدد الحقول ثم كتابة كل حقل مع رقمه التعريفي (Index)
//     writer
//       ..writeByte(4) // عدد الحقول الكلي (0, 1, 2, 3)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.fullName)
//       ..writeByte(2)
//       ..write(obj.email)
//       ..writeByte(3)
//       ..write(obj.phoneNumber);
//   }
// }