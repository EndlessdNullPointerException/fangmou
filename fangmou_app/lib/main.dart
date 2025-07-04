import 'dart:io';

import 'package:fangmou_app/routes/app_router.dart';
import 'package:fangmou_app/utils/constants/constants.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win32/win32.dart';

import 'di/DomainUserCaseDI.dart';
import 'di/locator.dart';

Future<void> main(List<String> arguments) async {
  // 进行依赖注入
  setupLocator();
  setupDomainUserCase();
  showNativeNotification("START UP","!!!!!!");

  // 获取并打印当前应用的启动路径（.exe 文件路径）
  logger.d('应用启动路径: ${Platform.resolvedExecutable}');
  logger.d(arguments);

  runApp(
    ProviderScope(
      // RiverPod 状态管理的作用域
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false, // 关闭调试横幅
      ),
    ),
  );


}
void showNativeNotification(String title, String body) {
  final pTitle = title.toNativeUtf16();
  final pBody = body.toNativeUtf16();

  // 使用 MessageBox 作为简单示例（实际推荐用 Toast 通知）
  MessageBox(
    0, // 无父窗口
    pBody, // 正文
    pTitle, // 标题
    MB_OK | MB_ICONINFORMATION,
  );

  // 释放内存
  free(pTitle);
  free(pBody);
}