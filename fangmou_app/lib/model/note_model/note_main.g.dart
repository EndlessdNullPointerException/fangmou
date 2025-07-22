// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteMain _$NoteMainFromJson(Map<String, dynamic> json) => NoteMain(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdateAt: DateTime.parse(json['lastUpdateAt'] as String),
      main: json['main'] as String,
    );

Map<String, dynamic> _$NoteMainToJson(NoteMain instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdateAt': instance.lastUpdateAt.toIso8601String(),
      'main': instance.main,
    };
