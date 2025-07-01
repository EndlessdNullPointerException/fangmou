import 'dart:io';

import 'package:fangmou_app/domain/use_cases/UnzipProcessor.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../domain/use_cases/FileBatchProcessor.dart';
import '../main.dart';
import '../utils/constants/constants.dart';

Future<void> setupDomainUserCase() async {
  getIt.registerLazySingleton<FileBatchProcessor>(() => FileBatchProcessor());
  getIt.registerLazySingleton<UnzipProcessor>(() => UnzipProcessor());

  // 注册全局导航键
  getIt.registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>(debugLabel: 'root'));
}
