import 'dart:io';

import 'package:fangmou_app/screens/function_decompress_screen/function_decompress_screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:get_it/get_it.dart';

import '../../domain/use_cases/decompress_processor.dart';
import '../../utils/constants/constants.dart';

part 'function_decompress_screen_viewmodel.g.dart';

@riverpod
class FunctionDecompressScreenViewModel extends _$FunctionDecompressScreenViewModel {
  final decompressProcessor = GetIt.I.get<DecompressProcessor>();

  // 在 ViewModel 中获取当前状态，提供默认值
  FunctionDecompressScreenState getCurrentState() {
    return switch (state) {
      AsyncData(value: final value) => value,
      AsyncError() => throw Exception("FunctionDecompressScreenViewModel 获取异步状态出现错误"),
      _ => FunctionDecompressScreenState.initial([]),
    };
  }

  // 从本地异步获取解压密码
  @override
  Future<FunctionDecompressScreenState> build() async {
    List<String> passwordList = await decompressProcessor.getPassword();
    logger.d(passwordList.length);
    List<TextEditingController> controllerList = passwordList.map((pw) => TextEditingController(text: pw)).toList();
    logger.d(controllerList.length);
    return FunctionDecompressScreenState.initial(controllerList);
  }

  // 从本地获取解压密码
  Future<void> getDecompressPasswordLocal() async {
    final current = getCurrentState();

    List<String> passwordList = await decompressProcessor.getPassword();
    List<TextEditingController> controllerList = passwordList.map((pw) => TextEditingController(text: pw)).toList();
    state = AsyncValue.data(current.copyWith(passwordControllerList: controllerList));
  }

  // 保存解压密码到本地
  void saveDecompressPasswordLocal() {
    decompressProcessor.savePassword(getCurrentState().passwordList);
  }

  // 解压操作
  decompress() async {
    final current = getCurrentState();

    List<File> files = await decompressProcessor.getCompressedFiles(current.pathController.text, current.decompressDescendantFolder);

    for (File f in files) {
      // 不加上 await 的话，程序会同时开启多个异步任务，导致系统卡顿甚至卡死
      // TODO 修改异步任务执行方式，在不影响系统性能的情况下，尽可能的异步执行
      await decompressProcessor.extractArchive(f, getCurrentState().passwordList);
    }
  }

  // 新增密码项
  void addPasswordItem() {
    final current = getCurrentState();
    final newList = [...current.passwordControllerList, TextEditingController()];
    state = AsyncValue.data(current.copyWith(passwordControllerList: newList));
  }

  // 删除密码项
  void deletePasswordItem(TextEditingController item) {
    final current = getCurrentState();
    var newPasswordControllerList = getCurrentState().passwordControllerList.where((i) => i != item).toList();

    state = AsyncValue.data(current.copyWith(passwordControllerList: newPasswordControllerList));

    logger.d(getCurrentState().passwordControllerList.length);
  }

  // 修改 state 状态
  void changeDecompressDescendantFolder(bool? value) {
    final current = getCurrentState();
    state = AsyncValue.data(current.copyWith(decompressDescendantFolder: value));
  }
}
