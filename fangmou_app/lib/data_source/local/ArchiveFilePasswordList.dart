// user.dart
import 'package:hive/hive.dart';

part 'ArchiveFilePasswordList.g.dart'; // 生成文件

@HiveType(typeId: 0) // 唯一类型ID
class ArchiveFilePasswordList {
  @HiveField(0)
  final List<String> passwordList;

  ArchiveFilePasswordList({required this.passwordList});
}
