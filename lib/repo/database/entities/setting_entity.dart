import 'package:objectbox/objectbox.dart';

@Entity()
class SettingEntity {
  @Id()
  late int id;

  @Unique()
  late String key;

  late String value;

  @Unique()
  late String title;

  late DateTime createdAt;

  late DateTime updatedAt;

  SettingEntity({
    int id = 0,
    required String key,
    required String value,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    this.id = id;
    this.key = key;
    this.value = value;
    this.title = title;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }
}
