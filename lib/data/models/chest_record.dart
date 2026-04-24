import 'package:isar_community/isar.dart';

part 'chest_record.g.dart';

@collection
class ChestRecord {
  ChestRecord({required this.path, required this.ts});

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String path;

  @Index()
  int ts;
}
