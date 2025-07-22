import 'package:json_annotation/json_annotation.dart';

import '../../utils/generator.dart';

part 'note_basic_message.g.dart';

@JsonSerializable()
class NoteBasicMessage {
  final String id;

  final DateTime createdAt;
  final DateTime lastUpdateAt;

  final String title;
  final String excerpt;

  // 0 表示使用 markdown 语法
  // 1 表示普通文本
  final int noteType;

  const NoteBasicMessage({
    required this.id,
    required this.createdAt,
    required this.lastUpdateAt,
    required this.title,
    required this.excerpt,
    required this.noteType,
  });

  NoteBasicMessage.defaultValue()
    : id = generateUuid32(),
      createdAt = DateTime.now(),
      lastUpdateAt = DateTime.now(),
      title = "",
      excerpt = "",
      noteType = 0;

  factory NoteBasicMessage.fromJson(Map<String, dynamic> json) => _$NoteBasicMessageFromJson(json);
  Map<String, dynamic> toJson() => _$NoteBasicMessageToJson(this);
}
