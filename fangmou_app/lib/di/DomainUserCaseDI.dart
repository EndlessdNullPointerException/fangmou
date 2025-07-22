import 'package:fangmou_app/domain/use_cases/decompress_processor.dart';
import 'package:flutter/cupertino.dart';

import '../data_source/local/note_local.dart';
import '../domain/use_cases/FileBatchProcessor.dart';
import '../utils/constants/constants.dart';

void setupDomainUserCase() {
  // region 文件处理
  getIt.registerLazySingleton<FileBatchProcessor>(() => FileBatchProcessor());
  getIt.registerLazySingleton<DecompressProcessor>(() => DecompressProcessor());
  // endregion

  // region  本地数据获取
  getIt.registerLazySingleton<NoteLocal>(
    () => NoteLocal(), // 使用异步工厂
  );
  // endregion

  // 注册全局导航键
  getIt.registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>(debugLabel: 'root'));
}
