import 'package:hive_ce/hive.dart';
import '../../features/home/data/model/banners_model.dart';

class BannerModelAdapter extends TypeAdapter<BannerModel> {
  @override
  final int typeId = 3;

  @override
  BannerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return BannerModel(
      imageUrl: fields[0] as String? ?? '',
      targetScreen: fields[1] as String? ?? '',
      active: fields[2] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, BannerModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)..write(obj.imageUrl)
      ..writeByte(1)..write(obj.targetScreen)
      ..writeByte(2)..write(obj.active);
  }
}