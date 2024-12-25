
import 'package:objectbox/objectbox.dart';

@Entity()
class ConnectionSetEntity {
  @Id()
  late int id;

  @Unique()
  late String name;

  late String host;

  late int port;

  late DateTime createdAt;

  late DateTime _updatedAt;

  DateTime get updatedAt => _updatedAt;
  set updatedAt(DateTime value) {
    if (value.isAfter(createdAt)) {
      _updatedAt = value;
    }
  }

  ConnectionSetEntity({
    int id = 0,
    required String name,
    required String host,
    required int port,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    this.id = id;
    this.name = name;
    this.host = host;
    this.port = port;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }
}