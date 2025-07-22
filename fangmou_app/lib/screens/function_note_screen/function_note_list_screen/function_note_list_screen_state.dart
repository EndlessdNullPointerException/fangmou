import 'package:fangmou_app/screens/function_note_screen/function_note_list_screen/model/sort_method.dart';
import 'package:flutter/material.dart';

import '../../../model/note_model/note_basic_message.dart';

class FunctionNoteListScreenState {
  final bool editMode;
  final SortMethod sortBy;
  final TextEditingController keyword;
  final List<NoteBasicMessage> noteMessageList;
  final List<bool> selectedList;

  bool get selectedAll => selectedList.every((element) => element);

  FunctionNoteListScreenState({
    required this.editMode,
    required this.sortBy,
    required this.keyword,
    required this.noteMessageList,
    required this.selectedList,
  });

  FunctionNoteListScreenState.initiate(this.noteMessageList)
    : editMode = false,
      keyword = TextEditingController(),
      sortBy = SortMethod.updateTimeDesc,
      selectedList = List.filled(noteMessageList.length, false);

  FunctionNoteListScreenState copyWith({
    bool? editMode,
    SortMethod? sortBy,
    TextEditingController? keyword,
    List<NoteBasicMessage>? noteMessageList,
    List<bool>? selectedList,
  }) {
    return FunctionNoteListScreenState(
      editMode: editMode ?? this.editMode,
      sortBy: sortBy ?? this.sortBy,
      keyword: keyword ?? this.keyword,
      noteMessageList: noteMessageList ?? this.noteMessageList,
      selectedList: selectedList ?? this.selectedList,
    );
  }
}
