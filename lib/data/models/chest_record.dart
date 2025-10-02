import 'package:hive_flutter/hive_flutter.dart';

part 'chest_record.g.dart';

@HiveType(typeId: 0)
class ChestRecord extends HiveObject {
  @HiveField(0)
  String path;

  @HiveField(1)
  int ts;

  ChestRecord({required this.path, required this.ts});
}
