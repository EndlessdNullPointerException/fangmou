import 'package:json_annotation/json_annotation.dart';

import '../../utils/generator.dart';

part 'note_main.g.dart';

@JsonSerializable()
class NoteMain {
  final String id;
  final DateTime createdAt;
  final DateTime lastUpdateAt;
  final String main;

  const NoteMain({required this.id, required this.createdAt, required this.lastUpdateAt, required this.main});

  NoteMain.defaultValue() : id = generateUuid32(), createdAt = DateTime.now(), lastUpdateAt = DateTime.now(), main = "";

  factory NoteMain.fromJson(Map<String, dynamic> json) => _$NoteMainFromJson(json);

  Map<String, dynamic> toJson() => _$NoteMainToJson(this);
}
