import 'dart:io';

import 'package:fangmou_app/screens/function_unzip_screen/function_unzip_screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:get_it/get_it.dart';

import '../../domain/use_cases/UnzipProcessor.dart';
import '../../utils/constants/constants.dart';

part 'function_unzip_screen_viewmodel.g.dart';

@riverpod
class FunctionUnzipScreenViewModel extends _$FunctionUnzipScreenViewModel {
  final unzipProcessor = GetIt.I.get<UnzipProcessor>();

  // 在 ViewModel 中获取当前状态，提供默认值
  FunctionUnzipScreenState getCurrentState() {
    return switch (state) {
      AsyncData(value: final value) => value,
      AsyncError() => throw Exception("FunctionUnzipScreenViewModel 获取异步状态出现错误"),
      _ => FunctionUnzipScreenState.initial([]),
    };
  }

  // 从本地异步获取解压密码
  @override
  Future<FunctionUnzipScreenState> build() async {
    List<String> passwordList = await unzipProcessor.getPassword();
    logger.d(passwordList.length);
    List<TextEditingController> controllerList = passwordList.map((pw) => TextEditingController(text: pw)).toList();
    logger.d(controllerList.length);
    return FunctionUnzipScreenState.initial(controllerList);
  }

  // 保存密码到本地
  void saveUnzipPasswordLocal() {
    unzipProcessor.savePassword(getCurrentState().passwordList);
  }

  void unzipTest() {
    final file = File("C:\\Users\\11849\\Desktop\\eg\\T1\\rar 密码解压测试.rar");
    unzipProcessor.extractArchive(file, getCurrentState().passwordList);
  }

  void getZipFileTest() async {
    logger.d("获取指定路径下的压缩文件测试");
    List<File> files = await unzipProcessor.getCompressedFiles(getCurrentState().pathController.text, false);
    int i = 1;
    for (File f in files) {
      logger.d(i);
      logger.d("======================");
      logger.d(f.path);
      logger.d("======================");
      logger.d("");
      i++;
    }
  }

  decompress() async {
    final current = getCurrentState();
    if (current.decompressDescendantFolder) {
      logger.d("解压后代文件夹：${current.decompressDescendantFolder}");
    } else {
      logger.d("不解压后代文件夹：${current.decompressDescendantFolder}");
    }

    List<File> files = await unzipProcessor.getCompressedFiles(current.pathController.text, current.decompressDescendantFolder);

    for (File f in files) {
      unzipProcessor.extractArchive(f, getCurrentState().passwordList);
    }
  }

  void addPasswordItem() {
    final current = getCurrentState();
    final newList = [...current.passwordControllerList, TextEditingController()];
    state = AsyncValue.data(current.copyWith(passwordControllerList: newList));
  }

  void deletePasswordItem(TextEditingController item) {
    final current = getCurrentState();
    var newPasswordControllerList = getCurrentState().passwordControllerList.where((i) => i != item).toList();

    state = AsyncValue.data(current.copyWith(passwordControllerList: newPasswordControllerList));

    logger.d(getCurrentState().passwordControllerList.length);
  }

  void changeDecompressDescendantFolder(bool? value) {
    final current = getCurrentState();
    state = AsyncValue.data(current.copyWith(decompressDescendantFolder: value));
  }
}
