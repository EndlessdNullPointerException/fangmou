import 'package:fangmou_app/model/note_model/note_basic_message.dart';
import 'package:fangmou_app/model/note_model/note_main.dart';
import 'package:flutter/widgets.dart';

class FunctionNoteDetailScreenState {
  final bool editMode;
  final int noteType;

  final NoteBasicMessage noteBasicMessage;
  final NoteMain noteMain;

  final TextEditingController editTitle;
  final TextEditingController editMain;

  bool get didAlter => noteBasicMessage.title != editTitle.text || noteMain.main != editMain.text;

  FunctionNoteDetailScreenState({
    required this.editMode,
    required this.noteType,
    required this.editTitle,
    required this.editMain,
    required this.noteBasicMessage,
    required this.noteMain,
  });

  FunctionNoteDetailScreenState.initiateAdd()
    : editMode = true,
      noteBasicMessage = NoteBasicMessage.defaultValue(),
      noteMain = NoteMain.defaultValue(),
      editTitle = TextEditingController(),
      editMain = TextEditingController(),
      noteType = 0;

  FunctionNoteDetailScreenState.initiateEdit({required this.noteType, required this.noteBasicMessage, required this.noteMain})
    : editMode = true,
      editTitle = TextEditingController(text: noteBasicMessage.title),
      editMain = TextEditingController(text: noteMain.main);

  FunctionNoteDetailScreenState.initiateView({required this.noteType, required this.noteBasicMessage, required this.noteMain})
    : editMode = false,
      editTitle = TextEditingController(text: noteBasicMessage.title),
      editMain = TextEditingController(text: noteMain.main);

  FunctionNoteDetailScreenState copyWith({
    bool? editMode,
    int? noteType,
    NoteBasicMessage? noteBasicMessage,
    NoteMain? noteMain,
    TextEditingController? editTitle,
    TextEditingController? editMain,
  }) {
    return FunctionNoteDetailScreenState(
      editMode: editMode ?? this.editMode,
      noteType: noteType ?? this.noteType,
      noteBasicMessage: noteBasicMessage ?? this.noteBasicMessage,
      noteMain: noteMain ?? this.noteMain,
      editTitle: editTitle ?? this.editTitle,
      editMain: editMain ?? this.editMain,
    );
  }
}
