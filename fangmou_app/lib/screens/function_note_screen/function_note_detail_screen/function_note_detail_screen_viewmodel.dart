import 'package:fangmou_app/routes/app_router.dart';
import 'package:fangmou_app/routes/fangmou_routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data_source/local/sql_lite/note_local.dart';
import '../../../model/note_model/note_basic_message.dart';
import '../../../model/note_model/note_main.dart';
import 'function_note_detail_screen_state.dart';

part 'function_note_detail_screen_viewmodel.g.dart';

@riverpod
class FunctionNoteDetailScreenViewmodel extends _$FunctionNoteDetailScreenViewmodel {
  final noteLocal = GetIt.I.get<NoteLocal>();

  FunctionNoteDetailScreenState getCurrentState() {
    return switch (state) {
      AsyncData(value: final value) => value,
      AsyncError() => throw Exception("FunctionDecompressScreenViewModel 获取异步状态出现错误"),
      _ => FunctionNoteDetailScreenState.initiateAdd(),
    };
  }

  @override
  Future<FunctionNoteDetailScreenState> build(String id) async {
    FunctionNoteDetailScreenState initiateState;
    if (id.length != 32) {
      initiateState = FunctionNoteDetailScreenState.initiateAdd();
    } else {
      final noteBasicMessage = await noteLocal.getNoteBasicMessageById(id);
      final noteMain = await noteLocal.getNoteMainById(id);

      initiateState = FunctionNoteDetailScreenState.initiateView(
        noteBasicMessage: noteBasicMessage,
        noteMain: noteMain,
        noteType: noteBasicMessage.noteType,
      );
    }

    return initiateState;
  }

  void toEditMode() {
    FunctionNoteDetailScreenState currentState = getCurrentState();
    state = AsyncValue.data(currentState.copyWith(editMode: true));
  }

  void toViewMode() {
    final currentState = getCurrentState();
    // TODO❗❗❗能否做到无需切换模式，即时保存？
    // 暂时不行，flutter 第三方库中没有可以直接进行 markdown 编辑的库
    if (currentState.didAlter) {
      showDialog(
        context: AppRouter.context!,
        barrierDismissible: false,
        builder:
            (ctx) => AlertDialog(
              title: Row(children: [Icon(Icons.error, color: Colors.red), Text("警告")]),
              content: Text("是否放弃已经做出的修改", textAlign: TextAlign.center),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(AppRouter.context!);
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    state = AsyncValue.data(currentState.copyWith(editMode: false));
                    Navigator.pop(AppRouter.context!);
                  },
                  child: Text('放弃'),
                ),
              ],
            ),
      );
    } else {
      state = AsyncValue.data(currentState.copyWith(editMode: false));
    }
  }

  void back() {
    final currentState = getCurrentState();
    if (currentState.didAlter) {
      showDialog(
        context: AppRouter.context!,
        barrierDismissible: false,
        builder:
            (ctx) => AlertDialog(
              title: Row(children: [Icon(Icons.error, color: Colors.red), Text("警告")]),
              content: Text("是否放弃已经做出的修改", textAlign: TextAlign.center),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(AppRouter.context!);
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    state = AsyncValue.data(currentState.copyWith(editMode: false));
                    Navigator.pop(AppRouter.context!);
                    AppRouter.context!.push(FangMouRoutes.functionNote.path);

                  },
                  child: Text('放弃'),
                ),
              ],
            ),
      );
    } else {
      AppRouter.context!.push(FangMouRoutes.functionNote.path);
    }
  }

  Future<void> save() async {
    final currentState = getCurrentState();

    String id = currentState.noteBasicMessage.id;
    String now = DateTime.now().toIso8601String();
    String title = currentState.editTitle.text;
    String main = currentState.editMain.text;
    String excerpt = main.length > 300 ? main.substring(0, 300).trimRight() : main;
    int noteType = currentState.noteBasicMessage.noteType;

    await noteLocal.insertOrUpdateNote(
      id: id,
      now: now,
      excerpt: excerpt,
      title: title,
      noteType: noteType,
      main: main,
    );

    NoteBasicMessage noteBasicMessageResult = await noteLocal.getNoteBasicMessageById(id);
    NoteMain noteMainResult = await noteLocal.getNoteMainById(id);

    state = AsyncValue.data(
      currentState.copyWith(noteBasicMessage: noteBasicMessageResult, noteMain: noteMainResult, editMode: true),
    );
  }

  /// 触发状态改变，以此更新UI
  /// 具体使用场景：修改笔记后，用于解锁保存按钮
  void changed(String value) {
    final currentState = getCurrentState();
    state = AsyncValue.data(currentState.copyWith());
  }
}
