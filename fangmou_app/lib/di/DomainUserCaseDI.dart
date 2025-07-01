import 'package:fangmou_app/domain/use_cases/decompress_processor.dart';
import 'package:flutter/cupertino.dart';

import '../domain/use_cases/FileBatchProcessor.dart';
import '../utils/constants/constants.dart';

Future<void> setupDomainUserCase() async {
  getIt.registerLazySingleton<FileBatchProcessor>(() => FileBatchProcessor());
  getIt.registerLazySingleton<DecompressProcessor>(() => DecompressProcessor());

  // 注册全局导航键
  getIt.registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>(debugLabel: 'root'));
}
