import 'package:objectbox/objectbox.dart';

@Entity()
class SettingEntity {
  @Id(assignable: false)
  late int id;

  @Unique(onConflict: ConflictStrategy.fail)
  late String key;

  late String value;

  @Unique(onConflict: ConflictStrategy.replace)
  late String title;

  late String? description;

  late DateTime createdAt;

  late DateTime _updatedAt;

  DateTime get updatedAt => _updatedAt;
  set updatedAt(DateTime value) {
    if (value.isAfter(createdAt)) {
      _updatedAt = value;
    }
  }

  SettingEntity({
    int id = 0,
    required String key,
    required String value,
    required String title,
    String? description,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    this.id = id;
    this.key = key;
    this.value = value;
    this.title = title;
    this.description = description;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }
}
