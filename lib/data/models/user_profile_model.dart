import 'package:hive/hive.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 0)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  late String uid;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late DateTime createdAt;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
  });
}
