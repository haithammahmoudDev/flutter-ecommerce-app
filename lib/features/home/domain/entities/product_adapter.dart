// import 'package:fit_store/features/store/domain/entities/brand_entity.dart';
// import 'package:fit_store/features/home/domain/entities/product_variation_entity.dart';
// import 'package:hive_ce/hive.dart';
// import 'package:fit_store/features/home/domain/entities/product_entity.dart';
// import '../../domain/entities/product_attribute_entity.dart';
//
// class ProductEntityAdapter extends TypeAdapter<ProductEntity> {
//   @override
//   final int typeId = 33;
//
//   @override
//   ProductEntity read(BinaryReader reader) {
//     // 1. قراءة المتغيرات الأساسية بالترتيب الثنائي الصحيح
//     final id = reader.readString();
//     final title = reader.readString();
//     final price = reader.readDouble();
//     final thumbnail = reader.readString();
//     final productType = reader.readString();
//     final salePrice = reader.read() as double?;
//     final description = reader.read() as String?;
//
//     // [تعديل] قراءة قيمة الـ stock كـ int من الملف الثنائي
//     final stock = reader.readInt();
//
//     // 2. قراءة وتحويل القوائم المعقدة بأمان
//     final rawImages = reader.read();
//     final List<String>? images = rawImages != null ? List<String>.from(rawImages as List) : null;
//
//     final brand = reader.read() as BrandEntity;
//
//     final rawAttributes = reader.read();
//     final List<ProductAttributeEntity>? productAttributes = rawAttributes != null
//         ? (rawAttributes as List).cast<ProductAttributeEntity>()
//         : null;
//
//     final rawVariations = reader.read();
//     final List<ProductVariationEntity>? productVariations = rawVariations != null
//         ? (rawVariations as List).cast<ProductVariationEntity>()
//         : null;
//
//     return ProductEntity(
//       id: id,
//       title: title,
//       price: price,
//       thumbnail: thumbnail,
//       productType: productType,
//       salePrice: salePrice,
//       description: description,
//       stock: stock, // [تعديل] تمرير المتغير المقروء لتلبية شرط الـ required
//       images: images,
//       brand: brand,
//       productAttributes: productAttributes,
//       productVariations: productVariations,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, ProductEntity obj) {
//     // كتابة وحفظ البيانات بشكل ثنائي متناسق مع الترتيب بالأعلى تماماً
//     writer.writeString(obj.id);
//     writer.writeString(obj.title);
//     writer.writeDouble(obj.price);
//     writer.writeString(obj.thumbnail);
//     writer.writeString(obj.productType);
//     writer.write(obj.salePrice);
//     writer.write(obj.description);
//
//     // [تعديل] حفظ قيمة الـ stock الفعلية في الترتيب الصحيح لها
//     writer.writeInt(obj.stock);
//
//     writer.write(obj.images);
//     writer.write(obj.brand);
//     writer.write(obj.productAttributes);
//     writer.write(obj.productVariations);
//   }
// }
