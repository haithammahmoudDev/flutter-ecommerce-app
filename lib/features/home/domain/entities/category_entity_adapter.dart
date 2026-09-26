// import 'package:hive_ce_flutter/adapters.dart';
// import 'categories_entity.dart';
//
// class CategoryEntityAdapter extends TypeAdapter<CategoryEntity> {
//   @override
//   final int typeId = 32;
//
//   @override
//   CategoryEntity read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//
//     // تم إصلاح قراءة الـ id من الحقل رقم 3 بدلاً من تمريها فارغة 🛠️
//     return CategoryEntity(
//       id: fields[3] as String? ?? '', // قراءة الـ id
//       name: fields[0] as String,
//       image: fields[1] as String,
//       isFeatured: fields[2] as bool?,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, CategoryEntity obj) {
//     writer
//       ..writeByte(4) // زيادة عدد الحقول الإجمالية إلى 4 لتشمل الـ id
//       ..writeByte(0)
//       ..write(obj.name)
//       ..writeByte(1)
//       ..write(obj.image)
//       ..writeByte(2)
//       ..write(obj.isFeatured)
//       ..writeByte(3) // إضافة مفتاح الحقل الرابع للـ id
//       ..write(obj.id);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//           other is CategoryEntityAdapter &&
//               runtimeType == other.runtimeType &&
//               typeId == other.typeId;
// }
