// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_basic_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteBasicMessage _$NoteBasicMessageFromJson(Map<String, dynamic> json) => NoteBasicMessage(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastUpdateAt: DateTime.parse(json['lastUpdateAt'] as String),
  title: json['title'] as String,
  excerpt: json['excerpt'] as String,
  noteType: (json['noteType'] as num).toInt(),
);

Map<String, dynamic> _$NoteBasicMessageToJson(NoteBasicMessage instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastUpdateAt': instance.lastUpdateAt.toIso8601String(),
  'title': instance.title,
  'excerpt': instance.excerpt,
  'noteType': instance.noteType,
};
