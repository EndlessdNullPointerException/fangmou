import 'package:fangmou_app/routes/app_router.dart';
import 'package:fangmou_app/routes/fangmou_routes.dart';
import 'package:fangmou_app/screens/function_note_screen/function_note_list_screen/model/pop_option.dart';
import 'package:fangmou_app/screens/function_note_screen/function_note_list_screen/model/sort_method.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data_source/local/sql_lite/note_local.dart';
import '../../../model/note_model/note_basic_message.dart';
import 'function_note_list_screen_state.dart';

part "function_note_list_screen_viewmodel.g.dart";

@riverpod
class FunctionNoteListScreenViewmodel extends _$FunctionNoteListScreenViewmodel {
  final noteLocal = GetIt.I.get<NoteLocal>();

  // 在 ViewModel 中获取当前状态，提供默认值
  FunctionNoteListScreenState get currentState => switch (state) {
    AsyncData(value: final value) => value,
    AsyncError() => throw Exception("FunctionDecompressScreenViewModel 获取异步状态出现错误"),
    _ => FunctionNoteListScreenState.initiate([]),
  };

  @override
  Future<FunctionNoteListScreenState> build() async {
    return FunctionNoteListScreenState.initiate(await getData());
  }

  void resort(SortMethod sortBy) async {
    final noteMessageList = await getData(
      sortBy: sortBy.field,
      sortDirection: sortBy.direction,
      keyword: currentState.keyword.text,
    );
    state = AsyncValue.data(currentState.copyWith(sortBy: sortBy, noteMessageList: noteMessageList));
  }

  void onPopupMenuSelected(PopOption e) {
    switch (e) {
      case PopOption.manage:
        intoEditMode();
    }
  }

  ///获取数据
  /// 1.从本地获取数据
  /// 2.从云端获取同步数据
  Future<List<NoteBasicMessage>> getData({String? sortBy, String? sortDirection, String? keyword}) async {
    List<NoteBasicMessage> result = [];

    // region <- Logic:获取本地数据 ->
    result = await noteLocal.getNoteBasicMessageList(sortBy: sortBy, sortDirection: sortDirection, keyword: keyword);
    // endregion <- Logic:获取本地数据 ->

    // region <- Logic:获取云端数据 ->
    // endregion <- Logic:获取云端数据 ->
    return result;
  }

  void intoEditMode({int? selectedIndex}) {
    if (!currentState.editMode) {
      state = AsyncValue.data(currentState.copyWith(editMode: true));
      if (selectedIndex != null) {
        currentState.selectedList[selectedIndex] = true;
      }
    }
  }

  void exitEditMode() {
    state = AsyncValue.data(
      currentState.copyWith(editMode: false, selectedList: List.filled(currentState.noteMessageList.length, false)),
    );
  }

  void gotoDetail(String i) {
    if (!currentState.editMode) {
      AppRouter.context!.pushNamed(FangMouRoutes.functionNoteDetail.name,pathParameters:{"id": i});
    }
  }

  void addNote() {
    AppRouter.context!.pushNamed(FangMouRoutes.functionNoteDetail.name,pathParameters:{"id": "add"});
  }

  void selectCheckbox(bool? checkState, int i, NoteBasicMessage noteMessage) {
    currentState.selectedList[i] = checkState ?? false;
    state = AsyncValue.data(currentState.copyWith(selectedList: currentState.selectedList));
  }

  void selectAll(bool value) {
    state = AsyncValue.data(
      currentState.copyWith(selectedList: List.filled(currentState.noteMessageList.length, value)),
    );
  }

  void reverseSelected() {
    state = AsyncValue.data(
      currentState.copyWith(selectedList: currentState.selectedList.map((item) => !item).toList()),
    );
  }

  Future<void> deleteSelected() async {
    final selectedList = currentState.selectedList;

    List<String> deleteIdList = [];
    for (int i = 0; i < selectedList.length; i++) {
      if (selectedList[i]) {
        deleteIdList.add(currentState.noteMessageList[i].id);
      }
    }

    await noteLocal.logicDeleteById(deleteIdList);
    state = AsyncValue.data(
      currentState.copyWith(
        noteMessageList: await noteLocal.getNoteBasicMessageList(),
        selectedList: List.filled(currentState.noteMessageList.length, false),
      ),
    );
  }

  Future<void> search() async {
    final noteMessageList = await getData(
      sortBy: currentState.sortBy.field,
      sortDirection: currentState.sortBy.direction,
      keyword: currentState.keyword.text,
    );
    state = AsyncValue.data(currentState.copyWith(noteMessageList: noteMessageList));
  }
}
